output "alb_arn" {
  value = aws_alb.main.arn
}

output "alb_target_group_arn" {
  value = aws_alb_target_group.app.arn
}

output "alb_listener_arn" {
  value = aws_alb_listener.front_end.arn
}

output "auto_scaling_target_id" {
  value = aws_appautoscaling_target.target.id
}

output "auto_scaling_policy_up_arn" {
  value = aws_appautoscaling_policy.up.arn
}

output "auto_scaling_policy_down_arn" {
  value = aws_appautoscaling_policy.down.arn
}

output "ecs_cpu_high_cloudwatch_metric_alarm_arn" {
  value = aws_cloudwatch_metric_alarm.service_cpu_high.arn
}

output "ecs_cpu_low_cloudwatch_metric_alarm_arn" {
  value = aws_cloudwatch_metric_alarm.service_cpu_low.arn
}

output "ecs_service_id" {
  value = aws_ecs_service.main.id
}

output "cloudwatch_log_arn" {
  value = aws_cloudwatch_log_group.ecs_log_group.arn
}


