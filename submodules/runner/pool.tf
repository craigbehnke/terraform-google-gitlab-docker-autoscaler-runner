
data "google_compute_image" "pool_os" {
  family  = "cos-stable"
  project = "cos-cloud"
}

data "cloudinit_config" "cloud_config" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"

    content = templatefile("${path.module}/cloud-config.yaml", {
      SSH_AUTHORIZED_KEY   = var.ssh_public_key
      HOST_METRIC_INTERVAL = var.host_metric_interval
    })
  }
}

/// This is a resource that does nothing but include the pool-ignition.yaml file in the dependency graph
/// Inclusion in the graph then allows us to recreate the runner when the config changes
resource "null_resource" "cloudinit" {
  triggers = {
    config = sha1(data.cloudinit_config.cloud_config.rendered)
  }
}

resource "google_compute_instance_template" "job_runner_template" {
  provider = google-beta
  # checkov:skip=CKV_GCP_40: Giving the VM an external IP address is required for internet access and is cheaper than other networking products (such as Cloud NAT)
  name        = "${var.id}-template"
  description = "Template for job runner instances"
  project     = var.host_project
  tags        = ["runner-pool-${var.id}"]


  instance_description = "VM used for executing a build job"
  machine_type         = var.vm_type
  can_ip_forward       = false

  enable_display = var.enable_display


  // Create a new boot disk from an image
  disk {
    source_image = data.google_compute_image.pool_os.self_link
    auto_delete  = true
    boot         = true
    disk_type    = "pd-ssd"
    disk_size_gb = var.disk_size_gb
  }

  network_interface {
    access_config {
      // Ephemeral IP
      // This is used instead of Cloud NAT because it is SIGNIFICANTLY cheaper (see https://cloud.google.com/nat/pricing/)
    }
    network = var.network_self_link
  }

  metadata = {
    google-logging-enabled    = "true"
    google-monitoring-enabled = var.enable_ops_agent
    block-project-ssh-keys    = true
    user-data                 = data.cloudinit_config.cloud_config.rendered
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.pool-sa.email
    scopes = ["cloud-platform"]
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = var.enable_integrity_monitoring
  }

  scheduling {
    instance_termination_action = "STOP"
    min_node_cpus               = 0
    preemptible                 = true
    provisioning_model          = "SPOT"
    automatic_restart           = false
  }

  lifecycle {
    replace_triggered_by = [
      null_resource.cloudinit.id
    ]
  }
}







resource "google_compute_target_pool" "runner_target_pool" {
  name    = "${var.id}-target-pool"
  project = var.host_project
}


locals {
  runner_pool_name = "${var.id}-runner-pool"
}


resource "google_compute_instance_group_manager" "runner-pool" {
  name    = local.runner_pool_name
  project = var.host_project

  base_instance_name = "${var.id}-instance"
  zone               = var.zone

  version {
    instance_template = google_compute_instance_template.job_runner_template.self_link
  }

  lifecycle {
    replace_triggered_by = [
      google_compute_instance_template.job_runner_template.self_link
    ]
  }

  target_pools = [google_compute_target_pool.runner_target_pool.id]

  update_policy {
    max_unavailable_percent = 50
    minimal_action          = "REPLACE"
    replacement_method      = "SUBSTITUTE"
    type                    = "OPPORTUNISTIC"
  }
}