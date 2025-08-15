# Linux虚拟机部署指南

## 概述
本指南介绍使用Terraform在Azure上部署Linux虚拟机的完整流程，包括资源配置、网络连接和安全设置。

## 前置条件
- Azure订阅权限
- 已安装并配置[Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- 已配置[Azure认证](03-核心功能/Configure-Azure-Terraform-Provider.md)

## 部署步骤

### 1. 定义虚拟机资源
```hcl:main.tf
resource "azurerm_linux_virtual_machine" "vm_example" {
  name                = "linux-vm"
  resource_group_name = azurerm_resource_group.example.name
  location            = "eastus"
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  network_interface_ids = [azurerm_network_interface.example.id]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
```

### 2. 配置网络接口
```hcl:network.tf
resource "azurerm_network_interface" "example" {
  name                = "vm-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}
```

### 3. 应用配置
```bash
terraform init
terraform plan -out=vm.tfplan
terraform apply vm.tfplan
```

## 验证部署
1. 在Azure门户检查虚拟机状态
2. 使用SSH连接测试：
   ```bash
   ssh azureuser@<public-ip-address>
   ```

## 最佳实践
- 使用[自定义映像](https://learn.microsoft.com/zh-cn/azure/virtual-machines/linux/tutorial-custom-images)加速部署
- 启用[启动诊断](https://learn.microsoft.com/zh-cn/azure/virtual-machines/linux/boot-diagnostics)排查问题
- 配置[自动缩放](https://learn.microsoft.com/zh-cn/azure/virtual-machine-scale-sets/quick-create-template-linux)