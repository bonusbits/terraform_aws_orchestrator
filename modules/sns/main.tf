provider "aws" {
  profile = var.common.aws_profile
  region = var.common.region
  version = "~> 2.44"
}

locals {
  name = "${replace(var.common.name, "_", "-")}-${var.parameters.topic_name_postfix}-${var.common.environment}"
}

module "sns_topic" {
  source  = "terraform-aws-modules/sns/aws"
  version = "~> 2.0"
  name  = local.name
}
