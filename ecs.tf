resource "aws_ecs_service" "main" {
  name            = "${local.full_app_name}-ecs-service"
  cluster         = var.ecs_cluster.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.container_definitions.desired_starting_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = [for subnet in var.network.private_subnet_ids : subnet]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.app.id
    container_name   = local.full_app_name
    container_port   = var.container_definitions.app_port
  }

  depends_on = [aws_alb_listener.front_end, aws_iam_role_policy_attachment.ecs_task_execution_role]
}
