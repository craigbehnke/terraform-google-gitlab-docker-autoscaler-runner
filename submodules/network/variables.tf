variable "allow_cloud_console_ssh" {
  description = "Allow SSH access from the web (cloud console) to the manager"
  default     = false
  type        = bool
}

variable "host_project" {
  description = "The project where the network will be deployed"
  type        = string
}

variable "region" {
  description = "The region where the network will be deployed"
  type        = string
}



output "self_link" {
  description = "The self link of the network"
  value       = google_compute_network.runner_network.self_link
}

output "name" {
  description = "The name of the network"
  value       = google_compute_network.runner_network.name
}