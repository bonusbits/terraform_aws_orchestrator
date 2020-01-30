//# Launch configuration
//output launch_configuration {
//  description = "The ID of the launch configuration"
//  value       = aws_cloudformation_stack.asg_cf.outputs["LaunchConfiguration"]
//}

# Autoscaling Group Name
output autoscaling_group {
  description = "The autoscaling group name"
  value       = aws_cloudformation_stack.asg_cf.outputs["AutoScalingGroup"]
}