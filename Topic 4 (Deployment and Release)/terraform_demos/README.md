# terraform_demos

[TOC]

## Prerequisites

Download and install [Terraform CLI](https://www.terraform.io/downloads).

> SysAdmins love to do that kind of `sh`.

```bash
cd /tmp
export RELEASE=$(curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | jq -r '.tag_name')
RELEASE="${RELEASE:1}" # Remove the 'v'
wget "https://releases.hashicorp.com/terraform/${RELEASE}/terraform_${RELEASE}_linux_amd64.zip"
unzip terraform_${RELEASE}_linux_amd64.zip
sudo mv terraform /usr/local/bin
```

Download, install, and configure AWS CLI

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws configure
```

## Docker Provider

> Docs: <https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs>
>
> Tutorial: <https://learn.hashicorp.com/collections/terraform/docker-get-started>

- Write main.tf that uses docker provider [kreuzwerker/docker](https://github.com/kreuzwerker/terraform-provider-docker) to create resources of types `docker_image` and a `docker_container`.

- Parametrize `container_name` in variables.tf and define outputs in `outputs.tf`

- Use terraform to run your container.

  ```bash
  terraform init       # Prepare workspace and download providers
  terraform validate   # Check configuration for validity
  terraform fmt        # Format source file
  terraform plan       # Show execution plan
  ```

- Apply plan with the custom value: `terraform apply -var 'container_name=app_python'`

## GitHub Provider

> Docs: <https://registry.terraform.io/providers/integrations/github/latest/docs>

- Write main.tf that uses `integrations/github` provider.

- Configure `github` provider with `token` declared in variables.tf and assign the value from command line or `.tfvars` file.

- Declare a resource of type `github_repository` with the desired configurations.

- You can also import an existing remote repo to manage from terraform.

  ```bash
  terraform import github_repository.<resource_name> <repo_name>
  ```

- Use the same terraform commands as above to manage the repository configuration.

## AWS Provider

> Docs: <https://registry.terraform.io/providers/hashicorp/aws/latest/docs>

- Write [main.tf](https://github.com/Sh3b0/DevOps/blob/main/terraform/aws/main.tf) that uses `hashicorp/aws` provider to provision an EC2 instance by creating an `aws_instance` resource.

- Specify the OS to run using its corresponding AMI ([Ubuntu](https://cloud-images.ubuntu.com/locator/ec2/) examples).

- Set AWS secrets in environment variables, or have `aws` CLI present and configured.

  ```bash
  export AWS_ACCESS_KEY_ID=<iam_access_key>
  export AWS_SECRET_ACCESS_KEY=<iam_secret_key>
  ```
  
- Run

  ```bash
  terraform init
  terraform validate
  terraform fmt
  terraform plan
  terraform apply
  ```
