include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/ec2-instance.hcl"
  # We want to reference the variables from the included config in this configuration, so we expose it.
  expose = true
}

locals {
  enabled = true
}

skip = !local.enabled

# Configure the version of the module to use in this environment. This allows you to promote new versions one
# environment at a time (e.g., qa -> stage -> prod).
terraform {
  source = "${include.envcommon.locals.base_source_url}?version=5.7.1"
}

dependency "vpc" {
  config_path = "${get_terragrunt_dir()}/../../vpc"
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
  ami             = "ami-0b03299ddb99998e9"
  key_name        = dependency.key_pair.outputs.key_pair_name
  subnet_id       = dependency.vpc.outputs.public_subnets[0]
  vpc_security_group_ids  = [dependency.security_group.outputs.security_group_id]
  instance_type  = "t2.micro"
}