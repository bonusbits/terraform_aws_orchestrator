# Policy
output "id" {
  description = "IAM Policy ID"
  value       = aws_iam_policy.iam_policy.id
}
output "arn" {
  description = "IAM Policy ARN"
  value       = aws_iam_policy.iam_policy.arn
}
output "name" {
  description = "IAM Policy Name"
  value       = aws_iam_policy.iam_policy.name
}

# Instance Profile
output "iam_instance_profile_id" {
  description = "IAM Instance Profile ID"
  value       = aws_iam_instance_profile.iam_instance_profile.id
}
output "iam_instance_profile_arn" {
  description = "IAM Instance Profile ARN"
  value       = aws_iam_instance_profile.iam_instance_profile.arn
}
output "iam_instance_profile_name" {
  description = "IAM Instance Profile Name"
  value       = aws_iam_instance_profile.iam_instance_profile.name
}

# Role
output "iam_role_id" {
  description = "IAM Role ID"
  value       = aws_iam_role.iam_role.id
}
output "iam_role_arn" {
  description = "Iam Role ARN"
  value       = aws_iam_role.iam_role.arn
}
output "iam_role_name" {
  description = "Iam Role Name"
  value       = aws_iam_role.iam_role.name
}