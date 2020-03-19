locals {
  name = "${replace(var.common.name, "_", "-")}-${var.parameters.name}-${var.common.environment}"
  create = var.create
}

resource "aws_autoscaling_policy" "autoscaling_policy" {
  name                   = "${local.name}-${var.parameters.acp_name_suffix}"
  scaling_adjustment     = tonumber(var.parameters.acp_scaling_adjustment)
  adjustment_type        = var.parameters.acp_adjustment_type
  cooldown               = tonumber(var.parameters.acp_cooldown)
  autoscaling_group_name = var.autoscaling_group
}

resource "aws_cloudwatch_metric_alarm" "cloudwatch_metric_alarm" {
  alarm_actions             = [aws_autoscaling_policy.autoscaling_policy.arn]
  alarm_description         = var.parameters.cma_description
  alarm_name                = "${local.name}-${var.parameters.cma_name_suffix}"
  comparison_operator       = var.parameters.cma_comparison_operator
  evaluation_periods        = tonumber(var.parameters.cma_evaluation_periods)
  insufficient_data_actions = []
  metric_name               = var.parameters.cma_metric_name
  namespace                 = var.parameters.cma_namespace
  period                    = var.parameters.cma_period
  statistic                 = var.parameters.cma_statistic
  threshold                 = var.parameters.cma_threshold
  dimensions = {
    AutoScalingGroupName = var.autoscaling_group
  }

  tags = {
    Environment = var.common.environment
    Owner       = var.common.owner
    Project     = var.common.project
  }
}
