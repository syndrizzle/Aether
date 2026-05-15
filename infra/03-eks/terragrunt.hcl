include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "vpc" {
  config_path = "../01-vpc"

  mock_outputs = {
    vpc_id          = "vpc-mock123"
    private_subnets = ["subnet-mock1", "subnet-mock2"]
  }
}

inputs = {
  vpc_id          = dependency.vpc.outputs.vpc_id
  private_subnets = dependency.vpc.outputs.private_subnets
}
