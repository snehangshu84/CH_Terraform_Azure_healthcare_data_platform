resource "azurerm_data_factory" "adf" {
  name                = var.adf_name
  location            = var.location
  resource_group_name = var.rg_name
  tags = var.tags
}

resource "azurerm_private_endpoint" "adf_storage_pe" {
  name                = "${var.adf_name}-storage-pe"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.vnet_subnet_id

  private_service_connection {
    name                           = "${var.adf_name}-psc"
    private_connection_resource_id = var.storage_account_id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}
