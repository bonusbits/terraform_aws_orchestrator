locals {
  name = "${replace(var.common.name, "_", "-")}-${element(var.parameters.name, 0)}-${var.common.environment}"
  create = var.create
}

module "sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.4"

  name        = local.name
  description = element(var.parameters.description, 0)
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = var.parameters.ingress_cidr_blocks
  ingress_rules       = var.parameters.ingress_rules
  egress_rules        = var.parameters.egress_rules

  tags = {
    Environment = var.common.environment
    Owner       = var.common.owner
    Project     = var.common.project
  }
}