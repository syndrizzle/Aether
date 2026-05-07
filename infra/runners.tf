module "github_runners" {
  source  = "cloudandthings/github-runners/aws"
  version = "~> 3.0"

  name            = "eks-deploy-runner"
  source_location = var.github_repo_url
  description     = "Serverless GitHub Actions Runner for EKS deployments"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  environment_compute_type = "BUILD_GENERAL1_SMALL"
  build_timeout            = 10

  # Authentication
  github_personal_access_token = var.github_pat
}
