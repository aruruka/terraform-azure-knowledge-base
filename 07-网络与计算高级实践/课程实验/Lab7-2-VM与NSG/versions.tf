# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.38.1"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  # subscription_id 和 tenant_id 将从环境变量自动读取
  # 设置以下环境变量：
  # $env:ARM_SUBSCRIPTION_ID = "your-subscription-id"
  # $env:ARM_TENANT_ID = "your-tenant-id"
  # 
  # 这样可以避免在代码中硬编码敏感信息
}
