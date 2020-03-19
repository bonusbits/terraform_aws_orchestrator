# Mapped
variable common {type = map(string)}
variable parameters {type = map(string)}

variable "az_count" {
  type = map(number)
  # Availability Zones Count Per Region
  default = {
    us-east-1      = 3
    us-east-2      = 3
    us-west-1      = 2
    us-west-2      = 3
    ap-south-1     = 3
    ap-northeast-2 = 3
    ap-southeast-1 = 3
    ap-southeast-2 = 3
    ap-northeast-1 = 3
    ca-central-1   = 2
    eu-central-1   = 3
    eu-west-1      = 3
    eu-west-2      = 3
    eu-west-3      = 3
    eu-north-1     = 3
    sa-east-1      = 3
  }
}

variable "region_shortname" {
  type = map(string)
  default = {
    us-east-1      = "use1"
    us-east-2      = "use2"
    us-west-1      = "usw1"
    us-west-2      = "usw2"
    ap-south-1     = "aps1"
    ap-northeast-2 = "apne2"
    ap-southeast-1 = "apse1"
    ap-southeast-2 = "apse2"
    ap-northeast-1 = "apne1"
    ca-central-1   = "cac1"
    eu-central-1   = "euc1"
    eu-west-1      = "euw1"
    eu-west-2      = "euw2"
    eu-west-3      = "euw3"
    eu-north-1     = "eun1"
    sa-east-1      = "sae1"
  }
}
