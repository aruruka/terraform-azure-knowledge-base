terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.38.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.2"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-synthetic-state"
    storage_account_name = "syntheticstorage"
    container_name       = "synthetic-container"
    key                  = "synthetic-key"
  }
}
provider "azurerm" {
  features {}
}
