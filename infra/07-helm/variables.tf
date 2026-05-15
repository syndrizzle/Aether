variable "cluster_name" {
  description = "The name of the EKS cluster for the autoscaler auto-discovery"
  type        = string
}

variable "aws_region" {
  description = "The AWS region where the cluster is deployed"
  type        = string
}

variable "cluster_autoscaler_role_arn" {
  description = "The ARN of the IAM Role for Service Accounts (IRSA) for the autoscaler"
  type        = string
}
