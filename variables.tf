variable "user_uuid" {
  description = "User UUID in UUID format"
  type        = string

  validation {  
    condition     = can(regex("^([0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})$", var.user_uuid))
    error_message = "User UUID must be in UUID format (e.g., 123e4567-e89b-12d3-a456-426655440000)"
  }
}

variable "bucket_name" {
  description = "Bucket for s3 terraform_bootcamp_bucket_2023"
  type        = string

  validation {
    condition     = regex("^[a-zA-Z0-9.-]{3,63}$", var.bucket_name)
    error_message = "S3 bucket name must be between 3 and 63 characters and only contain letters, numbers, hyphens, or periods"
  }
}

