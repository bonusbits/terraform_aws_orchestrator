provider "aws" {
  profile = var.common.aws_profile
  region = var.common.region
  version = "~> 2.44"
}

locals {
  name = "${replace(var.common.name, "_", "-")}-${var.common.environment}"
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc.vpc_id
}

# TODO: Not sure this is really needed or right... but know don't want to use default SG that is all:all for endpoints other than S3
module "sg_endpoints" {
  source         = "../sg_source_self"
  // Mapped Vars
  parameters     = var.sg_endpoints
  common         = var.common
  create         = var.create
  // Module Outputs
  vpc_id         = module.vpc.vpc_id
}

module "vpc" {
  # https://github.com/terraform-aws-modules/terraform-aws-vpc
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.21.0"

  create_vpc = var.create
  name = local.name

  cidr = element(var.parameters.cidr, 0)

  azs             = var.parameters.az
  private_subnets = var.parameters.private_subnets
  public_subnets  = var.parameters.public_subnets
  enable_ipv6     = element(var.parameters.enable_ipv6, 0)

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  # VPC endpoint for S3
  enable_s3_endpoint = true

  # VPC endpoint for SNS
  enable_sns_endpoint = true
  sns_endpoint_private_dns_enabled = true
  sns_endpoint_security_group_ids  = [module.sg_endpoints.security_group_id]

  # VPC endpoint for DynamoDB
//  enable_dynamodb_endpoint = true

  # VPC Endpoint for EC2
//  enable_ec2_endpoint              = true
//  ec2_endpoint_private_dns_enabled = true
//  ec2_endpoint_security_group_ids  = [module.sg_endpoints.security_group_id]

  # VPC Endpoint for EC2MESSAGES
//  enable_ec2messages_endpoint              = true
//  ec2messages_endpoint_private_dns_enabled = true
//  ec2messages_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC Endpoint for ECR API
//  enable_ecr_api_endpoint              = true
//  ecr_api_endpoint_private_dns_enabled = true
//  ecr_api_endpoint_security_group_ids  = [module.sg_endpoints.security_group_id]

  # VPC Endpoint for ECR DKR
//  enable_ecr_dkr_endpoint              = true
//  ecr_dkr_endpoint_private_dns_enabled = true
//  ecr_dkr_endpoint_security_group_ids  = [module.sg_endpoints.security_group_id]

  # VPC endpoint for KMS
//  enable_kms_endpoint              = true
//  kms_endpoint_private_dns_enabled = true
//  kms_endpoint_security_group_ids  = [module.sg_endpoints.security_group_id]

  # VPC endpoint for ECS
//  enable_ecs_endpoint              = true
//  ecs_endpoint_private_dns_enabled = true
//  ecs_endpoint_security_group_ids  = [module.sg_endpoints.security_group_id]

  # VPC endpoint for ECS telemetry
//  enable_ecs_telemetry_endpoint              = true
//  ecs_telemetry_endpoint_private_dns_enabled = true
//  ecs_telemetry_endpoint_security_group_ids  = [module.sg_endpoints.security_group_id]

  # VPC endpoint for SQS
//  enable_sqs_endpoint              = true
//  sqs_endpoint_private_dns_enabled = true
//  sqs_endpoint_security_group_ids  = [module.sg_endpoints.security_group_id]

  # Tags
  public_subnet_tags = {
    Name = "${var.common.name}-public"
  }

  private_subnet_tags = {
    Name = "${var.common.name}-private"
  }

  tags = {
    Environment = var.common.environment
    Owner       = var.common.owner
    Project     = var.common.project
  }

  vpc_tags = {
    Name = local.name
  }

  vpc_endpoint_tags = {
    Endpoint = "true"
    # autoscaling-poc-s3-endpoint-dev
    Name = "${replace(var.common.name, "_", "-")}-endpoint-${var.common.environment}"
  }
}