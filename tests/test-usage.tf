terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = ">= 0.5.8"
    }
  }
}

provider "databricks" {
  alias = "dev"
}

provider "databricks" {
  alias = "staging"
}

provider "databricks" {
  alias = "prod"
}

module "mlops_aws_infrastructure" {
  source = "../."
  providers = {
    databricks.dev     = databricks.dev
    databricks.staging = databricks.staging
    databricks.prod    = databricks.prod
  }
  staging_workspace_id          = "123456789"
  prod_workspace_id             = "987654321"
  additional_token_usage_groups = ["users"] # This field is optional.
}
