locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  env_vars     = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  master_prefix = "d1data"
}

remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "${local.master_prefix}-remote-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "${local.region_vars.locals.aws_region}"
    dynamodb_table = "${local.master_prefix}-terraform-locks"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

terraform_version_constraint = ">= 1.10.5"
terragrunt_version_constraint = ">= 0.70.2"

generate "provider" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    provider "aws" {
      region  = "${local.region_vars.locals.aws_region}"
    }
EOF
}
