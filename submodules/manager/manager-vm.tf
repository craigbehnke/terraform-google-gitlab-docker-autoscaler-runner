data "google_compute_image" "manager" {
  family  = "ubuntu-minimal-2204-lts"
  project = "ubuntu-os-cloud"
}

resource "google_service_account_key" "manager-sa" {
  service_account_id = google_service_account.manager-sa.name
}

resource "null_resource" "rebuild_manager" {
  triggers = {
    config = sha1(var.config)
  }
}


resource "google_compute_instance" "manager" {
  # checkov:skip=CKV_GCP_40: Giving the VM an external IP address is required for internet access and is cheaper than other networking products (such as Cloud NAT)
  # checkov:skip=CKV_GCP_38: VM Encryption of the boot disk is not needed at this time, since the VM is not storing any sensitive data
  name                      = "manager"
  machine_type              = var.vm_type
  zone                      = var.zone
  project                   = var.host_project
  allow_stopping_for_update = true
  tags                      = ["manager"]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.manager.self_link
      size  = 30
    }
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  network_interface {
    access_config {
      // Ephemeral IP
      // This is used instead of Cloud NAT because it is SIGNIFICANTLY cheaper (see https://cloud.google.com/nat/pricing/)
    }
    network = var.network_self_link
  }


  metadata = {
    config                 = var.config
    block-project-ssh-keys = true
    ssh-key-to-use         = var.ssh_private_key
  }

  metadata_startup_script = templatefile("${path.module}/init.sh", {
    MANAGER_START_COMMAND = templatefile("${path.module}/manager-start-command.sh", {
      TIMEZONE = var.timezone
    })
  })

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.manager-sa.email
    scopes = ["cloud-platform"]
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  lifecycle {
    replace_triggered_by = [
      null_resource.rebuild_manager.id
    ]
    ignore_changes = [
      metadata["ssh-keys"]
    ]
  }
}