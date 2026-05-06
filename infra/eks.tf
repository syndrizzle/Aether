data "aws_caller_identity" "current" {}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "voting-app-cluster"
  kubernetes_version = "1.33"

  vpc_id                 = module.vpc.vpc_id
  subnet_ids             = module.vpc.private_subnets
  endpoint_public_access = true

  addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent    = true
      before_compute = true
    }
  }

  access_entries = {
    syndrizzle_admin = {
      kubernetes_groups = []
      principal_arn     = data.aws_caller_identity.current.arn

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }
  enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  eks_managed_node_groups = {
    worker_nodes = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.medium"]
    }
  }
}
resource "aws_eks_addon" "cloudwatch_monitoring" {
  cluster_name = module.eks.cluster_name
  addon_name   = "amazon-cloudwatch-observability"
  depends_on   = [module.eks]
}

resource "aws_iam_role_policy_attachment" "eks_cloudwatch_policy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = module.eks.eks_managed_node_groups["worker_nodes"].iam_role_name
}
