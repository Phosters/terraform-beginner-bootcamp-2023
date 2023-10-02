#https://registry.terraform.io/providers/hashicorp/aws/latest
terraform {
  
  cloud {
    organization = "phosters"

    workspaces {
      name = "terra-house-1"
    }
  }


}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name
}


module "terrahouse_aws" {
    source = "./modules/terrahouse_aws"
    user_uuid = var.user_uuid
    bucket_name = var.bucket_name
}