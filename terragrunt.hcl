locals {
  project = "kodekloud-labs"
  ami = "ami-0f2a1bb3c242fe285"
  instance_type = "t2.micro"
}

remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "kk-tf-state-12685"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "provider" {
  path = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
  provider "aws" {
      region = "us-east-1"
    }
  EOF
}

generate "provider_version" {
  path = "provider_version_override.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
  terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
      }
    }
  }
EOF
}