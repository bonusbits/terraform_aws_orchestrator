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
  # Module Use Conditionals (Count) TODO: WIP
  create_vpc            = var.common.create_vpc
}

# VPC
module "vpc" {
  source                = "../../modules/vpc"
  create                = local.create_vpc
  // Module Outputs
  common                = var.common
  parameters            = var.vpc
  sg_endpoints          = var.sg_endpoints
}
