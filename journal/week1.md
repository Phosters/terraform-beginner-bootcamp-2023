# Terraform Beginner Bootcamp 2023 - Week 1

## Root Module Structure
[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

Our root module strucutre is as follows:  // has been turned into ASCII by chatgpt

```
PROJECT ROOT
|-- variables.tf      - stores the structure of input variables
|-- main.tf           - everything else
|-- providers.tf      - defines required providers and their configuration
|-- outputs.tf        - stores our outputs
|-- terraform.tfvars  - the data of variables we want to load into our Terraform project
`-- README.md         - required for root module

  ```

## To migrate state from Terraform cloud to local
First comment or take the cloud block out from your provider

```
  cloud {
    organization = "phosters"

    workspaces {
      name = "terra-house-1"
    }
  }
```
Delete the terraform lock file ie;`terraform.lock.hcl file`
Then delete terraform folder `.terraform`

## Terraform and Input Variables
[Terraform input variables](https://developer.hashicorp.com/terraform/language/values/variables)

## Set up Terraform Cloud Variables
In terraform there are two types of env var
 -Environment Variables  - for those you would set in bash terminals ie; aws credentials
 -Terraform variables    - those that will be set in `tfvars` 
Copy your user Uuid and save it in `terraform.tfvars` for local
In cases where you want it to be reflected in terraform cloud you will set it as a variable in terraform cloud and remember to select `terraform variable`

## Loading terraform variables
### var flag
The var flag is a Terraform CLI flag that allows you to pass variable values to Terraform commands directly. This can be useful for passing one or two variable values, but it is *not recommended for passing a large number of variable values*.
We can use the `var` flag to set an input variable or override a varibale in the tfvars file eg;`terraform -var user_uuid ="my_user_id"`      

### var-file flag

The var-file flag is a Terraform CLI flag that allows you to pass variable values to Terraform commands using a file that contains the values. This is *recommended for passing a large number of variable values*, as it can make your Terraform configurations more reusable and maintainable.

### terraform tfvars
Terraform tfvars files are files that contain variable values. They typically have the .tfvars extension. Terraform tfvars files can be used to pass variable values to Terraform commands using the var-file flag, or they can be used directly in Terraform configurations.

### auto tf vars
Auto tfvars files are a special type of Terraform tfvars file. They are named with the .auto.tfvars extension. Auto tfvars files are loaded automatically by Terraform when it is applied. This can be useful for passing variable values that are generated dynamically, such as the current date and time

### order of terraform variables 
Terraform variables are used to define values that can be used in Terraform configurations. These values can be passed to Terraform commands using the var and var-file flags, or they can be used directly in Terraform configurations.

### Terraform variables are evaluated in the following order:
-Environment variables
-Terraform tfvars files
-Auto tfvars files
-Command-line arguments (including the var flag)
-Variable defaults

This means that variable values in environment variables will override variable values in Terraform tfvars files, and so on

## Terraform import

### What terraform  import really is
Terraform import is a command used to bring existing infrastructure resources under Terraform's management. It is a way to tell Terraform about resources that were created outside of Terraform so that Terraform can track and manage their state.

### Resource Identification
First, identify the resource (in our case S3 bucket) you want to import. You'll need the name of the bucket. For example, if your bucket is named "my-existing-bucket," you can import it using: 

```sh
terraform import aws_s3_bucket.my_bucket my-existing-bucket

```
### Resource Configuration
Next, create a corresponding resource block in your Terraform configuration file (e.g., main.tf) to match the imported resource. For an S3 bucket, it might look like this:
[Aws S3 bucket import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)

```sh
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-existing-bucket"
  acl    = "private"
  # Additional configuration settings as needed
}
```
### Running terraform import
[Terraform import](https://developer.hashicorp.com/terraform/cli/import)
Execute the terraform import command as shown in step 1. `terraform import aws_s3_bucket.my_bucket my-existing-bucket` Terraform will reach out to AWS, identify the existing S3 bucket's details, and import it into Terraform's state. This is helpful when someone deletes a resources through clickOps without our knowledge, terraform will notice the state and add the resouces in our next attempt to run `terraform apply`

### Terraform State
Terraform will create or update its state file (usually named `terraform.tfstate`) to represent the current state of the imported S3 bucket. This state file is crucial for tracking and managing the resource in the future.

If you loose your state file, you would have to tear down all resources manually and `terraform apply` again
You can use an import for this use case, but they will not work 100% in most cases.

### Plan and Apply
After importing, you can use Terraform's standard workflow. Run `terraform plan` to see proposed changes and `terraform apply` to make any desired updates to the S3 bucket's configuration

## Terraform Module 

### Terraform Module Structure
It is recommended to place modules in a `modules` directory when locally developing modules but you can name it whatever you want

### Module Sources
[Modules sources for terraform](https://developer.hashicorp.com/terraform/language/modules/sources#local-paths)

Using terraform modules, we can pass it from multiple sources ie;
- Locally
- Github
- Terraform Registry

### Passing Input Variables
We can pass input variables to our module.
The module has to declare the terraform variables in its own variables.tf

```tf
module "terrahouse_aws" {
    source = "./modules/terrahouse_aws"
    user_uuid = "var.user_uuid"
    bucket_name = "var.bucket_name"
}
```

### Fix Terraform using Refresh only
[Terraform refresh only command](https://developer.hashicorp.com/terraform/cli/commands/refresh)
Used to check updates on terraform locally to see changes

```tf
terraform apply -refresh-only -auto-approve

```

## S3 Staic Website Hosting

### Configure S3 bucket for web hosting
Most reources for configuring s3 web hosting online are depricated so rely on the one from terraform providers
[S3 Bucket Website Configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration)

### Update outputs for static website hosting url
To leverage on the static website endpoint for other activities, you can use outputs to get it
[Outputs for static website hosting](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration#attribute-reference)

## Working with files in in Terraform

### Path Variable
[Path variable for root & module](https://developer.hashicorp.com/terraform/language/expressions/references#path-module)
In terraform, there is a special variable called `path` that allows us reference local paths:
- path.module = get the path for the current module
- path.root = get the path for the root

```
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "${path.root}/public/index.html
}

```

### Etag
[Etag reference](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/ETag)
The ETag (or entity tag) HTTP response header is an identifier for a specific version of a resource. It lets caches be more efficient and save bandwidth, as a web server does not need to resend a full response if the content was not changed. Additionally, etags help to prevent simultaneous updates of a resource from overwriting each other

### Filemd5 hash
[Filemd5 Function](https://developer.hashicorp.com/terraform/language/functions/filemd5)
filemd5 is a variant of md5 that hashes the contents of a given file rather than a literal string.
This is similar to md5(file(filename)), but because file accepts only UTF-8 text it cannot be used to create hashes for binary files.

```tf
etag = filemd5("path/to/file")

```

### File exists function
[Fileexists Function](https://developer.hashicorp.com/terraform/language/functions/fileexists)
A terraform built in function that checks whether a `file exists` or not

```tf
condition = (fileexists(var.index_html_filepath))
```

## Setting up CDN for website hosting
The things required for setting up cloudfront:
- Cloudfront distribution
- Cloudfront Origin access control
- Bucket policy


### Cloudfront-Origin Access Control
[Origin Access Control](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control)
Origin Access identity is deprecated so is recommended to utilise Origin Access Control
Manages an AWS CloudFront Origin Access Control, which is used by CloudFront Distributions with an Amazon S3 bucket as the origin.

```tf
resource "aws_cloudfront_origin_access_control" "example" {
  name                              = "example"
  description                       = "Example Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

```

### Cloudfront distribution
[cloudfront distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution)
Amazon CloudFront is a web service that speeds up distribution of your static and dynamic web content, such as .html, .css, .js, and image files, to your users.

```tf

locals {
  s3_origin_id = "myS3Origin"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.b.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = "mylogs.s3.amazonaws.com"
    prefix          = "myprefix"
  }

  aliases = ["mysite.example.com", "yoursite.example.com"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

```

### Bucket Policy
[S3 Bucket Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy)
Attaches a policy to an S3 bucket resource.

```t

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.example.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json  
}

```
Policy acn be set by giving our own policy defined here by aws
[bucket Policy](https://aws.amazon.com/blogs/networking-and-content-delivery/amazon-cloudfront-introduces-origin-access-control-oac/)

### Jsonencode function - working with Json
jsonencode encodes a given value to a string using JSON syntax.
[Jsonencode function](https://developer.hashicorp.com/terraform/language/functions/jsonencode)

```t
> jsonencode({"hello"="world"})
{"hello":"world"}

```

policy = jsonencode ({
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowCloudFrontServicePrincipalReadOnly",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::DOC-EXAMPLE-BUCKET/*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "arn:aws:cloudfront::ACCOUNT_ID:distribution/DISTRIBUTION_ID"
                }
            }
        },
        {
            "Sid": "AllowLegacyOAIReadOnly",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity EH1HDMB1FH2TC"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::DOC-EXAMPLE-BUCKET/*"
        }
    ]
}
})

### Terraform Data sources
[Terraform Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)
Data sources allow Terraform to use information defined outside of Terraform, defined by another separate Terraform configuration, or modified by functions. used to reference cloud resources without importing them
Example is the [aws_caller_idnetity ](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)

```t
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

```

### Terraform locals
A local value assigns a name to an expression, so you can use the name multiple times within a module instead of repeating the expression. Is useful when we want to transform data into another format and have it referenced a variable
[Terraform local variables](https://developer.hashicorp.com/terraform/language/values/locals)

```t
locals {
  service_name = "forum"
  owner        = "Community Team"
}

```

### Invalidate cache - CDN (Cloudfront)

### Chnging the lifecycle of resources
[Meta lifecycle Argument](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)
Used when there is a change in your environment

```t
  lifecycle {
    create_before_destroy = true
  }

```

### Terraform data 
[Terraform data](https://developer.hashicorp.com/terraform/language/resources/terraform-data)

Plain data values such as Local Values and Input Variables don't have any side-effects to plan against and so they aren't valid in replace_triggered_by. You can use terraform_data's behavior of planning an action each time input changes to indirectly use a plain value to trigger replacement.

```t
variable "revision" {
  default = 1
}

resource "terraform_data" "replacement" {
  input = var.revision
}

# This resource has no convenient attribute which forces replacement,
# but can now be replaced by any change to the revision variable value.
resource "example_database" "test" {
  lifecycle {
    replace_triggered_by = [terraform_data.replacement]
  }
}

```

## Invalidate Cloudfront Distribution
[Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)
Provisioners are used to execute scripts on a **local** or **remote machine** as part of resource creation or destruction. Provisioners can be used to bootstrap a resource, cleanup before destroy, run configuration management. NB: Is not recommended to use provisiorners but use configuration management tools like ansible

 ### Local Exec
 [Local Exec Provisioner](https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec)
 This will execute command on the machine running the terraform commands eg plan, apply
If you are certain that provisioners are the best way to solve your problem after considering the advice in the sections above, you can add a provisioner block inside the resource block of a compute instance.

```t
resource "aws_instance" "web" {
  # ...

  provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip}"
  }
}

```
### Remote Exec
[Remote Exec Provisioner](https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec)
This will execute commands which you target. You will need to provide credentials such as ssh to get into the machine
The remote-exec provisioner invokes a script on a remote resource after it is created. This can be used to run a configuration management tool, bootstrap into a cluster, etc. To invoke a local process, see the local-exec provisioner instead. The remote-exec provisioner requires a connection and supports both ssh and winrm.

```t
resource "aws_instance" "web" {
  # ...

  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
}

```
### File Provisioners
[File Provisoners](https://developer.hashicorp.com/terraform/language/resources/provisioners/file)
The file provisioner copies files or directories from the machine running Terraform to the newly created resource. The file provisioner supports both ssh and winrm type connections.

```t
resource "aws_instance" "web" {
  # ...

  # Copies the myapp.conf file to /etc/myapp.conf
  provisioner "file" {
    source      = "conf/myapp.conf"
    destination = "/etc/myapp.conf"
  }

  # Copies the string in content into /tmp/file.log
  provisioner "file" {
    content     = "ami used: ${self.ami}"
    destination = "/tmp/file.log"
  }

  # Copies the configs.d folder to /etc/configs.d
  provisioner "file" {
    source      = "conf/configs.d"
    destination = "/etc"
  }

  # Copies all files and folders in apps/app1 to D:/IIS/webapp1
  provisioner "file" {
    source      = "apps/app1/"
    destination = "D:/IIS/webapp1"
  }
}

```

### Implementing a Heredoc
[Heredoc Concept](https://www.google.com/search?q=heredoc&rlz=1C1CHBD_enGH1067GH1067&oq=heredoc&gs_lcrp=EgZjaHJvbWUyCQgAEEUYORiABDIHCAEQABiABDIHCAIQABiABDIHCAMQABiABDIHCAQQABiABDIHCAUQABiABDIHCAYQABiABDIHCAcQABiABDIHCAgQABiABDIHCAkQABiABNIBCDE5NDlqMGo3qAIAsAIA&sourceid=chrome&ie=UTF-8)
In computing, a here document is a file literal or input stream literal: it is a section of a source code file that is treated as if it were a separate file;

```sh
<<EOT
%{ for ip in aws_instance.example[*].private_ip ~}
server ${ip}
%{ endfor ~}
EOT

```
The concept behind heredoc is that instead of the entire code been on a single line, we break it down to several lines to get the beneath output, giving you a clean comparted output  NB: Remember to start with EOT and end with it.

```sh
server 10.1.16.154
server 10.1.16.1
server 10.1.16.34

```
