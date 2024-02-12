# ECS task assume role
data "aws_iam_policy_document" "ecs_task_assume_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# ECS task execution role
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${local.full_app_name}-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "read_task_container_secrets" {
  count  = local.should_add_secrets ? 1 : 0
  name   = "${local.full_app_name}-read-secrets"
  role   = aws_iam_role.ecs_task_execution_role.id
  policy = data.aws_iam_policy_document.secrets.json
}

data "aws_iam_policy_document" "secrets" {
  statement {
    effect = "Allow"

    resources = concat(
      [data.aws_kms_key.secrets_key.arn],
      [for i in var.secrets.secret_values : replace(i["valueFrom"], "/:[^:]+::$/", "")]
    )
    actions = [
      "secretsmanager:GetSecretValue",
      "kms:Decrypt",
    ]
  }
}

data "aws_kms_key" "secrets_key" {
  key_id = var.secrets.secrets_kms_key_id
}

# ECS Task Role
resource "aws_iam_role" "ecs_task_role" {
  name               = "${local.full_app_name}-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

resource "aws_iam_role_policy" "additional_policies" {
  count  = length(var.additional_policies)
  name   = var.additional_policies[count.index].name
  role   = aws_iam_role.ecs_task_role.id
  policy = jsonencode(var.additional_policies[count.index].json)
}
