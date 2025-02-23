# terraform {
#   source = "${find_in_parent_folders("modules")}/ec2"
# }
terraform {
  source = "tfr:///terraform-aws-modules/ec2-instance/aws//?version=5.7.1"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

dependency "vpc" {
  config_path = "${get_terragrunt_dir()}/../vpc"
  mock_outputs = {
    public_subnets = ["mock-subnet-id"]
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

dependency "security_group" {
  config_path = "${get_terragrunt_dir()}/../security-group"
  mock_outputs = {
    security_group_id = "mock-sg-id"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

dependency "key_pair" {
  config_path = "${get_terragrunt_dir()}/../key-pair"
  mock_outputs = {
    key_pair_name = "mock-key-pair"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

inputs = {
  name            = "${include.root.locals.master_prefix}-${include.root.locals.account_vars.locals.account_name}-${include.root.locals.region_vars.locals.aws_region}-${include.root.locals.env_vars.locals.env}-instance"
  ami             = "ami-0b03299ddb99998e9"
  key_name        = dependency.key_pair.outputs.key_pair_name
  subnet_id       = dependency.vpc.outputs.public_subnets[0]
  vpc_security_group_ids  = [dependency.security_group.outputs.security_group_id]
  instance_type  = "t2.micro"
}