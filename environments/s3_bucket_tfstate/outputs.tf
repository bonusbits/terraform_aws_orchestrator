# Bastion
output "eip_public_ip_bastion" {
  value       = module.bastion.eip_public_ips.*
  // string
}
output "key_pair_name_bastion" {
  value       = module.bastion.key_pair.key_name
  // object
}
output "instances" {
  value       = module.bastion.instances.*
  // object
}
output "security_group" {
  value       = module.bastion.security_group
  // object
}

