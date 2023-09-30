
resource "random_string" "bucket_name" {
  lower = true
  upper = false
  length = 32
  special = false

}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "example" {
  bucket = random_string.bucket_name.result

tags = {
  UserUuid = var.user_uuid
}

}