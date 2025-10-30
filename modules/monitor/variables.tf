variable "rg_name" { type = string }
variable "location" { type = string }
variable "log_analytics_name" { type = string }
variable "tags" { type = map(string) default = {} }
