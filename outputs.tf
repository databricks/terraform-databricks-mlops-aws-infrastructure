output "dev_secret_scope_name_for_staging" {
  value       = module.remote_model_registry_dev_to_staging.local_secret_scope_name
  description = "The name of the secret scope created in the dev workspace that is used for remote model registry access to the staging workspace."
}

output "dev_secret_scope_name_for_prod" {
  value       = module.remote_model_registry_dev_to_prod.local_secret_scope_name
  description = "The name of the secret scope created in the dev workspace that is used for remote model registry access to the prod workspace."
}

output "staging_secret_scope_name_for_prod" {
  value       = module.remote_model_registry_staging_to_prod.local_secret_scope_name
  description = "The name of the secret scope created in the staging workspace that is used for remote model registry access to the prod workspace."
}

output "dev_secret_scope_prefix_for_staging" {
  value       = module.remote_model_registry_dev_to_staging.local_secret_scope_prefix
  description = "The prefix used in the dev workspace secret scope for remote model registry access to the staging workspace."
}

output "dev_secret_scope_prefix_for_prod" {
  value       = module.remote_model_registry_dev_to_prod.local_secret_scope_prefix
  description = "The prefix used in the dev workspace secret scope for remote model registry access to the prod workspace."
}

output "staging_secret_scope_prefix_for_prod" {
  value       = module.remote_model_registry_staging_to_prod.local_secret_scope_prefix
  description = "The prefix used in the staging workspace secret scope for remote model registry access to the prod workspace."
}

output "service_principal_group_name" {
  value       = databricks_group.staging_sp_group.display_name
  description = "The name of the service principal group created in the staging and prod workspace."
}
