# Configure Terraform Remote State with Azure Storage

This document explains how to configure Terraform remote state using Azure Storage, as covered in Lecture 62 of the course.

## Why Use Remote State?
Remote state allows multiple team members to collaborate on Terraform projects by storing the state file in a shared location. Azure Storage is a reliable backend for this purpose.

## Steps to Configure

1. **Create a New Lab Folder**:
   - Navigate to the `Terraform101` directory.
   - Create a new folder, e.g., `Lab3`.

2. **Set Up Standard Files**:
   - Inside the new folder, create the following files:
     - `versions.tf`
     - `variables.tf`
     - `main.tf`
     - `outputs.tf`

3. **Add Backend Configuration**:
   - In the `main.tf` file, add the following backend block:
     ```hcl
     terraform {
       backend "azurerm" {
         resource_group_name  = "example-rg"
         storage_account_name = "examplestorage"
         container_name       = "tfstate"
         key                  = "terraform.tfstate"
       }
     }
     ```

4. **Initialize Terraform**:
   - Run the following command to initialize the backend:
     ```bash
     terraform init
     ```

## Notes
- Ensure the Azure Storage account and container are created before configuring the backend.
- Use unique keys for different environments to avoid conflicts.
