# SSH密钥管理与安全存储指南

## 概述
本指南介绍如何在Azure环境中安全生成、存储和使用SSH密钥，重点使用Azure Key Vault进行密钥管理。

## SSH密钥类型对比
| 算法 | 安全性 | 密钥长度 | 兼容性 | 推荐场景 |
|------|--------|----------|--------|----------|
| RSA  | ★★★★☆ | 4096位 | 广泛支持 | 传统系统兼容 |
| ECDSA | ★★★★★ | 521位 | 现代系统 | 安全优先场景 |
| Ed25519 | ★★★★★ | 256位 | 较新系统 | 高性能需求 |

## 密钥生成方法

### 1. 本地生成（推荐）
```bash:生成Ed25519密钥
ssh-keygen -t ed25519 -C "azure-user@example.com" -f ~/.ssh/azure-vm-key
```

### 2. Azure Cloud Shell生成
```bash
ssh-keygen -t rsa -b 4096
cat ~/.ssh/id_rsa.pub
```

## Azure Key Vault存储SSH密钥

### 1. 创建Key Vault
```hcl:keyvault.tf
resource "azurerm_key_vault" "ssh_keys" {
  name                        = "ssh-key-vault"
  location                    = azurerm_resource_group.main.location
  resource_group_name         = azurerm_resource_group.main.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "premium"
}
```

### 2. 存储公钥
```hcl
resource "azurerm_key_vault_secret" "vm_ssh_pub" {
  name         = "linux-vm-ssh-pub"
  value        = file("~/.ssh/azure-vm-key.pub")
  key_vault_id = azurerm_key_vault.ssh_keys.id
}
```

### 3. 安全访问私钥
```hcl:通过Key Vault引用
resource "azurerm_linux_virtual_machine" "secure_vm" {
  # ...其他配置...
  admin_ssh_key {
    username   = "azureuser"
    public_key = azurerm_key_vault_secret.vm_ssh_pub.value
  }
}
```

## 安全最佳实践
1. **密钥轮换策略**：每90天自动轮换密钥
   ```hcl:使用Azure策略
   resource "azurerm_policy_definition" "ssh_rotation" {
     name         = "ssh-key-rotation"
     policy_type  = "Custom"
     mode         = "Indexed"
     display_name = "Enforce SSH key rotation"
   }
   ```

2. **访问控制**：
   - 使用Azure RBAC限制Key Vault访问
   - 启用Key Vault防火墙

3. **审计监控**：
   ```hcl
   resource "azurerm_monitor_diagnostic_setting" "keyvault_audit" {
     name               = "keyvault-audit-logs"
     target_resource_id = azurerm_key_vault.ssh_keys.id
     log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
   }
   ```

4. **紧急访问**：配置Key Vault紧急访问账户

## 故障排除
**问题**：SSH连接失败 "Permission denied (publickey)"  
**解决步骤**：
1. 验证公钥是否在VM的`~/.ssh/authorized_keys`中
2. 检查文件权限：`chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys`
3. 确认Key Vault密钥版本是否最新