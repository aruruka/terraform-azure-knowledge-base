# Configure Azure Terraform Provider

This document explains how to set up the Azure provider for Terraform, as covered in Lecture 55 of the course.

## Steps to Configure

1. **Create a New Lab Folder**:
   - Navigate to the `Terraform101` directory.
   - Create a new folder, e.g., `Lab2`.

2. **Set Up Standard Files**:
   - Inside the new folder, create the following files:
     - `versions.tf`
     - `variables.tf`
     - `main.tf`
     - `outputs.tf`

3. **Initialize Terraform**:
   - Open the terminal and run:
     ```bash
     terraform init
     ```

4. **Browse Azure Provider Documentation**:
   - Visit the [Terraform Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs).
   - Review the overview and examples to understand the provider's capabilities.

## Example Configuration

Below is a basic example of configuring the Azure provider:

```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "East US"
}
```

## Notes
- Ensure you have authenticated with Azure CLI before running `terraform init`.
- Use the `azurerm` provider to manage Azure resources effectively.
