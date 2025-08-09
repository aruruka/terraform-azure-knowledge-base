resource "azurerm_resource_group" "main" {
  name     = "rg-synthetic-app-env"
  location = var.primary_location

  tags = {
    environment = "synthetic-env"
    lab         = "synthetic-lab"
  }
}

data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

resource "random_string" "keyvault_suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_key_vault" "main" {
  name                        = "kv-synthetic-app-env-${random_string.keyvault_suffix.result}"
  location                    = azurerm_resource_group.main.location
  resource_group_name         = azurerm_resource_group.main.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  enable_rbac_authorization = true
}
