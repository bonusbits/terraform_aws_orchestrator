provider "aws" {
  version = "~> 2.52"
}

terraform {
  required_version = "~> 0.12.23"
  backend "s3" {
    bucket                = "alma-tfstate"
    key                   = "bastion.tfstate"
    region                = "us-west-2"
    workspace_key_prefix  = "workspaces"
  }
}

