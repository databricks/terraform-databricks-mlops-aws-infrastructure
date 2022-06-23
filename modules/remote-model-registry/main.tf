variable "remote_service_principal_application_id" {
  type        = string
  description = "Application ID for the service principal in the remote workspace that will have READ-only model registry access."
}

variable "local_secret_scope_name" {
  type        = string
  description = "Desired name of the secret scope in the local workspace."
}

variable "local_secret_scope_prefix" {
  type        = string
  description = "Desired prefix for remote model registry secrets stored in the local workspace secret scope."
}

variable "remote_workspace_id" {
  type        = string
  description = "Workspace ID of the remote workspace (can be often found in the URL) to be stored as a secret in the local secret scope."
}

variable "remote_service_principal_token" {
  type        = string
  description = "Personal access token (PAT) for the service principal in the remote workspace to be stored as a secret in the local secret scope."
  sensitive   = true
}

variable "local_secret_scope_groups" {
  type        = list(string)
  description = "Group names that will have READ-only access to the local secret scope."
}

data "databricks_current_user" "remote_user" {
  provider = databricks.remote
}

resource "databricks_secret_scope" "local_secret_scope" {
  provider = databricks.local
  name     = var.local_secret_scope_name
}

resource "databricks_secret" "remote_workspace_id" {
  provider     = databricks.local
  key          = "${var.local_secret_scope_prefix}-workspace-id"
  string_value = var.remote_workspace_id
  scope        = databricks_secret_scope.local_secret_scope.id
}

resource "databricks_secret" "remote_host" {
  provider     = databricks.local
  key          = "${var.local_secret_scope_prefix}-host"
  string_value = data.databricks_current_user.remote_user.workspace_url
  scope        = databricks_secret_scope.local_secret_scope.id
}

resource "databricks_secret" "remote_token" {
  provider     = databricks.local
  key          = "${var.local_secret_scope_prefix}-token"
  string_value = var.remote_service_principal_token
  scope        = databricks_secret_scope.local_secret_scope.id
}

resource "databricks_secret_acl" "local_secret_scope_acl" {
  provider   = databricks.local
  for_each   = toset(var.local_secret_scope_groups)
  principal  = each.value
  permission = "READ"
  scope      = databricks_secret_scope.local_secret_scope.name
}

resource "databricks_permissions" "remote_model_registry_permissions" {
  provider            = databricks.remote
  registered_model_id = "root"

  access_control {
    service_principal_name = var.remote_service_principal_application_id
    permission_level       = "CAN_READ"
  }
}

output "local_secret_scope_name" {
  value       = databricks_secret_scope.local_secret_scope.name
  description = "Name of the created secret scope in the local workspace. This is used to access the remote model registry."
}

output "local_secret_scope_prefix" {
  value       = var.local_secret_scope_prefix
  description = "Prefix of the created secrets in the local workspace secret scope. This is used to access the remote model registry."
}
