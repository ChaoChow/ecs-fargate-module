variable "name" {
  description = "Prefix to use for all AWS resources"
}

variable "network" {
  description = "Contains network configs"
  type = object({
    aws_region : string
    vpc_id : string
    public_subnet_ids : list(string)
    private_subnet_ids : list(string)
  })
}

variable "ecs_cluster" {
  description = "Contains information about the ECS cluster"
  type = object({
    id : string
    name : string
  })
}

variable "container_definitions" {
  description = "Contains configs for the ECS container"
  type = object({
    app_name : string
    app_image : string
    app_port : number
    desired_starting_count : number
    fargate_cpu : number
    fargate_memory : number
    health_check_path : string
    os : string
    cpu_architecture : string
  })
  default = {
    app_name : ""
    app_image : ""
    app_port : 8000
    desired_starting_count : 1
    fargate_cpu : "512"
    fargate_memory : "2048"
    health_check_path : "/admin/health"
    os : "LINUX"
    cpu_architecture : "ARM64"
  }
}

variable "auto_scaling" {
  description = "Configs for managing the autoscaling of ecs instances"
  type = object({
    min_instance_count_target           = number
    max_instance_count_target           = number
    cloudwatch_alarm_evaluation_periods = string
    cloudwatch_alarm_periods            = string
    high_cpu_utilization_threshold      = string
    low_cpu_utilization_threshold       = string
    scaling_cooldown                    = number
  })
  default = {
    min_instance_count_target           = 1
    max_instance_count_target           = 3
    cloudwatch_alarm_evaluation_periods = "2"
    cloudwatch_alarm_periods            = "30"
    high_cpu_utilization_threshold      = "50"
    low_cpu_utilization_threshold       = "10"
    scaling_cooldown                    = 60
  }
}

variable "alb_health_check" {
  description = "Contains values to configure the health check for the ALB on the fargate instances. All values are strings containing integers. Interval and Timeout are in seconds. Details on these values can be found here: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#health_check"
  type = object({
    healthy_threshold   = string
    interval            = string
    timeout             = string
    unhealthy_threshold = string
  })
  default = {
    healthy_threshold   = "3"
    interval            = "30"
    timeout             = "6"
    unhealthy_threshold = "3"
  }
}

variable "alb_stickiness" {
  description = "Contains values to configure sticky sessions where the ALB routes requests to the same instance. All values can be found here: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#stickiness"
  type = object({
    cookie_duration = number
    cookie_name     = string
    enabled         = bool
    type            = string
  })
  default = {
    cookie_duration = 86400
    cookie_name     = "app_session"
    enabled         = true
    type            = "lb_cookie"
  }
}

variable "secrets" {
  description = "Contains values used to configure the adding of secrets to the ecs task"
  type = object({
    secrets_kms_key_id = string
    secret_values = list(object({
      name      = string
      valueFrom = string
    }))
  })
  default = {
    secrets_kms_key_id = null
    secret_values      = []
  }
}

variable "env_vars" {
  description = "Contains any environment variables you would like to inject into the ecs container"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "additional_policies" {
  description = "List of additional JSON policies objects you would like to attach to your ECS Fargate Role. Valid properties of list objects are 'name' and 'json'. 'json' property should have the IAM policy in JSON format as the value. Use JSON format not HCL object format."
  type = list(object({
    name = string
    json = any
  }))
  default = []
}