# Mapped
variable common {type = map}
variable create {type = bool}
variable parameters {type = map}

# VPC Module Outputs
variable "subnet_ids" {type = list}

# SG Module Outputs
variable "security_group_ids" {type = list}

# IAM Module Outputs
variable "iam_instance_profile" {}
