output "security_group_id" {
  description = "The ID of the security group"
  value       = module.sg.this_security_group_id
}

output "security_group_name" {
  description = "The name of the security group"
  value       = module.sg.this_security_group_name
}