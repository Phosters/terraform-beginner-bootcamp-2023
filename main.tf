#https://registry.terraform.io/providers/hashicorp/aws/latest

terraform {
  required_providers {
    terratowns = {
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

 }

provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token = var.terratowns_access_token
}


module "terrahouse_aws" {
  source              = "./modules/terrahouse_aws"
  user_uuid           = var.teacherseat_user_uuid
  bucket_name         = var.bucket_name
  error_html_filepath = var.error_html_filepath
  index_html_filepath = var.index_html_filepath
  content_version     = var.content_version
  assets_path = var.assets_path
}

resource "terratowns_home" "home" {
  name = "Making your Payday Bar"
  description = <<DESCRIPTION
Since I really like Payday candy bars but they cost so much to import
into Canada, I decided I would see how I could my own Paydays bars,
and if they are most cost effective.
DESCRIPTION
  domain_name = "module.terrahouse_aws.cloudfront_url"
  town = "missingo"
  content_version = 1
}