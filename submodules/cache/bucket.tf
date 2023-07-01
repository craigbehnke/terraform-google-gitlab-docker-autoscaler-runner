# Create the storage bucket used for storing the cache between jobs
# tfsec:ignore:google-storage-bucket-encryption-customer-key
resource "google_storage_bucket" "cache" {
  # checkov:skip=CKV_GCP_62: Logs are not needed at this time
  # checkov:skip=CKV_GCP_78: We do not need versioning since the bucket is only used for temporary storage
  name                        = "${var.host_project}-gitlab-cache"
  project                     = var.host_project
  force_destroy               = true
  uniform_bucket_level_access = true
  location                    = var.region

  # Delete objects after 7 days
  # This ensures that we are not using stale cache data or using up too much storage
  lifecycle_rule {
    action {
      type = "Delete"
    }

    condition {
      age = var.cache_max_age
    }
  }

  versioning {
    enabled = false
  }
}