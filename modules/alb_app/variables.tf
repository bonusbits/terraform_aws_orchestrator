# Mapped
variable common {type = map}
variable create {type = bool}
variable parameters {type = map}

# VPC Module Outputs
variable "security_groups" {type = list}
variable "subnet_ids" {type = list}
variable "vpc_id" {type = string}