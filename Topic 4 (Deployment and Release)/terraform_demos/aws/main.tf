terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
}

resource "aws_instance" "deleteme" {
  ami           = "ami-04a81a99f5ec58529" # Ubuntu 24.04 LTS (us-east-1)
  instance_type = "t2.micro"

  tags = {
    Name = "deleteme"
  }
}