#################################
### Variables for the runner ####
#################################
variable "allow_cloud_console_ssh" {
  description = "Allow SSH access from the web (cloud console) to the manager"
  default     = false
  type        = bool
}

variable "bucket_name" {
  description = "The name of the bucket to store the cache in"
  type        = string
}
variable "concurrency" {
  description = "The number of concurrent jobs the runner can run"
  default     = 10
  type        = number
}

variable "default_image" {
  description = "The default image to use for jobs"
  default     = "alpine:latest"
  type        = string
}

variable "disk_size_gb" {
  description = "The size of the disk to attach to the runner"
  default     = 25
  type        = number
}

variable "enable_display" {
  description = "Enable display functionality for the runner"
  default     = false
  type        = bool
}

variable "enable_integrity_monitoring" {
  description = "Enable integrity monitoring for the runner"
  default     = true
  type        = bool
}

variable "gitlab_url" {
  description = "The URL of the GitLab instance to register with"
  type        = string
}

variable "host_project" {
  description = "The project where the runner will be deployed"
  type        = string
}

variable "id" {
  description = "The ID of the runner used for naming resources"
  type        = string
}

variable "idle_count" {
  description = "The number of instances to keel on standby"
  default     = 0
  type        = number
}

variable "name" {
  description = "The display name of the runner"
  type        = string
}

variable "network_name" {
  description = "The name of the network to attach the runner to"
  type        = string
}

variable "network_self_link" {
  description = "The self link of the network to attach the runner to"
  type        = string
}

variable "ssh_connection_timeout" {
  description = "The timeout for SSH connections to the runner"
  default     = "2m"
  type        = string
}
variable "ssh_public_key" {
  description = "The public key to use for SSH access to the runner"
  type        = string
  sensitive   = true
}

variable "token" {
  description = "The registration token for the runner"
  type        = string
  sensitive   = true
}

variable "vm_type" {
  description = "The type of VM to deploy"
  default     = "e2-medium"
  type        = string
}

variable "zone" {
  description = "The zone where the runner will be deployed"
  default     = "us-central1-a"
  type        = string
}


variable "observability_settings" {
  description = "The observability settings for the runner"
  nullable    = true
  default     = null
  type = object({
    // The list of enabled receivers. Options are: 'docker_stats', 'hostmetrics'
    metrics_receivers = list(string)
    // The list of enabled exporters. Options are: 'googlecloud', 'prometheusremotewrite'
    metrics_exporters = list(string)
    // The endpoint that the Prometheus exporter should send data to
    // This includes the username and password. See https://grafana.com/blog/2022/05/10/how-to-collect-prometheus-metrics-with-the-opentelemetry-collector-and-grafana/
    prom_endpoint = string
  })
}


#################################
### Outputs for the runner ######
#################################
output "config" {
  description = "The config.toml file for the runner"
  value       = local.config
}




terraform {
  required_providers {
    ct = {
      source  = "poseidon/ct"
      version = "0.13.0"
    }
  }
}