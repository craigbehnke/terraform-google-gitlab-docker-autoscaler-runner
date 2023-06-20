

module "cache" {
  source        = "./submodules/cache"
  host_project  = var.host_project
  region        = var.region
  cache_max_age = var.cache_max_age
}


module "manager" {
  source            = "./submodules/manager"
  config            = local.full_config
  host_project      = var.host_project
  network_self_link = module.network.self_link
  ssh_private_key   = tls_private_key.access_key.private_key_pem
  vm_type           = var.manager_vm_type
  zone              = var.zone
}

module "network" {
  source                  = "./submodules/network"
  allow_cloud_console_ssh = var.allow_cloud_console_ssh
  host_project            = var.host_project
  region                  = var.region
}


module "runner" {
  source   = "./submodules/runner"
  for_each = { for runner in var.runners : runner.id => runner }

  concurrency   = each.value.concurrency
  default_image = each.value.default_image
  disk_size_gb  = each.value.disk_size_gb
  id            = each.value.id
  idle_count    = each.value.idle_count
  name          = each.value.name
  token         = each.value.token
  vm_type       = each.value.vm_type

  allow_cloud_console_ssh = var.allow_cloud_console_ssh
  bucket_name             = module.cache.bucket_name
  gitlab_url              = var.gitlab_url
  host_project            = var.host_project
  network_name            = module.network.name
  network_self_link       = module.network.self_link
  ssh_public_key          = tls_private_key.access_key.public_key_openssh
  zone                    = var.zone
}