variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "oidc_provider_arn" {
  description = "OIDC Provider ARN from EKS"
  type        = string
}

variable "worker_iam_role_name" {
  description = "IAM Role Name for EKS worker nodes"
  type        = string
}
