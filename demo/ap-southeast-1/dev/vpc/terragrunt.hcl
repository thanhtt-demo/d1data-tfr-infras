terraform {
  source = "tfr:///terraform-aws-modules/vpc/aws//?version=5.8.1"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

inputs = {
  name = "${include.root.locals.master_prefix}-${include.root.locals.account_vars.locals.account_name}-${include.root.locals.region_vars.locals.aws_region}-${include.root.locals.env_vars.locals.env}-vpc"
  cidr = "10.0.0.0/16"
  azs = ["${include.root.locals.region_vars.locals.aws_region}a", "${include.root.locals.region_vars.locals.aws_region}b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
  enable_nat_gateway = false
  create_igw = true
}