# Variables grouped by order of operation and alphabetically

# Common
common = {
  aws_profile         = "env1"
  create_vpc          = true
  environment         = "dev"
  name                = "env1"
  owner               = "first.last@domain.com"
  project             = "vpc-dev"
  region              = "us-west-2"
}

# VPC
sg_endpoints = {
  description         = "Endpoint Access for Instances"
  egress_rules        = "all-all"
  ingress_cidr_blocks = "0.0.0.0/0"
  ingress_rule        = "all-all"
  name                = "endpoints"
}
vpc = {
  az                  = ["us-west-2a", "us-west-2b", "us-west-2c"]
  cidr                = ["10.0.0.0/16"]
  enable_ipv6         = ["false"]
  private_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets      = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}
