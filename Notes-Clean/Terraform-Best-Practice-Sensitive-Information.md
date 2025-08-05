根据 Azure 官方文档和最佳实践，对于传递 `subscription_id` 和 `tenant_id` 有以下建议：

## 最佳实践

### 1. 使用环境变量（推荐）

**出于安全考虑，强烈建议使用环境变量而不是在配置文件中硬编码凭据。**

在 PowerShell 中设置环境变量：

```powershell
# 设置 Azure 环境变量
$env:ARM_SUBSCRIPTION_ID = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
$env:ARM_TENANT_ID = "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy"

# 验证环境变量
gci env:ARM_*
```

### 2. 修改你的 provider 配置

当使用环境变量时，可以简化你的 `azurerm` provider 配置：

````terraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  # subscription_id 和 tenant_id 将从环境变量自动读取
  # 移除硬编码的值以提高安全性
}
````

### 3. 支持的环境变量

`azurerm` provider 自动识别以下环境变量：

- `ARM_SUBSCRIPTION_ID` - Azure 订阅 ID
- `ARM_TENANT_ID` - Azure 租户 ID
- `ARM_CLIENT_ID` - 服务主体应用 ID（如果使用服务主体）
- `ARM_CLIENT_SECRET` - 服务主体密码（如果使用服务主体）

### 4. 为什么使用环境变量？

- **安全性**：避免在代码中暴露敏感信息
- **灵活性**：可以在不同环境中使用不同的订阅
- **版本控制友好**：避免意外提交凭据到代码仓库

### 5. 持久化环境变量（可选）

如果希望在每次 PowerShell 会话中都有这些变量，可以将它们添加到 PowerShell 配置文件中。

总结：使用环境变量是传递 Azure 凭据的最佳实践，既安全又灵活。
