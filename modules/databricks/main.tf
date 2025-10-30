resource "azurerm_databricks_workspace" "this" {
  name                        = var.workspace_name
  location                    = var.location
  resource_group_name         = var.rg_name
  managed_resource_group_name = var.managed_rg_name
  sku                         = var.workspace_sku
  tags = { env = var.environment }
}

output "databricks_workspace_id" {
  value = azurerm_databricks_workspace.this.id
}

output "databricks_workspace_url" {
  value = azurerm_databricks_workspace.this.workspace_url
}

# Unity Catalog Metastore (Databricks provider resource - requires databricks provider configured)
resource "databricks_metastore" "unity" {
  name         = "${var.workspace_name}-metastore"
  storage_root = "abfss://${var.metastore_container_name}@${var.metastore_storage_account}.dfs.core.windows.net/"
  force_destroy = false
  region        = var.location
}

resource "databricks_metastore_assignment" "assign" {
  workspace_id = azurerm_databricks_workspace.this.id
  metastore_id = databricks_metastore.unity.id
  default_catalog_name = "main"
}

resource "databricks_secret_scope" "kv_scope" {
  name = "hkv-secrets-${var.environment}"

  keyvault_metadata {
    resource_id = var.key_vault_id
    dns_name    = var.key_vault_uri
  }
}

resource "databricks_notebook" "data_quality_check" {
  path     = "/Shared/healthcare/data_quality_check"
  language = "PYTHON"
  source   = file("${path.module}/notebooks/data_quality_check.py")
}

resource "databricks_cluster" "etl_cluster" {
  cluster_name            = "${var.workspace_name}-etl-${var.environment}"
  spark_version           = "14.3.x-scala2.12"
  node_type_id            = "Standard_DS3_v2"
  autotermination_minutes = 30
  spark_conf = { "spark.databricks.cluster.profile" = "serverless" }
  autoscale { min_workers = 2, max_workers = 6 }
  custom_tags = { "Environment" = var.environment, "HIPAA" = "true" }
}

resource "databricks_job" "daily_etl" {
  name = "daily-healthcare-etl-${var.environment}"

  job_cluster {
    job_cluster_key = "etl_job_cluster"
    new_cluster {
      spark_version = "14.3.x-scala2.12"
      node_type_id  = "Standard_DS3_v2"
      num_workers    = 2
      autotermination_minutes = 60
      spark_conf = { "spark.databricks.cluster.profile" = "serverless" }
    }
  }

  notebook_task {
    notebook_path = databricks_notebook.data_quality_check.path
  }

  schedule {
    quartz_cron_expression = "0 0 2 * * ?"
    timezone_id            = "America/Chicago"
  }
}
