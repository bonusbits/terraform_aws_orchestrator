# Mapped
variable common {type = map}
variable create {type = bool}
variable parameters {type = map}

# VPC Module Outputs
variable "vpc_id" {}
variable "security_group" {}
variable "subnet_ids" {type = list}

# ALB Module Outputs
variable "target_group_arn" {}

# SNS Module Outputs
variable "sns_topic_arn" {}

# IAM Instance Profile Module Outputs
variable "iam_instance_profile" {}