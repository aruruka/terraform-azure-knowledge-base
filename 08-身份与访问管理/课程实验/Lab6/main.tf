resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}-${var.environment_name}"
  location = var.primary_location

  tags = {
    environment = var.environment_name
    lab         = var.lab_name
  }
}

resource "azurerm_public_ip" "vm1" {
  name                = "pip-${var.application_name}-${var.environment_name}-vm1"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"

  tags = {
    environment = "${var.environment_name}"
  }
}

data "azurerm_subnet" "bravo" {
  name                 = var.subnet_name
  virtual_network_name = var.network_vnet_name
  resource_group_name  = var.network_resource_group
}

resource "azurerm_network_interface" "vm1" {
  name                = "nic-${var.application_name}-${var.environment_name}-vm1"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "public"
    subnet_id                     = data.azurerm_subnet.bravo.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm1.id
  }
}

# Generate an SSH key pair for VM login
# RSA key of size 4096 bits
resource "tls_private_key" "vm1" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "azurerm_key_vault" "main" {
  # Key Vault to store generated SSH keys (parameterized placeholder)
  name                = var.key_vault_name
  resource_group_name = var.key_vault_resource_group
}

resource "azurerm_key_vault_secret" "vm1_ssh_private" {
  name         = "vm1-ssh-private"
  value        = tls_private_key.vm1.private_key_pem
  key_vault_id = data.azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "vm1_ssh_public" {
  name         = "vm1-ssh-public"
  value        = tls_private_key.vm1.public_key_openssh
  key_vault_id = data.azurerm_key_vault.main.id
}

# Use tls_private_key.vm1.public_key_openssh in your azurerm_linux_virtual_machine resource

resource "azurerm_linux_virtual_machine" "vm1" {
  name                = "vm1${var.application_name}${var.environment_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_B1ls"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.vm1.id,
  ]

  identity {
    type = "SystemAssigned"
  }

  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.vm1.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

/* "properties": {
                "publisher": "Microsoft.Azure.ActiveDirectory",
                "type": "AADSSHLoginForLinux",
                "typeHandlerVersion": "1.0",
                "autoUpgradeMinorVersion": true
            } */
resource "azurerm_virtual_machine_extension" "entra_id_login" {
  name                 = "${azurerm_linux_virtual_machine.vm1.name}-AADSSHLogin"
  virtual_machine_id   = azurerm_linux_virtual_machine.vm1.id
  publisher            = "Microsoft.Azure.ActiveDirectory"
  type                 = "AADSSHLoginForLinux"
  type_handler_version = "1.0"

  auto_upgrade_minor_version = true

  tags = {
    environment = "${var.environment_name}"
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "entra_id_login" {
  principal_id         = var.role_assignment_principal_object_id != "" ? var.role_assignment_principal_object_id : data.azurerm_client_config.current.object_id
  role_definition_name = "Virtual Machine User Login"
  scope                = azurerm_linux_virtual_machine.vm1.id
}
