module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "~> 6.6.0"

  vpc_id             = var.vpc_id
  security_group_ids = [var.node_security_group_id]
}
