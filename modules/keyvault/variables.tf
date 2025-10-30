variable "rg_name" { type = string }
variable "location" { type = string }
variable "kv_name" { type = string }
variable "tenant_id" { type = string }
variable "vnet_subnet_id" { type = string }
variable "tags" { type = map(string) default = {} }
