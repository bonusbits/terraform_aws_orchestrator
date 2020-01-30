# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
  //type        = string
}

# CIDR blocks
output vpc_cidr_block {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
  //type        = string
}

//output "vpc_ipv6_cidr_block" {
//  description = "The IPv6 CIDR block"
//  value       = ["${module.vpc.vpc_ipv6_cidr_block}"]
//}

# Security Groups
output security_group_default {
  description = "Default Security Group Object"
  value       = data.aws_security_group.default
  //type        = object
}

output security_group_endpoints_id {
  description = "Default Security Group Object"
  value       = module.sg_endpoints.security_group_id
  //type = string
}

output security_group_endpoints_name {
  description = "Default Security Group Object"
  value       = module.sg_endpoints.security_group_name
  //type = string
}

# Subnets
output private_subnet_ids {
  description = "List of IDs of private subnets"
  value       = tolist(module.vpc.private_subnets)
  //type        = list (tuple to list)
}

output public_subnet_ids {
  description = "List of IDs of public subnets"
  value       = tolist(module.vpc.public_subnets)
  //type        = list
}

# NAT gateways
output nat_public_ips {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = tolist(module.vpc.nat_public_ips)
  //type        = list
}

# AZs
output azs {
  description = "A list of availability zones spefified as argument to this module"
  value       = module.vpc.azs
  //type        = list
}