terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}

provider "github" {
  # Specify a value in terraform.tfvars, *.auto.tfvars, with -var 'foo=bar', or -var-file=filename
  token              = var.github_token
  owner              = "test-organization7"
  allow_squash_merge = false
  allow_rebase_merge = false
}

resource "github_repository" "my_repository" {
  name        = "test"
  description = "tf-created-description"
  visibility  = "public"
}

resource "github_branch" "my_branch" {
  repository = github_repository.my_repository.name
  branch     = "tf-branch"
}

resource "github_branch_default" "my_branch_default" {
  repository = github_repository.my_repository.name
  branch     = github_branch.my_branch.branch
}

resource "github_branch_protection_v3" "my_branch_protection_v3" {
  repository = github_repository.my_repository.name
  branch = github_branch.my_branch.branch
  restrictions {
    users = ["Mostafaa3"] # yep, that's my fake account
  }
}
