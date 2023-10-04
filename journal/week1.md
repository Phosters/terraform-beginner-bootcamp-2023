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