variable "vpc_id" {
  description = "VPC ID injected from the VPC module"
  type        = string
}

variable "node_security_group_id" {
  description = "EKS Node Security Group injected from the EKS module"
  type        = string
}
