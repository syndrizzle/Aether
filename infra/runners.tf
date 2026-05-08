module "github_runners" {
  source                       = "cloudandthings/github-runners/aws"
  version                      = "~> 3.9.0"
  name                         = "eks-deploy-runner"
  source_location              = var.github_repo_url
  description                  = "Serverless GitHub Actions Runner for EKS deployments"
  vpc_id                       = module.vpc.vpc_id
  subnet_ids                   = module.vpc.private_subnets
  environment_compute_type     = "BUILD_GENERAL1_SMALL"
  build_timeout                = 10
  privileged_mode              = true
  github_personal_access_token = var.github_pat
}

resource "aws_security_group_rule" "codebuild_to_eks_api" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = module.eks.cluster_security_group_id
  source_security_group_id = module.github_runners.aws_security_group_id
  description              = "Allow GitHub Actions CodeBuild runner to access EKS API"
}
