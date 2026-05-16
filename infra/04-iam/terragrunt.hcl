include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "eks" {
  config_path = "../03-eks"
  mock_outputs = {
    cluster_name         = "mock-cluster"
    oidc_provider_arn    = "arn:aws:iam::123456789012:oidc-provider/mock"
    worker_iam_role_name = "mock-role-name"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = {
  cluster_name         = dependency.eks.outputs.cluster_name
  oidc_provider_arn    = dependency.eks.outputs.oidc_provider_arn
  worker_iam_role_name = dependency.eks.outputs.worker_iam_role_name
}
