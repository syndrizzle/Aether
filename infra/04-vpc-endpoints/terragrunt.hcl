include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "vpc" {
  config_path = "../01-vpc"
  mock_outputs = {
    vpc_id = "vpc-mock123"
  }
}

dependency "eks" {
  config_path = "../03-eks"
  mock_outputs = {
    node_security_group_id = "sg-mock123"
  }
}

inputs = {
  vpc_id                 = dependency.vpc.outputs.vpc_id
  node_security_group_id = dependency.eks.outputs.node_security_group_id
}
