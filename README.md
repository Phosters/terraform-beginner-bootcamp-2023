# Terraform Beginner Bootcamp 2023

![Terraform Bootcamp](./images/terraform.jpg)
## Semantic Versioning :mage:

This project leverages semantic versioning for its tagging
[semver.org](https://semver.org/)

The general format would be incremented this way **MAJOR.MINOR.PATCH**, eg: `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes

### Git tags
To create a tag and apply it to the main branch in a Git repository, first, you'll want to be on the main branch. You can switch to the main branch using the following command: `git checkout main`

Once you are on the main branch, you can create a tag using the git tag command, like this:`git tag 0.1.0`
This command creates a tag named "0.1.0" at the current commit on the main branch.

To make this newly created tag take effect and push it to the remote repository, you can use the git push command with the --tags flag: `git push --tags`

### Git Issues
In situation where you forget to create an issue for a branch but later realise you are working in main;
First stash on the main with the below

```
git fetch

git add .

git stash save 

```

After this, create your issue with a branch and then switch to branch and then use this command to bring back the stashed version to be committed, 

```
git stash apply

```



## Links to resources used for this project \

#### How to install terraform on ubuntu
[Terraform install on ubuntu](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

#### Creating a script with shebang identifying the different types and the best one to use
[Shebang comparison](https://www.cyberciti.biz/tips/finding-bash-perl-python-portably-using-env.html)

#### How to identify the linux distribution been used by your workload
[How to check linux distribution](https://www.tecmint.com/check-linux-os-version/#:~:text=The%20best%20way%20to%20determine,on%20almost%20all%20Linux%20systems.)

#### Types of file permission on linux systems
[Linux file permission](https://www.freecodecamp.org/news/file-permissions-in-linux-chmod-command-explained/)

#### When to use gitpod init/before task
[Gitpod task between init and before](https://www.gitpod.io/docs/configure/workspaces/tasks)

#### How to work with Enivronment Variables
[Link to all environment variables command](https://en.wikipedia.org/wiki/Environment_variable)

List all environment variables with `env` command

To filter a specific env var, use the `env | grep PROJECT_ROOT` command 
To set env var use `export PROJECT_ROOT='/workspace/terraform-beginner-bootcamp-2023'` command
To unset env var `unset PROJECT_ROOT` command
to print env var `echo $PROJECT_ROOT` command

In cases you want to set you env var within your bash script, you can do it this way

```sh
#!/var/bin/env bash
PROJECT_ROOT='workspace/terraform-beginner-bootcamp-2023'
echo $PROJECT_ROOT
```
Scoping env var; env var does not persist in new windows, to fix this you need to set it globally for all future bash terminals. eg `bash_profile`

In gitpod we can persist with this to affect all future bash terminals that will be opened

```
gp env PROJECT_ROOT='workspace/terraform-beginner-bootcamp-2023'

```

Also, one way we could approach this is by using the `'gitpod.yml` file but the catch here is that your yaml file shouldn't contain sensitive information

## AWS CLI Installation
AWS CLI is installed via the bash script with [aws cli linux installation link](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) 

The installation procedure should be similar to this

```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

```
To check whether aws credentials are set correctly, use this command

```sh
aws sts get-caller-identity
```

An output of something similar would be printed in JSON

```
{
    "UserId": "AIDASAMPLEUSERID",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/DevAdmin"
}

```

To set up env vars reference this [aws env var link](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

```
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
export AWS_DEFAULT_REGION=us-west-2

```

## Installing and setting up Terraform

### What terraform is
**Terraform** is an open-source infrastructure as code (IAC) tool that enables the automated provisioning and management of cloud and on-premises infrastructure resources through declarative configuration files.

### Main Terraform commands:
  `terraform init`          Prepare your working directory for other commands
  `terraform validate`      Check whether the configuration is valid
  `terraform plan`          Show changes/changeset required by the current configuration
  `terraform apply`         Create or update infrastructure. 
  `terraform apply --auto-approve` Use this to automate apply to prevent typing yes  
  `terraform destroy`       Destroy previously-created infrastructure

### Accessing Terraform
Terraform utilizes providers and modules in its deployment process. 
**Providers** serve as plugins that connect to various cloud or infrastructure platforms, enabling Terraform to interact with them. eg: [random terraform provier](https://registry.terraform.io/providers/hashicorp/random/latest)
**Modules** are reusable sets of Terraform configurations that simplify the management of infrastructure resources. 
To explore and access providers and modules, visit [terraform](https://registry.terraform.io)

### Terraform lock file
Terraform lock files are used to prevent concurrent modifications to infrastructure configurations. They ensure that only one user or process can make changes to the infrastructure at a time, helping maintain consistency and prevent conflicts when multiple users are working on the same Terraform project simultaneously, **must be always be commited to verion control**. A sample lock file `terraform.lock.hcl`

### Terraform state file
A Terraform state file keeps track of the current status and configuration of infrastructure resources managed by Terraform, ensuring that changes are correctly applied and synchronized with your defined configuration,  **must not be always be commited to verion control**. A sample lock file `terraform.tfstate`

### Terraform backup file
A Terraform backup file, often referred to as a `terraform.tfstate.backup` file, is a copy of the previous state file generated when Terraform applies changes to infrastructure. It serves as a safety net, allowing you to revert to the previous state in case there are issues with the most recent changes made to your infrastructure using Terraform.

=======
### Issues with terraform cloud login and Gitpod workspace
When you run `terraform init` in gitpod to generate a token to connect terraform cloud to your env/gitpod, there are always challenges.

To sort this, you need to manually generate a token in terraform cloud 
NB: The token must be a `user token and` not `organisation token`

After this add an env var for terraform to communicate with AWS, this is done by
going to your terraform cloud > variables > env variables and then set `AWS access key, secret key and then region` NB: AWS is used as an example, if you are using different providers like google then you use that access and secret keys.

```
https://app.terraform.io/app/phosters/settings/authentication-tokens

```
Then create the file manually here:

```sh
touch /home/gitpod/.terraform.d/credentials.tfrc.json
```

```sh
open /home/gitpod/.terraform.d/credentials.tfrc.json
```

Provide the following code (replace your token in the file)

```json
{
  "credentials": {
    "app.terraform.io": {
      "token": "*************replace_token***************"
    }
  }
}



```

## Set up alias for terraform with tf
 First open bash profile and set your alias in the profile, what this does is whenever you are typing terrafrom, you simply type tf.

 To open bash profile ie; where all env vars are saved simply type `open ~/.bash_profile` in your workspace, then set your alias

 ```
 alias tf = "terraform"
 
 ```

 Test it by reloading the bash profile with ` source ~/.bash_profile` and then test it with `tf`

### Automating bash profile with alias tf for terraform
After this, we will should be automated for future so a script needs to be generated to perform this task whenerver we start our env with this

```sh
#!/bin/bash

# Define the alias command
ALIAS_COMMAND='alias tf="terraform"'

# Check if the alias already exists in ~/.bash_profile
if grep -q "$ALIAS_COMMAND" "$HOME/.bash_profile"; then
  echo "Alias 'tf' already exists in ~/.bash_profile."
else
  # Append the alias command to ~/.bash_profile
  echo "$ALIAS_COMMAND" >> "$HOME/.bash_profile"
  echo "Alias 'tf' added to ~/.bash_profile."
  # Load the updated ~/.bash_profile to make the alias available in the current session
  source "$HOME/.bash_profile"
fi

```
Make this file executeable with the `chmod u+x` command and then set it by using   `./bin/set_tf_alias`

To finish up we set this in `gitpod.yml` for both aws and terraform with ``

## AWS CLI and AWS S3 Static Website Deployment

This guide explains how to deploy a static website to Amazon S3 using the AWS Command Line Interface (CLI) and set up a CloudFront distribution to serve the website.

### Prerequisites

Before you begin, make sure you have the following prerequisites:

- An AWS account
- AWS CLI installed and configured with appropriate IAM credentials

### Step 1: Create an S3 Bucket and Set It as a Static Website

1. Create an S3 bucket on the AWS website.
   
2. Set up the bucket as a static website:
   - Navigate to the bucket properties.
   - Choose "Static website hosting."
   - Enter the index and error document names (usually "index.html").
   - Save your configuration.

### Step 2: Install and Start a Web Server

Install the `http-server` globally to serve your static website locally.

```shell
npm install http-server -g
```

Start the web server:
```shell
http-server 
```
This will open your website on a local port for testing.

Step 3: Upload Your Website to S3
Use the AWS CLI to copy your website files to the S3 bucket. Replace *filelocation/name* with the path to your website files and s3://bucket/name with your S3 bucket and object key (e.g., s3://my-bucket/index.html).

```shell
aws s3 cp *filelocation/name* s3://bucket/name
```

Ensure you've created the S3 bucket and turned on static website hosting.

Note: Leave public access private and do not configure a bucket policy. We will use a CDN (CloudFront) to serve the website securely.

Step 4: Create a CloudFront Distribution
Go to the AWS Management Console and create a CloudFront distribution.

### Set up origin access control:

In the CloudFront distribution settings, navigate to "Security" settings.
Choose "Control Settings" (not "Identities").
Choose your S3 bucket as the origin (e.g., my-bucket/index.html).
Create your CloudFront distribution.

Step 5: Describe Your CloudFront Distribution
Provide a descriptive name for your CloudFront distribution to distinguish it from others.

Step 6: Confirm Distribution Status
Check and confirm that the CloudFront distribution status is "Enabled."

Step 7: Obtain CloudFront URL
The CloudFront distribution will provide you with a new URL. Use this URL to access your website securely.

Step 8: Connect CloudFront URL to Your Domain
To associate your CloudFront URL with your domain, create a CNAME record in your domain's DNS settings that points to the CloudFront URL.

Your static website is now deployed and served through CloudFront. one