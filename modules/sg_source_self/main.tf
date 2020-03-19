locals {
  name = "${replace(var.common.name, "_", "-")}-${var.parameters.name}-${var.common.environment}"
  create = var.create
}

module "sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.4"

  name        = local.name
  description = var.parameters.description
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = [var.parameters.ingress_cidr_blocks]

  ingress_with_source_security_group_id = [
    {
      rule                     = var.parameters.ingress_rule
      source_security_group_id = module.sg.this_security_group_id
    },
  ]

  egress_rules        = [var.parameters.egress_rules]

  tags = {
    Environment = var.common.environment
    Owner       = var.common.owner
    Project     = var.common.project
  }
}