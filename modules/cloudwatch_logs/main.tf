provider "aws" {
  profile = var.common.aws_profile
  region = var.common.region
  version = "~> 2.44"
}

locals {
  name = "${replace(var.common.name, "_", "-")}-${var.parameters.name}-${var.common.environment}"
  create = var.create
}

resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name = "${local.name}-${var.parameters.name}"

  tags = {
    Environment = var.common.environment
    Owner       = var.common.owner
    Project     = var.common.project
  }
}