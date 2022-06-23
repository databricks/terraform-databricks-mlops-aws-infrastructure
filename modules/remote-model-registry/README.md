# Remote Model Registry Module

This module will set up remote model registry between a local Databricks workspace and a remote Databricks workspace, using a pre-created service principal in the remote workspace. It will create a secret scope and store the necessary secrets, and only give READ access to this secret scope to the groups in the user-provided list. It will also give registry-wide READ permissions to the remote service principal provided by the user in the remote workspace. The output of this module will be the local secret scope name and prefix since these two values are needed to be able to [access the remote model registry](https://docs.databricks.com/applications/machine-learning/manage-model-lifecycle/multiple-workspaces.html#specify-a-remote-registry).

**_NOTE:_** The [Databricks providers](https://registry.terraform.io/providers/databricks/databricks/latest/docs) that are passed into the module must be configured with workspace admin permissions to setup the local secret scope and remote registry-wide permissions.

## Usage
```hcl
provider "databricks" {
  alias = "remote"    # Authenticate using preferred method as described in Databricks provider
}

provider "databricks" {
  alias = "local"     # Authenticate using preferred method as described in Databricks provider
}

module "remote-model-registry" {
  source = "databricks/remote-model-registry/databricks"
  providers = {
    databricks.local = databricks.local
    databricks.remote = databricks.remote
  }
  local_secret_scope_groups               = ["example-group1", "example-group2"]
  local_secret_scope_name                 = "example-ss"
  local_secret_scope_prefix               = "example-prefix"
  remote_service_principal_application_id = "acbd-1234-5678-efgh"
  remote_service_principal_token          = "<sensitive-sp-token>"
  remote_workspace_id                     = "123456789"
}
```

## Requirements
| Name | Version |
|------|---------|
|[terraform](https://registry.terraform.io/)|\>=1.1.6|
|[databricks](https://registry.terraform.io/providers/databricks/databricks/0.5.8)|\>=0.5.8|

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
|local_secret_scope_groups|Group names that will have READ-only access to the local secret scope, which gives them READ-only access to the remote model registry.|list(string)|N/A|yes|
|local_secret_scope_name|Desired name of the secret scope in the local Databricks workspace.|string|N/A|yes|
|local_secret_scope_prefix|Desired prefix for remote model registry secrets stored in the local Databricks workspace secret scope.|string|N/A|yes|
|remote_service_principal_application_id|Application ID for the service principal in the remote workspace that will have READ-only model registry access.|string|N/A|yes|
|remote_service_principal_token|This variable is marked as SENSITIVE. Personal access token (PAT) for the service principal in the remote workspace to be stored as a secret in the local secret scope.|string|N/A|yes|
|remote_workspace_id|Workspace ID of the remote workspace ([can be often found in the URL](https://docs.databricks.com/workspace/workspace-details.html#workspace-instance-names-urls-and-ids)) to be stored as a secret in the local secret scope.|string|N/A|yes|

## Outputs
| Name | Description | Type | Sensitive |
|------|-------------|------|---------|
|local_secret_scope_name|Name of the created secret scope in the local workspace. This is used to access the remote model registry.|string|no|
|local_secret_scope_prefix|Prefix of the created secrets in the local workspace secret scope. This is used to access the remote model registry.|string|no|

## Providers
| Name | Authentication | Use |
|------|-------------|----|
|databricks.local|Provided by the user.|Generate all resources in the local workspace.|
|databricks.remote|Provided by the user.|Pull remote host for secret and generate `databricks_permissions` resources in the remote workspace.|

## Resources
| Name | Type |
|------|------|
|databricks_current_user.remote_user|data source|
|databricks_secret_scope.local_secret_scope|resource|
|databricks_secret.remote_workspace_id|resource|
|databricks_secret.remote_host|resource|
|databricks_secret.remote_token|resource|
|databricks_secret_acl.local_secret_scope_acl|for_each(resource)|
|databricks_permissions.remote_model_registry_permissions|resource|