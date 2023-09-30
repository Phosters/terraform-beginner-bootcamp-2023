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
