data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  required_az_count = 2
  available_azs     = data.aws_availability_zones.available.names
}

resource "terraform_data" "az_validation" {
  lifecycle {
    precondition {
      condition     = length(local.available_azs) >= local.required_az_count
      error_message = "Region must have at least ${local.required_az_count} availability zones. Found ${length(local.available_azs)} AZs: ${join(", ", local.available_azs)}. This configuration requires ${local.required_az_count} AZs to match the ${local.required_az_count} private and ${local.required_az_count} public subnet entries."
    }
  }
}

module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "~> 6.6.0"
  name                 = "voting-app-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = slice(local.available_azs, 0, local.required_az_count)
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets       = ["10.0.101.0/24", "10.0.102.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}
