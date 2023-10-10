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

}

variable "index_html_filepath" {
  type        = string
  description = "Path to the index.html file"

  validation {
    condition = fileexists(var.index_html_filepath)
    error_message = "The specified index_html_filepath is not a valid file path."
  }
}

variable "error_html_filepath" {
  type        = string
  description = "Path to the error.html file"
  
  validation {
    condition = fileexists(var.error_html_filepath)
    error_message = "The specified error_html_filepath is not a valid file path."
  }
}

variable "content_version" {
  description = "Content version number"
  type        = number
  default     = 1
  validation {
    condition     = var.content_version >= 1
    error_message = "Content version must be a positive integer starting at 1."
  }
}

variable "assets_path"{
  description = "Path to assets folder"
  type = string

}