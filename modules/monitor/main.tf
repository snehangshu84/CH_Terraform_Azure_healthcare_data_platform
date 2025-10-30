resource "azurerm_log_analytics_workspace" "la" {
  name                = var.log_analytics_name
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "PerGB2018"
  retention_in_days   = 365
}

resource "azurerm_application_insights" "ai" {
  name                = "${var.log_analytics_name}-ai"
  location            = var.location
  resource_group_name = var.rg_name
  application_type    = "web"
}
