variable "config" {
  description = "The config.toml file for the manager"
  type        = string
  sensitive   = true
}

variable "host_project" {
  description = "The project where the manager will be deployed"
  type        = string
}

variable "network_self_link" {
  description = "The self link of the network to attach the manager to"
  type        = string
}

variable "ssh_private_key" {
  description = "The private key to use for SSH access to the manager"
  type        = string
  sensitive   = true
}

variable "timezone" {
  description = "The timezone to use for the manager"
  default     = "Etc/UTC"
  type        = string
}

variable "vm_type" {
  description = "The type of VM to deploy"
  default     = "e2-micro"
  type        = string
}

variable "zone" {
  description = "The zone where the manager will be deployed"
  default     = "us-central1-a"
  type        = string
}


output "self_link" {
  description = "The self link of the manager VM"
  value       = google_compute_instance.manager.self_link
}