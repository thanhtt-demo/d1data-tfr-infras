terraform {
  source = "tfr:///terraform-aws-modules/ec2-instance/aws//?version=5.6.1"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

dependency "vpc" {
  # Path to the vpc module
  config_path = "../../vpc"
}

dependencies {
  # Path to the vpc module
  paths = [
    "../database"
    ]
}

# Create inputs block
inputs = {
  name          = include.root.locals.project
  ami           = include.root.locals.ami
  instance_type = include.root.locals.instance_type

  # First public subnet of vpc module (on index 0)
  subnet_id = dependency.vpc.outputs.public_subnets[0]
}