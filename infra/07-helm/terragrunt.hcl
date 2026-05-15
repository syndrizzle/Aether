include "root" {
  path = find_in_parent_folders()
}

dependency "eks" {
  config_path = "../03-eks"
  mock_outputs = {
    cluster_name                       = "mock-cluster"
    cluster_endpoint                   = "https://mock.eks.amazonaws.com"
    cluster_certificate_authority_data = "bW9jaw==" # base64 for "mock"
  }
}

dependency "iam" {
  config_path = "../05-iam-roles"
  mock_outputs = {
    cluster_autoscaler_irsa_role_arn = "arn:aws:iam::123456789012:role/mock-role"
  }
}

generate "helm_provider" {
  path      = "helm_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "helm" {
  kubernetes {
    host                   = "${dependency.eks.outputs.cluster_endpoint}"
    cluster_ca_certificate = base64decode("${dependency.eks.outputs.cluster_certificate_authority_data}")
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", "${dependency.eks.outputs.cluster_name}"]
      command     = "aws"
    }
  }
}
EOF
}

inputs = {
  cluster_name                = dependency.eks.outputs.cluster_name
  cluster_autoscaler_role_arn = dependency.iam.outputs.cluster_autoscaler_irsa_role_arn
}
