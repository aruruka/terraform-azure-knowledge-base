# Windows 环境安装指南

本指南将引导您在 Windows 操作系统上完成 Terraform 开发环境的搭建。

## 安装顺序

为了确保依赖关系正确，请遵循以下安装顺序：

1.  **安装 Chocolatey 包管理器**
2.  **安装 Visual Studio Code**
3.  **安装 Terraform**
4.  **安装 Azure CLI**
5.  **安装 Git**
6.  **配置 VS Code 扩展**
7.  **设置项目源代码文件夹**

---

## 1. 安装 Chocolatey

Chocolatey 是一个 Windows 的包管理器，可以极大地简化软件的安装和管理过程。

- **安装方法**:
  - 以管理员身份打开 PowerShell。
  - 执行官方网站提供的安装脚本。

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

---

## 2. 安装 Visual Studio Code

VS Code 是一个功能强大的、免费的代码编辑器，支持丰富的扩展生态。

- **安装方法**:
  - 使用 Chocolatey 安装：
    ```powershell
    choco install vscode -y
    ```

---

## 3. 安装 Terraform

Terraform 是核心的 IaC 工具。

- **安装方法**:
  - 使用 Chocolatey 安装：
    ```powershell
    choco install terraform -y
    ```

---

## 4. 安装 Azure CLI

Azure CLI 是用于管理 Azure 资源的命令行工具。

- **安装方法**:
  - 使用 Chocolatey 安装：
    ```powershell
    choco install azure-cli -y
    ```

---

## 5. 安装 Git

Git 是进行版本控制所必需的工具。

- **安装方法**:
  - 使用 Chocolatey 安装：
    ```powershell
    choco install git -y
    ```

---

## 6. 配置 VS Code 扩展

为了获得更好的 Terraform 开发体验，建议安装 HashiCorp 官方的 Terraform 扩展。

- **步骤**:
  1. 打开 VS Code。
  2. 进入扩展视图 (Ctrl+Shift+X)。
  3. 搜索 "HashiCorp Terraform"。
  4. 点击 "Install"。

---

## 7. 设置项目源代码文件夹

规范的文件夹结构有助于项目的管理。

- **建议**:
  - 在 `C:\` 盘根目录下创建一个名为 `source` 的文件夹。
  - 在 `source` 文件夹内，创建一个 `repos` 文件夹用于存放 Git 仓库。
  - 最终路径示例: `C:\source\repos\`