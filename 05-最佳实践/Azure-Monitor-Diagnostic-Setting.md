# Azure Monitor Diagnostic Setting

This document explains how to configure Azure Monitor Diagnostic Settings using Terraform, as covered in Lecture 73 of the course.

## Why Use Diagnostic Settings?
Diagnostic settings allow you to collect logs and metrics from Azure resources and send them to destinations like Log Analytics, Event Hubs, or Storage Accounts.

## Steps to Configure

1. **Set Up a New Lab Folder**:
   - Navigate to the `Terraform101` directory.
   - Create a new folder, e.g., `Lab5`.

2. **Set Up Standard Files**:
   - Inside the new folder, create the following files:
     - `versions.tf`
     - `variables.tf`
     - `main.tf`
     - `outputs.tf`

3. **Add Diagnostic Setting Resource**:
   - In the `main.tf` file, add the following resource:
     ```hcl
     resource "azurerm_monitor_diagnostic_setting" "example" {
       name               = "example-diagnostic-setting"
       target_resource_id = azurerm_key_vault.example.id

       log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id

       log {
         category = "AuditEvent"
         enabled  = true
         retention_policy {
           enabled = true
           days    = 30
         }
       }
     }
     ```

4. **Initialize and Apply**:
   - Run the following commands:
     ```bash
     terraform init
     terraform apply
     ```

## Notes
- Ensure the Log Analytics Workspace exists before configuring the diagnostic setting.
- Use appropriate retention policies to manage log storage costs.
