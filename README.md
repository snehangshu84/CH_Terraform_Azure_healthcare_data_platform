# Azure Healthcare Data Platform - Terraform
This repo contains Terraform modules and Azure DevOps pipeline YAML to provision a HIPAA-minded Azure data platform:
- VNets, subnets, private endpoints
- Key Vault with soft delete and purge protection
- ADLS Gen2 storage account (private endpoint)
- Databricks workspace (Unity Catalog, secret scope backed by Key Vault, clusters, jobs, notebooks)
- Data Factory
- Log Analytics / Monitoring
- Azure DevOps pipeline (plan & apply patterns)

**DO NOT** commit secrets. Replace placeholders in `terraform.tfvars` before running.
