variable "vpc_id" {
  description = "VPC ID injected from the VPC module"
  type        = string
}

variable "private_subnets" {
  description = "Private subnets injected from the VPC module"
  type        = list(string)
}

variable "local_workstation_cidr" {
  description = "The CIDR block of your local machine to allow access to the EKS public API"
  type        = string
}
