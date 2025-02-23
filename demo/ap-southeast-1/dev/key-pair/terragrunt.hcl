terraform {
  source = "tfr:///terraform-aws-modules/key-pair/aws//?version=2.0.3"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

inputs = {
  key_name = "${include.root.locals.master_prefix}-${include.root.locals.account_vars.locals.account_name}-${include.root.locals.region_vars.locals.aws_region}-${include.root.locals.env_vars.locals.env}-key-pair"
  create_private_key = true
}
