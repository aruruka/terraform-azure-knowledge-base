terraform {
  required_version = ">= 1.0"

  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "= 2.6.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }
  }

  backend "azurerm" {}
}

provider "azapi" {
  # Configuration options
}
