include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "vpc" {
  config_path = "../01-vpc"
  mock_outputs = {
    vpc_id          = "vpc-mock123"
    private_subnets = ["subnet-mock1"]
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "eks" {
  config_path = "../03-eks"
  mock_outputs = {
    cluster_security_group_id = "sg-mock123"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = {
  vpc_id                    = dependency.vpc.outputs.vpc_id
  private_subnets           = dependency.vpc.outputs.private_subnets
  cluster_security_group_id = dependency.eks.outputs.cluster_security_group_id
}
