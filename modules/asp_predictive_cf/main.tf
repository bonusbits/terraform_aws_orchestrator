provider "aws" {
  profile = var.common.aws_profile
  region = var.common.region
  version = "~> 2.44"
}

locals {
  name = "${replace(var.common.name, "_", "-")}-${var.common.environment}-${element(var.parameters.name, 0)}-asp-predictive"
}

resource "aws_cloudformation_stack" "asp_predictive_cf" {
  name = local.name
  //capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]
  capabilities = ["CAPABILITY_IAM"]
  parameters = {
    // Ownership
    Environment = var.common.environment
    Owner = var.common.owner
    Project = var.common.project

    // Scaling
    AutoScalingGroup = var.autoscaling_group
    ASGMinCapacity = element(var.parameters.min_capacity, 0)
    ASGMaxCapacity = element(var.parameters.max_capacity, 0)
    ASGTargetUtilization = 50.0
    ASGEstimatedInstanceWarmup = 600
  }
  template_body = file("${path.module}/asp_predictive.yml")
}