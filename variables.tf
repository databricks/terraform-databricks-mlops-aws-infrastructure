variable "staging_workspace_id" {
  type        = string
  description = "Workspace ID of the staging workspace (can be often found in the URL) used for remote model registry setup."
}

variable "prod_workspace_id" {
  type        = string
  description = "Workspace ID of the prod workspace (can be often found in the URL) used for remote model registry setup."
}

variable "additional_token_usage_groups" {
  type        = list(string)
  description = "List of groups that should have token usage permissions in the staging and prod workspaces, along with the created service principal group (mlops-service-principals). By default, it is empty."
  default     = []
}
