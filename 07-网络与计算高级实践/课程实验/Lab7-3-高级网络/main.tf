resource "azurerm_resource_group" "main" {
  name     = "rg-synthetic-${var.environment_name}"
  location = var.primary_location

  tags = {
    environment = var.environment_name
    lab         = "synthetic-lab"
  }
}

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
  tenant_id                   = "synthetic-tenant-id"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  enable_rbac_authorization = true
}

resource "azurerm_log_analytics_workspace" "main" {
  name                = "log-synthetic-${var.environment_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
