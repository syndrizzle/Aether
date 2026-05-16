include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "eks" {
  config_path = "../03-eks"
  mock_outputs = {
    cluster_name = "mock-cluster"
  }
}

inputs = {
  cluster_name = dependency.eks.outputs.cluster_name
}
