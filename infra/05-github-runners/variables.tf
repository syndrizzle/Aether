variable "vpc_id" {
  description = "The ID of the VPC where the CodeBuild runner will be deployed"
  type        = string
}

variable "private_subnets" {
  description = "A list of private subnet IDs for the runner's network interfaces"
  type        = list(string)
}

variable "cluster_security_group_id" {
  description = "The ID of the EKS cluster security group to allow runner access"
  type        = string
}

variable "github_repo_url" {
  description = "The full HTTPS URL of the GitHub repository to bind the runner to"
  type        = string
}

variable "github_pat" {
  description = "A GitHub Personal Access Token with repo scope for runner registration"
  type        = string
  sensitive   = true
}
