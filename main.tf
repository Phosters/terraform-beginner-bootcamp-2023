#https://registry.terraform.io/providers/hashicorp/aws/latest
terraform {
  
  cloud {
    organization = "phosters"

    workspaces {
      name = "terra-house-1"
    }
  }

  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
    aws = {
      source = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}

#https://registry.terraform.io/providers/hashicorp/random/latest
provider "random" {
  # Configuration options
}

resource "random_string" "bucket_name" {
  lower = true
  upper = false
  length = 32
  special = false

}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "example" {
  bucket = random_string.bucket_name.result
}


output "random_bucket_name" {
  value = random_string.bucket_name.result
}
