output "bucket_name" {
  description = "Bucket name for the static website"
  value = module.terrahouse_aws.bucket_name
}

output "S3_website_endpoint" {
  description = "S3 static website hosting endpoint"
  value = module.terrahouse_aws.website_endpoint
}

output "cloudfront_url" {
  description = "The Cloudfront Distribution Domain name"
  values = module.terrahouse_aws.cloudfront_url
}