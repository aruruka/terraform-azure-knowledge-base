data "azapi_client_config" "current" {}

data "azapi_resource" "network_rg" {
  name      = "rg-network-dev-synth"
  parent_id = "/subscriptions/${data.azapi_client_config.current.subscription_id}"
  type      = "Microsoft.Resources/resourceGroups@2021-04-01"
}

data "azapi_resource" "vnet" {
  name      = "vnet-network-dev-synth"
  type      = "Microsoft.Network/virtualNetworks@2024-07-01"
  parent_id = data.azapi_resource.network_rg.id
}

data "azapi_resource" "subnet_bravo" {
  name      = "snet-bravo-synth"
  parent_id = data.azapi_resource.vnet.id
  type      = "Microsoft.Network/virtualNetworks/subnets@2024-07-01"

  response_export_values = ["name"]
}

# Reference existing Key Vault in rg-devops-dev
data "azapi_resource" "existing_keyvault" {
  name      = "kv-devops-dev-synth"
  parent_id = "/subscriptions/${data.azapi_client_config.current.subscription_id}/resourceGroups/rg-devops-dev-synth"
  type      = "Microsoft.KeyVault/vaults@2023-07-01"
}

locals {
  common_tags = {
    Environment = "${var.environment_name}"
    Application = "${var.application_name}"
    ManagedBy   = "Terraform"
  }

  owner_tags = {
    Owner = lookup(var.owner_info, "email", "team@example.com")
  }

  # 允许通过 var.additional_tags 在每个部署环境中追加或覆盖
  effective_tags = merge(local.common_tags, local.owner_tags, var.additional_tags)
}

resource "azapi_resource" "rg" {
  type     = "Microsoft.Resources/resourceGroups@2021-04-01"
  name     = "rg-${var.application_name}-${var.environment_name}"
  location = var.primary_location

  parent_id = "/subscriptions/${data.azapi_client_config.current.subscription_id}"
}

# Generate SSH key pair
resource "tls_private_key" "vm1" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create Key Vault secret for SSH private key in existing Key Vault
resource "azapi_resource" "ssh_private_secret" {
  type      = "Microsoft.KeyVault/vaults/secrets@2023-07-01"
  name      = "vm1-ssh-private-${var.application_name}-${var.environment_name}"
  parent_id = data.azapi_resource.existing_keyvault.id

  body = {
    properties = {
      value = tls_private_key.vm1.private_key_pem
    }
  }

  lifecycle {
    ignore_changes = [location]
  }
}

# Create Key Vault secret for SSH public key in existing Key Vault
resource "azapi_resource" "ssh_public_secret" {
  type      = "Microsoft.KeyVault/vaults/secrets@2023-07-01"
  name      = "vm1-ssh-public-${var.application_name}-${var.environment_name}"
  parent_id = data.azapi_resource.existing_keyvault.id

  body = {
    properties = {
      value = tls_private_key.vm1.public_key_openssh
    }
  }

  lifecycle {
    ignore_changes = [location]
  }
}

resource "azapi_resource" "vm_pip" {
  type      = "Microsoft.Network/publicIPAddresses@2024-07-01"
  name      = "pip-${var.application_name}-${var.environment_name}"
  location  = azapi_resource.rg.location
  parent_id = azapi_resource.rg.id

  body = {
    properties = {
      publicIPAllocationMethod = "Static"
      publicIPAddressVersion   = "IPv4"
    }
    sku = {
      name = "Standard"
      tier = "Regional"
    }
  }
}

resource "azapi_resource" "vm1_nic" {
  type      = "Microsoft.Network/networkInterfaces@2024-07-01"
  name      = "nic-${var.application_name}-${var.environment_name}"
  parent_id = azapi_resource.rg.id
  location  = azapi_resource.rg.location
  tags      = local.effective_tags
  body = {
    properties = {
      ipConfigurations = [
        {
          name = "public"
          properties = {
            privateIPAllocationMethod = "Dynamic"
            publicIPAddress = {
              id = azapi_resource.vm_pip.id
            }
            subnet = {
              id = data.azapi_resource.subnet_bravo.id
            }
          }
        }
      ]
    }
  }
}
