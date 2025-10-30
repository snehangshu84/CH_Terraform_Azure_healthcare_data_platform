variable "rg_name" { type = string }
variable "location" { type = string }
variable "storage_account_name" { type = string }
variable "vnet_subnet_id" { type = string }
variable "key_vault_key_id" { type = string default = null }
variable "tags" { type = map(string) default = {} }
