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
