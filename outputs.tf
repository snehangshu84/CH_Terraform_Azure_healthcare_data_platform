output "resource_group_name" { value = azurerm_resource_group.platform.name }
output "key_vault_id" { value = module.keyvault.key_vault_id }
output "datalake_storage_account_id" { value = module.storage.storage_account_id }
output "databricks_workspace_id" { value = module.databricks.databricks_workspace_id }
