# Mapped
variable common {type = map}
variable create {type = bool}
variable parameters {type = map}

# VPC Module Outputs
variable "subnet_ids" {type = list}
variable "vpc_id" {type = string}

# EC2 Module Outputs
variable "instance_id" {}