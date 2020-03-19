# Mapped
variable common {type = map(string)}
variable create {type = bool}
variable parameters {type = map(string)}

# VPC Module Outputs
variable "subnet_ids" {type = list}
variable "vpc_id" {type = string}

# EC2 Module Outputs
variable "instance_id" {}