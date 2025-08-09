# Create an Azure KeyVault

This document explains how to create an Azure KeyVault using Terraform, as covered in Lecture 67 of the course.

## Steps to Create KeyVault

1. **Set Up a New Lab Folder**:
   - Navigate to the `Terraform101` directory.
   - Create a new folder, e.g., `Lab4`.

2. **Set Up Standard Files**:
   - Inside the new folder, create the following files:
     - `versions.tf`
     - `variables.tf`
     - `main.tf`
     - `outputs.tf`

3. **Add KeyVault Resource**:
   - In the `main.tf` file, add the following resource:
     ```hcl
     resource "azurerm_key_vault" "example" {
       name                        = "example-keyvault"
       location                    = "East US"
       resource_group_name         = "example-rg"
       tenant_id                   = "example-tenant-id"
       sku_name                    = "standard"
       enable_rbac_authorization   = true
     }
     ```

4. **Initialize and Apply**:
   - Run the following commands:
     ```bash
     terraform init
     terraform apply
     ```

## Notes
- Use RBAC for managing access to the KeyVault.
- Ensure the resource group exists before creating the KeyVault.
