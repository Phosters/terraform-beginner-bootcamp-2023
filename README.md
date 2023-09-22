# Terraform Beginner Bootcamp 2023

![Terraform Bootcamp](./images/terraform.jpg)
## Semantic Versioning :mage:

This project leverages semantic versioning for its tagging
[semver.org](https://semver.org/)

The general format would be incremented this way **MAJOR.MINOR.PATCH**, eg: `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes

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

Also one way we could approcah this is by using the `'gitpod.yml` file but the catch here is that your yml file shouldnt contain sensitve information