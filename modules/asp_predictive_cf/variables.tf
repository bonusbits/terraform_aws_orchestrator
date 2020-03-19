# Mapped
variable common {type = map(string)}
variable create {type = bool}
variable parameters {type = map(string)}

# ASG
variable "autoscaling_group" {type = string}