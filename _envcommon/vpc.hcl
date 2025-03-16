# ---------------------------------------------------------------------------------------------------------------------
# COMMON TERRAGRUNT CONFIGURATION
# This is the common component configuration for mysql. The common variables for each environment to
# deploy mysql are defined here. This configuration will be merged into the environment configuration
# via an include block.
# ---------------------------------------------------------------------------------------------------------------------


locals {
  # Automatically load common-level variables
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))

  # Automatically load environment-level variables
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Extract out common variables for reuse
  env = local.env_vars.locals.env
  master_prefix = local.common_vars.locals.master_prefix
  aws_region = local.region_vars.locals.aws_region

  account_name = local.account_vars.locals.account_name

  prefix = "${local.master_prefix}-${local.account_name}-${local.env}"
  # Expose the base source URL so different versions of the module can be deployed in different environments. This will
  # be used to construct the source URL in the child terragrunt configurations.
  base_source_url = "tfr:///terraform-aws-modules/vpc/aws//"
}


inputs = {
  name = "${local.prefix}-vpc"
  cidr = "10.0.0.0/16"
  azs = ["${local.aws_region}a", "${local.aws_region}b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
  enable_nat_gateway = false
  create_igw = true
}