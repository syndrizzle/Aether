data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_prefix_list" "s3" {
  name = "com.amazonaws.${data.aws_region.current.region}.s3"
}

module "eks" {
  source                       = "terraform-aws-modules/eks/aws"
  version                      = "~> 21.0"
  name                         = "voting-app-cluster"
  kubernetes_version           = "1.34"
  vpc_id                       = module.vpc.vpc_id
  subnet_ids                   = module.vpc.private_subnets
  endpoint_public_access       = true
  endpoint_private_access      = true
  endpoint_public_access_cidrs = [var.local_workstation_cidr]
  addons = {
    coredns = {
      most_recent                 = true
      resolve_conflicts_on_update = "OVERWRITE"
    }
    kube-proxy = {
      most_recent                 = true
      resolve_conflicts_on_update = "OVERWRITE"
    }
    vpc-cni = {
      most_recent                 = true
      before_compute              = true
      resolve_conflicts_on_update = "OVERWRITE"
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
      min_size       = 1
      max_size       = 3
      desired_size   = 2
      instance_types = ["t3.medium"]
    }
  }
  node_security_group_additional_rules = {
    egress_all_vpc = {
      description = "Node all egress to VPC only"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "egress"
      cidr_blocks = ["10.0.0.0/16"]
    }
    egress_s3 = {
      description     = "Node egress to S3 Prefix List (required for ECR image layers)"
      protocol        = "tcp"
      from_port       = 443
      to_port         = 443
      type            = "egress"
      prefix_list_ids = [data.aws_prefix_list.s3.id]
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
