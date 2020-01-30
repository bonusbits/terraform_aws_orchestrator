# ALB DNS name
output alb_dns_name {
  value       = aws_lb.alb.dns_name
  //type        = string
}

# ALB ID
output alb_id {
  value       = aws_lb.alb.id
  //type        = string
}

# ALB ARN
output target_group_arn {
  value       = aws_lb_target_group.target_group.arn
  //type        = string
}