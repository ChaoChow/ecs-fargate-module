resource "aws_alb" "main" {
  name            = "${local.full_app_name}-lb"
  subnets         = [for subnet in var.network.public_subnet_ids : subnet]
  security_groups = [aws_security_group.lb.id]
}

resource "aws_alb_target_group" "app" {
  name        = "${var.name}-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.network.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = var.alb_health_check.healthy_threshold
    interval            = var.alb_health_check.interval
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = var.alb_health_check.timeout
    path                = var.container_definitions.health_check_path
    unhealthy_threshold = var.alb_health_check.unhealthy_threshold
  }

  stickiness {
    cookie_duration= var.alb_stickiness.cookie_duration
    cookie_name = var.alb_stickiness.cookie_name
    enabled = var.alb_stickiness.enabled
    type = var.alb_stickiness.type
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.main.id
  port              = var.container_definitions.app_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.app.id
    type             = "forward"
  }
}
