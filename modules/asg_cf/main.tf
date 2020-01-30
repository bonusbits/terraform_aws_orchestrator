provider "aws" {
  profile = var.common.aws_profile
  region = var.common.region
  version = "~> 2.44"
}

locals {
  name = "${replace(var.common.name, "_", "-")}-${var.parameters.name}-asg-${var.common.environment}"
  create = var.create
}

resource "aws_cloudformation_stack" "asg_cf" {
  name = local.name
  //capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]
  capabilities = ["CAPABILITY_IAM"]
  parameters = {
    // ALB
    TargetGroupARNs = var.target_group_arn

    // Ownership
    Environment = var.common.environment
    Owner = var.common.owner
    Project = var.common.project

    // IAM Roles
    // IamInstanceProfile = var.iam_instance_profile

    // Instance
    AMI = var.parameters.ami
    KeyPairName = var.parameters.key_name
    InstanceType = var.parameters.instance_type

    // Network
    VPC = var.vpc_id
    Subnet1 = element(var.subnet_ids, 0)
    Subnet2 = element(var.subnet_ids, 1)
    Subnet3 = element(var.subnet_ids, 2)
    SecurityGroup = var.security_group
    IamInstanceProfile = var.iam_instance_profile

    // Scaling
    MinAutoScaleCount = tonumber(var.parameters.min_capacity)
    MaxAutoScaleCount = tonumber(var.parameters.max_capacity)
    DesiredCapacityCount = tonumber(var.parameters.desired_capacity)
    AsgSnsTopicArn = var.sns_topic_arn
  }
  template_body = file("${path.module}/asg_${(var.parameters.os_type)}.yml")
}