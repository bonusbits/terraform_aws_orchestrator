provider "aws" {
  profile = var.common.aws_profile
  region = var.common.region
  version = "~> 2.44"
}

locals {
  name = "${replace(var.common.name, "_", "-")}-${var.common.environment}-${element(var.parameters.name, 0)}"
}

resource "aws_iam_role" "iam_role" {
  name = local.name
  assume_role_policy = element(var.parameters.role_policy, 0)
  tags = {
    Environment = var.common.environment
    Owner       = var.common.owner
    Project     = var.common.project
  }
}

resource "aws_iam_policy" "iam_policy" {
  name        = local.name
  path        = "/"
  description = element(var.parameters.description, 0)
  policy = element(var.parameters.policy, 0)
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment" {
  role       = aws_iam_role.iam_role.name
  policy_arn = aws_iam_policy.iam_policy.arn
}

resource "aws_iam_instance_profile" "iam_instance_profile" {
  name = local.name
  role = aws_iam_role.iam_role.name
}
