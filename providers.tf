provider "azurerm" {
  features {}
}

# Databricks provider can be configured in module or root using environment variables or variables passed from pipeline.
# Example (if using provider block here):
# provider "databricks" {
#   azure_workspace_resource_id = var.databricks_workspace_resource_id
#   azure_client_id             = var.azure_client_id
#   azure_client_secret         = var.azure_client_secret
#   azure_tenant_id             = var.azure_tenant_id
# }
data "azurerm_client_config" "current" {}
