locals {
  config = templatefile("${path.module}/config.toml", {
    BUCKET_NAME         = var.bucket_name
    CACHE_PATH          = var.id
    DEFAULT_IMAGE       = var.default_image
    GITLAB_URL          = var.gitlab_url
    IDLE_COUNT          = var.idle_count
    INSTANCE_GROUP_NAME = local.runner_pool_name
    LIMIT               = var.concurrency
    PROJECT_ID          = var.host_project
    RUNNER_NAME         = var.name
    SSH_TIMEOUT         = var.ssh_connection_timeout
    TOKEN               = var.token
    ZONE                = var.zone
  })
}