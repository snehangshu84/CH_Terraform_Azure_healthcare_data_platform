terraform {
  backend "azurerm" {
    resource_group_name  = "<TFSTATE_RG_NAME>"        # created by bootstrap script
    storage_account_name = "<TFSTATE_ACCOUNT_NAME>"   # created by bootstrap script
    container_name       = "tfstate"
    key                  = "prod/infra.terraform.tfstate"
  }
}
