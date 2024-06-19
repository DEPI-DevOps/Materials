terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "eu-central-1"
}

resource "aws_instance" "deleteme" {
  ami           = "ami-06a908e4019cb5e7d"
  instance_type = "t2.micro"

  tags = {
    Name = "deleteme"
  }
}