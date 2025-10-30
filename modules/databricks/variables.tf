variable "rg_name"              { type = string }
variable "location"             { type = string }
variable "workspace_name"       { type = string }
variable "managed_rg_name"      { type = string }
variable "vnet_subnet_id"       { type = string }
variable "key_vault_id"         { type = string }
variable "key_vault_uri"        { type = string }
variable "metastore_storage_account" { type = string }
variable "metastore_container_name"  { type = string default = "metastore" }
variable "workspace_sku"        { type = string default = "premium" }
variable "azure_client_id"      { type = string default = "" }
variable "azure_client_secret"  { type = string default = "" }
variable "azure_tenant_id"      { type = string default = "" }
variable "environment"          { type = string default = "prod" }
