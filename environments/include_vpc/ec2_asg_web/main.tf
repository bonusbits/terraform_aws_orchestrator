terraform {
  required_version = "~> 0.12.18"
  required_providers {
    aws                 = "~> 2.44.0"
    null                = "~> 2.1.2"
    random              = "~> 2.2.1"
  }
//  backend "s3" {
//    encrypt = true
//    bucket = "terraform-remote-state-storage-s3"
//    region = var.common.region
//    key = path/to/state/file
//  }
}

locals {
  # enabled = var.common == "prd" ? true : false
  # Module Use Conditionals (Count) TODO: WIP
  create_vpc            = var.common.create_vpc
  create_bastion        = var.common.create_bastion
  create_asg_web        = var.common.create_asg_web
}

# VPC
module "vpc" {
  source                = "../../../modules/vpc"
  create                = local.create_vpc
  // Module Outputs
  common                = var.common
  parameters            = var.vpc
  sg_endpoints          = var.sg_endpoints
}

# Bastion
module "alb_bastion" {
  source                = "../../../modules/alb_network"
  create                = local.create_bastion
  // Mapped Vars
  common                = var.common
  parameters            = var.alb_bastion
  // Module Outputs
  subnet_ids            = module.vpc.public_subnet_ids
  vpc_id                = module.vpc.vpc_id
  instance_id           = module.ec2_bastion.instance_id
}
module "sg_bastion" {
    source              = "../../../modules/sg"
    create              = local.create_bastion
    // Mapped Vars
    common              = var.common
    parameters          = var.sg_bastion
    // Module Outputs
    vpc_id              = module.vpc.vpc_id
}
module "iam_bastion" {
  source                = "../../../modules/iam_instance_profile"
  create                = local.create_bastion
  // Mapped Vars
  common                = var.common
  parameters            = var.iam_bastion
}
module "ec2_bastion" {
  source                = "../../../modules/ec2"
  create                = local.create_bastion
  // Mapped Vars
  common                = var.common
  parameters            = var.ec2_bastion
  // Module Outputs
  subnet_ids            = module.vpc.private_subnet_ids
  security_group_ids    = [module.sg_bastion.security_group_id]
  iam_instance_profile  = module.iam_bastion.iam_instance_profile_name
}

# Autoscaling Web Frontend
module "sns_topic_web" {
  source                = "../../../modules/sns"
  create                = local.create_asg_web
  // Mapped Vars
  common                = var.common
  parameters            = var.sns_web
}
module "iam_web" {
  source                = "../../../modules/iam_instance_profile"
  create                = local.create_asg_web
  // Mapped Vars
  common                = var.common
  parameters            = var.iam_web
}
module "sg_web" {
  source              = "../../../modules/sg"
  create              = local.create_asg_web
  // Mapped Vars
  common              = var.common
  parameters          = var.sg_web
  // Module Outputs
  vpc_id              = module.vpc.vpc_id
}
module "alb_web" {
  source                = "../../../modules/alb_app"
  create                = local.create_asg_web
  // Mapped Vars
  common                = var.common
  parameters            = var.alb_web
  // Module Outputs
  subnet_ids            = module.vpc.public_subnet_ids
  vpc_id                = module.vpc.vpc_id
  security_groups       = [module.sg_web.security_group_id]
}
module "asg_web" {
  source                = "../../../modules/asg_cf"
  create                = local.create_asg_web
  // Mapped Vars
  common                = var.common
  parameters            = var.asg_web
  // Module Outputs
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = module.vpc.private_subnet_ids
  target_group_arn      = module.alb_web.target_group_arn
  sns_topic_arn         = module.sns_topic_web.sns_topic_arn
  security_group        = module.sg_web.security_group_id
  iam_instance_profile  = module.iam_web.iam_instance_profile_name
}
module "asg_alarm_up_web" {
  source                = "../../../modules/asg_alarm"
  create                = local.create_asg_web
  common                = var.common
  parameters            = var.asg_alarm_up_web
  autoscaling_group     = module.asg_web.autoscaling_group
}
module "asg_alarm_down_web" {
  source                = "../../../modules/asg_alarm"
  create                = local.create_asg_web
  common                = var.common
  parameters            = var.asg_alarm_down_web
  autoscaling_group     = module.asg_web.autoscaling_group
}
//module "asp_predictive_web" {
//  source                = "./modules/asp_predictive_cf"
//  create                = local.create_asg_web
//  common                = var.common
//  parameters            = var.asg_web
//  autoscaling_group     = module.asg_web.autoscaling_group
//}