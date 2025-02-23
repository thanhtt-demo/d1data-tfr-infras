terraform {
  source = "tfr:///terraform-aws-modules/security-group/aws//?version=5.1.2"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

dependency "vpc" {
  config_path = "${get_terragrunt_dir()}/../vpc"
  mock_outputs = {
    vpc_id = "vpc-12345678"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

inputs = {
  name = "${include.root.locals.master_prefix}-${include.root.locals.account_vars.locals.account_name}-${include.root.locals.region_vars.locals.aws_region}-${include.root.locals.env_vars.locals.env}-security-group"
  vpc_id = dependency.vpc.outputs.vpc_id
}