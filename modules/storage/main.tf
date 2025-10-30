resource "azurerm_storage_account" "datalake" {
  name                     = var.storage_account_name
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  is_hns_enabled           = true
  enable_https_traffic_only = true

  identity {
    type = "SystemAssigned"
  }

  network_rules {
    default_action = "Deny"
    virtual_network_subnet_ids = [var.vnet_subnet_id]
  }

  blob_properties {
    delete_retention_policy {
      days = 14
    }
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_pe" {
  name                = "${var.storage_account_name}-pe"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.vnet_subnet_id

  private_service_connection {
    name                           = "${var.storage_account_name}-psc"
    private_connection_resource_id = azurerm_storage_account.datalake.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}

resource "azurerm_storage_account_customer_managed_key" "cmk" {
  count               = var.key_vault_key_id == null ? 0 : 1
  storage_account_id  = azurerm_storage_account.datalake.id
  key_vault_key_id    = var.key_vault_key_id
}
