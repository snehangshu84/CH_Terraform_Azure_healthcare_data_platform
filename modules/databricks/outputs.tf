output "metastore_id" { value = databricks_metastore.unity.id }
output "secret_scope_name" { value = databricks_secret_scope.kv_scope.name }
output "notebook_path" { value = databricks_notebook.data_quality_check.path }
output "job_id" { value = databricks_job.daily_etl.id }
