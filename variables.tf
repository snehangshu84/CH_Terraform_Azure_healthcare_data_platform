variable "env" { type = string, default = "prod" }
variable "location" { type = string, default = "eastus" }
variable "prefix" { type = string, default = "hc" }
variable "subscription_id" { type = string }
variable "tenant_id" { type = string }
variable "name_suffix" { type = string, default = "001" }
variable "storage_cmk_key_id" { type = string, default = "" }
