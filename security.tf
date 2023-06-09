# ALB Security Group: Edit to restrict access to the application
resource "aws_security_group" "lb" {
  name        = "${var.name}-load-balancer-security-group"
  description = "controls access to the ALB"
  vpc_id      = var.network.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = var.container_definitions.app_port
    to_port     = var.container_definitions.app_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ecs_tasks" {
  name        = "${var.name}-ecs-tasks-security-group"
  description = "allow inbound access from the ALB only"
  vpc_id      = var.network.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = var.container_definitions.app_port
    to_port         = var.container_definitions.app_port
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
