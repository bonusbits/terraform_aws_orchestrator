# Common
variable common {type = map}

# Bastion
variable ec2_bastion {type = map}
variable alb_bastion {type = map}
variable sg_bastion {type = map}
variable iam_bastion {type = map}

# VPC
variable sg_endpoints {type = map}
variable vpc {type = map}

# Web
variable asg_web {type = map}
variable alb_web {type = map}
variable iam_web {type = map}
variable sns_web {type = map}
variable sg_web {type = map}
variable asg_alarm_up_web {type = map}
variable asg_alarm_down_web {type = map}
