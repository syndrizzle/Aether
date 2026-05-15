module "cluster_autoscaler_irsa_role" {
  source                           = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version                          = "~> 6.6.0"
  name                             = "cluster-autoscaler"
  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_names = [var.cluster_name]
  oidc_providers = {
    main = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["kube-system:cluster-autoscaler"]
    }
  }
}

resource "aws_iam_policy" "cluster_autoscaler" {
  name        = "eks-cluster-autoscaler"
  description = "Permissions for Cluster Autoscaler to modify ASGs"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeScalingActivities",
          "autoscaling:DescribeTags",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeLaunchTemplateVersions"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "autoscaling:UpdateAutoScalingGroup"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cloudwatch_policy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = var.worker_iam_role_name
}

resource "aws_iam_role_policy_attachment" "eks_autoscaler_policy" {
  policy_arn = aws_iam_policy.cluster_autoscaler.arn
  role       = var.worker_iam_role_name
}
