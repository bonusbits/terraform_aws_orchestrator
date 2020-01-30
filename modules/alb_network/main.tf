provider "aws" {
  profile = var.common.aws_profile
  region = var.common.region
  version = "~> 2.44"
}

locals {
  name = "${replace(var.common.name, "_", "-")}-${var.parameters.name}-${var.common.environment}"
  create = var.create
}

//module "log_bucket" {
//  source = "terraform-aws-modules/s3-bucket/aws"
//  create_bucket = local.create
//  bucket = "${local.name}-logs"
//  acl    = var.alb.s3_acl
//  force_destroy = true
//  attach_elb_log_delivery_policy = true
//  versioning = {
//    enabled = tobool(var.alb.s3_versioning)
//  }
//  tags = {
//    Environment = var.common.environment
//    Owner       = var.common.owner
//    Project     = var.common.project
//  }
//}

resource "aws_lb" "alb" {
  name               = local.name
  internal           = false
  load_balancer_type = "network"
  subnets            = var.subnet_ids

  enable_deletion_protection = false

//  access_logs {
//    bucket  = module.log_bucket.this_s3_bucket_id
//    prefix  = local.name
//    enabled = true
//  }

  tags = {
    Environment = var.common.environment
    Owner       = var.common.owner
    Project     = var.common.project
  }
}

resource "aws_lb_target_group" "target_group" {
  name     = local.name
  port     = tonumber(var.parameters.backend_port)
  protocol = var.parameters.backend_protocol
  vpc_id   = var.vpc_id

  tags = {
    Environment = var.common.environment
    Owner       = var.common.owner
    Project     = var.common.project
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = tonumber(var.parameters.lb_port)
  protocol          = var.parameters.lb_protocol
  //ssl_policy        = "ELBSecurityPolicy-2016-08"
  //certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_lb_target_group_attachment" "target_group_attachment" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = var.instance_id
  port             = tonumber(var.parameters.backend_port)
}