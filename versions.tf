terraform {
  required_version = ">= 1.4.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.66.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = ">= 1.3.0"
    }
  }
}
