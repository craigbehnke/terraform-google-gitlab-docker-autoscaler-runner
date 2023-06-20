output "cache_bucket_name" {
  description = "The name of the GCS bucket containing the cache"
  value       = module.cache.bucket_name
}

output "concurrency" {
  description = "The total number of concurrent jobs all configured runner can simultaneously handle"
  value       = local.total_concurrency
}

output "manager_instance_self_link" {
  description = "The self link of the manager VM instance"
  value       = module.manager.self_link
}

output "network_name" {
  description = "The name of the network all runners are attached to"
  value       = module.network.name
}

output "network_self_link" {
  description = "The self link of the network the runner is attached to"
  value       = module.network.self_link
}
