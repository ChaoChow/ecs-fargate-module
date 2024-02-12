locals {
  full_app_name      = "${var.name}-${var.container_definitions.app_name}"
  should_add_secrets = var.secrets.secrets_kms_key_id != null && length(var.secrets.secret_values) > 0 ? true : false
}
