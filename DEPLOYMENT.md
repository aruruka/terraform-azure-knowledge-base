# 项目部署和使用指南

## 📋 准备工作

### 1. 环境要求
- Windows 10/11
- PowerShell 5.1 或更高版本
- Azure CLI
- Terraform >= 1.0
- VS Code（推荐）

### 2. 安装依赖工具
```powershell
# 安装 Chocolatey（如果还没有安装）
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# 使用 Chocolatey 安装工具
choco install azure-cli
choco install terraform
choco install git
choco install vscode
```

## 🚀 项目设置

### 1. 克隆项目
```bash
git clone https://github.com/your-username/terraform-learning-project.git
cd terraform-learning-project
```

### 2. Azure 认证
```powershell
# 登录 Azure
az login

# 查看当前订阅信息
az account show

# 如需切换订阅
az account set --subscription "your-subscription-id"
```

### 3. 设置环境变量
```powershell
# 设置 Azure 环境变量（替换为你的真实值）
$env:ARM_SUBSCRIPTION_ID = "your-subscription-id"
$env:ARM_TENANT_ID = "your-tenant-id"

# 验证环境变量
gci env:ARM_*
```

### 4. 准备配置文件
```powershell
# 复制示例配置文件
Copy-Item "source-clean\repos\Terraform101\Lab1\terraform.tfvars.example" "source-clean\repos\Terraform101\Lab1\terraform.tfvars"
Copy-Item "source-clean\repos\Terraform101\Lab1\default.auto.tfvars.example" "source-clean\repos\Terraform101\Lab1\default.auto.tfvars"

# 编辑配置文件，填入你的实际值
code "source-clean\repos\Terraform101\Lab1\terraform.tfvars"
```

## 🧪 运行实验

### Lab1 - 基础资源创建
```powershell
cd source-clean\repos\Terraform101\Lab1

# 初始化 Terraform
terraform init

# 查看执行计划
terraform plan

# 应用配置
terraform apply

# 清理资源
terraform destroy
```

### Lab2 - Azure Provider 配置
```powershell
cd ..\Lab2

# 初始化 Terraform
terraform init

# 验证 Azure 连接
terraform console
# 在控制台中输入：data.azurerm_client_config.current

# 应用配置
terraform apply
```

## 📚 学习路径

1. **基础概念** - 阅读 `01-基本概念/` 目录
2. **环境设置** - 按照 `02-环境设置/` 指南操作
3. **实践练习** - 按顺序完成 Lab1, Lab2 等实验
4. **进阶主题** - 探索 `04-高级主题/` 内容
5. **最佳实践** - 学习 `05-最佳实践/` 建议

## 🔧 故障排除

### 常见问题

1. **认证失败**
   ```powershell
   # 重新登录 Azure
   az logout
   az login
   ```

2. **环境变量未生效**
   ```powershell
   # 重新设置环境变量
   $env:ARM_SUBSCRIPTION_ID = "your-subscription-id"
   $env:ARM_TENANT_ID = "your-tenant-id"
   
   # 验证设置
   gci env:ARM_*
   ```

3. **Terraform 初始化失败**
   ```powershell
   # 清理并重新初始化
   Remove-Item .terraform -Recurse -Force
   terraform init
   ```

## 📖 学习资源

- [Terraform 官方文档](https://www.terraform.io/docs)
- [Azure Provider 文档](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure CLI 参考](https://docs.microsoft.com/en-us/cli/azure/)

## 🤝 贡献指南

1. Fork 本项目
2. 创建功能分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add some amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 创建 Pull Request

**注意**: 提交前请确保没有包含任何敏感信息！
