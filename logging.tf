resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${local.full_app_name}"
  retention_in_days = 30

  tags = {
    Name = "${var.name}-log-group"
  }
}
