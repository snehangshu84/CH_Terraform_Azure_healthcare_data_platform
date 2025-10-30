#!/usr/bin/env bash
set -euo pipefail

RG_NAME="<TFSTATE_RG_NAME>"
LOCATION="eastus"
STORAGE_ACCOUNT_NAME="<TFSTATE_ACCOUNT_NAME>"  # must be globally unique, lowercase letters+numbers
CONTAINER_NAME="tfstate"

echo "Creating resource group $RG_NAME..."
az group create -n "$RG_NAME" -l "$LOCATION"

echo "Creating storage account $STORAGE_ACCOUNT_NAME..."
az storage account create -n "$STORAGE_ACCOUNT_NAME" -g "$RG_NAME" -l "$LOCATION"   --sku Standard_LRS --kind StorageV2 --https-only true

echo "Enable soft delete for blobs..."
az storage blob service-properties delete-policy update --account-name "$STORAGE_ACCOUNT_NAME" --enable true --days-retained 14

echo "Creating container $CONTAINER_NAME..."
ACCOUNT_KEY=$(az storage account keys list -g "$RG_NAME" -n "$STORAGE_ACCOUNT_NAME" --query '[0].value' -o tsv)
az storage container create --name "$CONTAINER_NAME" --account-name "$STORAGE_ACCOUNT_NAME" --account-key "$ACCOUNT_KEY"

echo "Done. Update backend.tf with resource_group_name and storage_account_name."
