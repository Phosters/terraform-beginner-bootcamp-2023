#https://registry.terraform.io/providers/hashicorp/aws/latest

terraform {
  required_providers {
    source = "local.providers/local/terratowns"
    version = "1.0.0"
  }

}
   
#   cloud {
#     organization = "phosters"

#     workspaces {
#       name = "terra-house-1"
#     }
#   }

# }

provider "terratowns" {
  endpoint = "http://localhost:4567"
  user_uuid = "06d1f954-74a5-4bb1-bf8c-596e7e563cd7"
  token = "9b49b3fb-b8e9-483c-b703-97ba88eef8e0"
}


# module "terrahouse_aws" {
#   source              = "./modules/terrahouse_aws"
#   user_uuid           = var.user_uuid
#   bucket_name         = var.bucket_name
#   error_html_filepath = var.error_html_filepath
#   index_html_filepath = var.index_html_filepath
#   content_version     = var.content_version
#   assets_path = var.assets_path
# }

