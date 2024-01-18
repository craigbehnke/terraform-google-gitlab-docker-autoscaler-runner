variable "allow_cloud_console_ssh" {
  description = "Allow SSH access from the web (google cloud console) to the manager"
  default     = false
  type        = bool
}

variable "cache_max_age" {
  description = "The maximum age of an object in the cache in days. Once a cached object passes this age, it will be deleted."
  default     = 7
  type        = number
}

variable "gitlab_url" {
  description = "The URL of the GitLab instance to register with"
  default     = "https://gitlab.com"
  type        = string
}

variable "host_project" {
  description = "The project where the runner will be deployed"
  type        = string
}


variable "manager_vm_type" {
  description = "The type of VM to deploy as the manager"
  default     = "e2-micro"
  type        = string
}

variable "region" {
  description = "The region where the runner will be deployed"
  type        = string
}


variable "runners" {
  description = "Configuration for the runners to deploy (see module variables.tf for descriptions of each member)"
  type = list(object({
    # The ID of the runner used for naming resources
    id = string
    # The display name of the runner
    name = string
    # The registration token for the runner
    token = string

    # The number of concurrent jobs the runner can handle
    concurrency = number
    # The default image to use for jobs
    default_image = string
    # The size of the disk to attach to the job runner
    disk_size_gb = number
    # Enable display functionality for the runner (default: false)
    enable_display = optional(bool, false)
    # Enable integrity monitoring for the runner (default: true) See also: https://cloud.google.com/compute/shielded-vm/docs/shielded-vm#integrity-monitoring
    enable_integrity_monitoring = optional(bool, true)
    # The number of instances to keep on standby
    idle_count = number
    # The number of minutes to wait while connecting to an instance via SSH
    ssh_connection_timeout = number
    # The type of GCE VM to deploy
    vm_type = string
  }))
}

variable "timezone" {
  description = "The timezone to use for the manager -- seen mainly in logs"
  default     = "Etc/UTC"
  type        = string
}

variable "zone" {
  description = "The GCP zone where the runner will be deployed"
  type        = string
}


