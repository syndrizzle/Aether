include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "eks" {
  config_path = "../03-eks"
  mock_outputs = {
    cluster_name                       = "mock-cluster"
    cluster_endpoint                   = "https://mock.eks.amazonaws.com"
    # mathematically valid fake cert
    cluster_certificate_authority_data = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNZRENDQWdDQ0FBQ0FBUUF3RFFZSktvWklodmNOQVFFTEJRQXdEekVOTUFzR0ExVUVBd3dFTTJWeWJERW0KTUNRR0NTeHNNQWliM0hFV1BqTXZMRE15T0RNNE56STFORGN5T1RBMk5EWTFPRFl3SHhjTk1qUXdOREV5TVRVegpNRE13V2hjTk1qVXdOREV5TVRVek1ETXdXakFQTVEwd0N3WURWUVFEREFRek1YSXdXVEFUQmdrcWhraUc5dzBCClJRUUJBaUVBOGtsSXRyZTVsLzFSMUV3YWRCWEU2eXV4MzdDTTF4eGszcVVzNllkNWV4MERBUUJnTlZIU01CQWY4RQpCVEFEQVFIL01BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQ2I0aXZvVnp0SThNbkF4TzNDWmlnLzJWa0c4Y1ZHCkdMQUZndW1hQ2ZCNFBCZjdqUGUyWGNYWnB1MjA2aWhmZXZSSTNmbEdQWGZ4ZUN5NElWaGZ4ZzBYZkxJNWxOdmMKMm5xUWVzMWpHVXNDRWVZaU1tNDhTWHg5emZlUmdFdVNDRVpLWG1mRGx4UEF2c1pKTUR1L1lCVDh1Q0hFbm1mWApHb3NPRXZvVG9xOUFaS3BRUE5yUmVxdnRKZnhQZnFTZzBYK3V0V0pmVnR0TG4zVnFWeFk5Rzh1T3FYdytWZXFYClZnL0J1ZzZ5L1B1TGpxaVVnZzM0Vmx3ZWUyS3J5Z1VnQ1YyM2l4a2Z6QWdndVpmQnB6Q3V4Z0M5QWdnQ2FnZ0wKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo="
  }
}

dependency "iam" {
  config_path = "../05-iam"
  mock_outputs = {
    cluster_autoscaler_irsa_role_arn = "arn:aws:iam::123456789012:role/mock-role"
  }
}

generate "helm_provider" {
  path      = "helm_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "helm" {
  kubernetes = {
    host                   = "${dependency.eks.outputs.cluster_endpoint}"
    cluster_ca_certificate = base64decode("${dependency.eks.outputs.cluster_certificate_authority_data}")
    exec = {
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
