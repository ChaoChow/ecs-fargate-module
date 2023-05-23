resource "aws_ecs_task_definition" "app" {
  family                   = "${local.full_app_name}-ecs-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.container_definitions.fargate_cpu
  memory                   = var.container_definitions.fargate_memory
  container_definitions    = jsonencode(
    [
      {
        name: local.full_app_name,
        image: var.container_definitions.app_image,
        cpu: var.container_definitions.fargate_cpu,
        memory: var.container_definitions.fargate_memory,
        networkMode: "awsvpc",
        logConfiguration: {
          logDriver: "awslogs",
          options: {
            awslogs-group: aws_cloudwatch_log_group.ecs_log_group.name,
            awslogs-region: var.network.aws_region,
            awslogs-stream-prefix: "ecs"
          }
        },
        portMappings: [
          {
            containerPort: var.container_definitions.app_port
          }
        ],
        environment: var.env_vars
        secrets: var.secrets.secret_values
      }
    ]
  )

  runtime_platform {
    operating_system_family = var.container_definitions.os
    cpu_architecture        = var.container_definitions.cpu_architecture
  }
}
