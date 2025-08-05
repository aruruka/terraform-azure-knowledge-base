# 安全说明 - Security Notice

## 🔒 敏感信息处理说明

本仓库是一个Terraform学习项目，为了安全起见，所有敏感信息都已被清理或替换为示例数据。

### 已清理的敏感信息包括：

1. **Azure 凭据信息**
   - Subscription ID
   - Tenant ID  
   - Client ID
   - Object ID

2. **Terraform 状态文件**
   - `*.tfstate`
   - `*.tfstate.backup`
   - `.terraform/` 目录

3. **配置文件中的真实值**
   - `terraform.tfvars`
   - `*.auto.tfvars`

### 目录结构说明：

- `source-clean/` - 清理后的Terraform代码示例（安全的示例代码）
- `Notes-Clean/` - 清理后的学习笔记（已移除敏感信息）

### 使用说明：

1. **设置环境变量**（推荐方式）：
   ```powershell
   $env:ARM_SUBSCRIPTION_ID = "your-actual-subscription-id"
   $env:ARM_TENANT_ID = "your-actual-tenant-id"
   ```

2. **或者创建本地配置文件**：
   - 复制 `terraform.tfvars.example` 为 `terraform.tfvars`
   - 填入你的真实配置值
   - 确保 `terraform.tfvars` 在 `.gitignore` 中被排除

### ⚠️ 重要提醒：

- 绝对不要将真实的凭据信息提交到Git仓库
- 始终使用环境变量或本地配置文件来存储敏感信息
- 在生产环境中，建议使用Azure Key Vault或其他密钥管理服务

### 文件模板说明：

- `*.example` 文件 - 这些是模板文件，包含示例值
- 使用前请复制并重命名（去掉.example后缀），然后填入真实值

---

**学习目的**: 本项目旨在展示Terraform最佳实践，特别是如何安全地处理敏感信息。
