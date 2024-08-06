terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.2.2"
    }
  }
}

provider "github" {
  # Specify a value in terraform.tfvars, *.auto.tfvars, with -var 'foo=bar', or -var-file=filename
  token = var.github_token
  owner = var.github_owner
}

resource "github_repository" "my_repository" {
  name        = "terraform_github_demo"
  description = "This description was created from terraform"
  visibility  = "private"
  template {
    owner                = "christosgalano"
    repository           = "terraform-template-repo"
    include_all_branches = true
  }
}
