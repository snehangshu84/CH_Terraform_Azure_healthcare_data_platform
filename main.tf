locals {
  name_prefix = "${var.prefix}-${var.env}-${var.name_suffix}"
}

resource "azurerm_resource_group" "platform" {
  name     = "${local.name_prefix}-rg-platform"
  location = var.location
  tags = {
    env = var.env
    owner = "platform-team"
  }
}

module "network" {
  source        = "./modules/network"
  rg_name       = azurerm_resource_group.platform.name
  location      = var.location
  vnet_name     = "${local.name_prefix}-vnet"
  address_space = ["10.20.0.0/16"]
  subnets = {
    infra     = "10.20.0.0/24"
    databricks = "10.20.1.0/24"
    storage   = "10.20.2.0/24"
    adf       = "10.20.3.0/24"
  }
}

module "keyvault" {
  source      = "./modules/keyvault"
  rg_name     = azurerm_resource_group.platform.name
  location    = var.location
  kv_name     = "${local.name_prefix}-kv"
  tenant_id   = data.azurerm_client_config.current.tenant_id
  vnet_subnet_id = module.network.subnet_ids["infra"]
}

module "storage" {
  source             = "./modules/storage"
  rg_name            = azurerm_resource_group.platform.name
  location           = var.location
  storage_account_name = lower("${local.name_prefix}dl")
  vnet_subnet_id     = module.network.subnet_ids["storage"]
  key_vault_key_id   = var.storage_cmk_key_id != "" ? var.storage_cmk_key_id : null
}

module "databricks" {
  source                 = "./modules/databricks"
  rg_name                = azurerm_resource_group.platform.name
  location               = var.location
  workspace_name         = "${local.name_prefix}-dbw"
  managed_rg_name        = "${local.name_prefix}-dbw-mgrg"
  vnet_subnet_id         = module.network.subnet_ids["databricks"]
  key_vault_id           = module.keyvault.key_vault_id
  key_vault_uri          = azurerm_key_vault.kv.vault_uri
  metastore_storage_account = module.storage.storage_account_name
}

module "datafactory" {
  source = "./modules/datafactory"
  rg_name = azurerm_resource_group.platform.name
  location = var.location
  adf_name = "${local.name_prefix}-adf"
  vnet_subnet_id = module.network.subnet_ids["adf"]
  storage_account_id = module.storage.storage_account_id
}

module "monitor" {
  source = "./modules/monitor"
  rg_name = azurerm_resource_group.platform.name
  location = var.location
  log_analytics_name = "${local.name_prefix}-la"
}
