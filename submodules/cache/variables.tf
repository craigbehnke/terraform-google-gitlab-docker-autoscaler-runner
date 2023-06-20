variable "cache_max_age" {
  description = "The maximum age of the cache in days. Once a cache passes this age, it will be deleted."
  type        = number
}

variable "host_project" {
  description = "The project where the runner will be deployed"
  type        = string
}

variable "region" {
  description = "The region where the runner will be deployed"
  type        = string
}


output "bucket_name" {
  description = "The name of the bucket the cache is stored in"
  value       = google_storage_bucket.cache.name
}