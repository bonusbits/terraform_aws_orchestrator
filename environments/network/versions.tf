provider "aws" {
  version = "~> 2.51"
}

terraform {
  required_version = "~> 0.12.18"
  backend "s3" {
    encrypt               = true
    bucket                = var.common.tfstate_bucket_name
    key                   = "network.tfstate"
    region                = var.common.tfstate_bucket_region
    workspace_key_prefix  = var.common.tfstate_bucket_key_prefix
  }
}