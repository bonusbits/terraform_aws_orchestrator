provider "aws" {
  profile = var.common.aws_profile
  region = var.common.region
  version = "~> 2.44"
}

locals {
  name = "${replace(var.common.name, "_", "-")}-${var.parameters.s3_bucket_name_suffix}-${var.common.environment}"
  create = var.create
}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  create_bucket = local.create

  bucket = local.name
  acl    = var.parameters.s3_acl

  # Allow deletion of non-empty bucket
  force_destroy = true

  # TODO: Temp until I grab the policy and feed in as json below
  attach_elb_log_delivery_policy = true

//  attach_policy = true
//  policy = {}

  versioning = {
    enabled = tobool(var.parameters.s3_versioning)
  }

  tags = {
    Environment = var.common.environment
    Owner       = var.common.owner
    Project     = var.common.project
  }
}