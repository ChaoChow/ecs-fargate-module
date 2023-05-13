data "template_file" "task_definition_template" {
  template = file("./templates/task_definition.json.tpl")

  vars = {
    app_image      = var.container_definitions.app_image
    app_port       = var.container_definitions.app_port
    aws_region     = var.network.aws_region
    fargate_cpu    = var.container_definitions.fargate_cpu
    fargate_memory = var.container_definitions.fargate_memory
    full_app_name = local.full_app_name
    log_group_name = aws_cloudwatch_log_group.ecs_log_group.name
  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${local.full_app_name}-ecs-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.container_definitions.fargate_cpu
  memory                   = var.container_definitions.fargate_memory
  container_definitions    = data.template_file.task_definition_template.rendered

  runtime_platform {
    operating_system_family = var.container_definitions.os
    cpu_architecture = var.container_definitions.cpu_architecture
  }
}
