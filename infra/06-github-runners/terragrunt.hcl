include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../01-vpc"
  mock_outputs = {
    vpc_id          = "vpc-mock123"
    private_subnets = ["subnet-mock1"]
  }
}

dependency "eks" {
  config_path = "../03-eks"
  mock_outputs = {
    cluster_security_group_id = "sg-mock123"
  }
}

inputs = {
  vpc_id                    = dependency.vpc.outputs.vpc_id
  private_subnets           = dependency.vpc.outputs.private_subnets
  cluster_security_group_id = dependency.eks.outputs.cluster_security_group_id
}
