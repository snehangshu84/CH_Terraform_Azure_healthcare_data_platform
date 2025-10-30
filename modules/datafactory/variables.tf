variable "rg_name" { type = string }
variable "location" { type = string }
variable "adf_name" { type = string }
variable "vnet_subnet_id" { type = string }
variable "storage_account_id" { type = string default = "" }
variable "tags" { type = map(string) default = {} }
