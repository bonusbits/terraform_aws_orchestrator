# Mapped
variable common {type = map(string)}
variable create {type = bool}
variable parameters {type = map(string)}

# VPC Module Outputs
variable "subnet_ids" {type = list}

# SG Module Outputs
variable "security_group_ids" {type = list}

# IAM Module Outputs
variable "iam_instance_profile" {}
