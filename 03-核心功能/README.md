# 核心功能

本章深入探讨 Terraform 的核心功能，涵盖了从基本工作流到高级变量管理和模块化的所有内容。

---

## 1. Terraform 核心工作流

Terraform 的核心工作流是声明式基础设施管理的基础，主要包含三个命令：`init`, `plan`, 和 `apply`。

-   **`terraform init`**: 初始化工作目录。
    -   下载并安装在配置中指定的 Provider。
    -   初始化后端 (Backend) 用于状态管理。
    -   下载并安装模块。

-   **`terraform plan`**: 创建一个执行计划。
    -   读取当前状态和当前配置。
    -   比较两者差异，确定需要创建、更新或销毁哪些资源。
    -   生成一个详细的执行计划，但**不**做任何实际更改。

-   **`terraform apply`**: 应用执行计划。
    -   执行 `plan` 命令生成的计划。
    -   提示用户确认后，开始创建、更新或销毁云资源。
    -   `apply` 之后，状态文件 (`.tfstate`) 会被更新以反映新的基础设施状态。

-   **`terraform destroy`**: 销毁由 Terraform 管理的基础设施。

-   **`terraform console`**: 提供一个交互式控制台，用于测试和探索 Terraform 的函数和表达式。

---

## 2. HCL 基础语法

HashiCorp Configuration Language (HCL) 是 Terraform 配置文件的主要语言。

-   **资源 (Resource)**: 定义一个基础设施对象，如虚拟机或数据库。
    ```hcl
    resource "azurerm_resource_group" "rg" {
      name     = "my-resource-group"
      location = "East US"
    }
    ```

-   **引用 (Referencing)**: 使用 `resource_type.resource_name.attribute` 的语法来引用其他资源的属性。
    ```hcl
    resource "azurerm_virtual_network" "vnet" {
      name                = "my-vnet"
      resource_group_name = azurerm_resource_group.rg.name # 引用资源组的名称
      location            = azurerm_resource_group.rg.location
      # ...
    }
    ```

-   **字符串插值 (String Interpolation)**: 在字符串中嵌入表达式。
    ```hcl
    # 旧版语法 (Terraform 0.11 及更早版本)
    name = "vm-${var.environment}"

    # 现代语法 (Terraform 0.12 及更高版本)
    name = "vm-${var.environment}" # 语法相同，但功能更强大
    ```

-   **注释 (Comments)**:
    -   `#` 用于单行注释。
    -   `//` 也用于单行注释。
    -   `/* ... */` 用于多行注释。

---

## 3. 变量与输出 (Variables & Outputs)

### 3.1 输入变量 (Input Variables)

-   **声明**: 使用 `variable` 块来声明。
    ```hcl
    variable "image_sku" {
      type        = string
      description = "The SKU for the VM image."
      default     = "2019-Datacenter"
    }
    ```
-   **类型约束 (Types)**: `string`, `number`, `bool`, `list(...)`, `map(...)`, `set(...)`, `object(...)`, `tuple(...)`, `any`。
-   **验证 (Validation)**: 使用 `validation` 块来添加自定义验证规则。
    ```hcl
    variable "image_sku" {
      type    = string
      validation {
        condition     = length(var.image_sku) > 4
        error_message = "The image_sku must be at least 5 characters long."
      }
    }
    ```

### 3.2 变量赋值的优先级 (Precedence)

Terraform 按照以下顺序（从低到高）加载变量值，后面的会覆盖前面的：

1.  **`default` 值**: 在 `variable` 块中定义的默认值。
2.  **`terraform.tfvars.json` 文件**
3.  **`terraform.tfvars` 文件**
4.  **`*.auto.tfvars` 或 `*.auto.tfvars.json` 文件** (按字母顺序加载)
5.  **`-var` 和 `-var-file` 命令行参数** (可以多次使用，后面的覆盖前面的)
6.  **环境变量**: 格式为 `TF_VAR_<variable_name>`。

### 3.3 本地变量 (Local Variables)

-   使用 `locals` 块来定义，用于存储中间值或复杂的表达式，以避免重复。
    ```hcl
    locals {
      common_tags = {
        owner = "Team-A"
        service = "WebApp"
      }
    }
    ```

### 3.4 输出值 (Output Values)

-   使用 `output` 块来声明，用于从模块或根配置中导出值。
    ```hcl
    output "public_ip_address" {
      value       = azurerm_public_ip.pip.ip_address
      description = "The public IP address of the web server."
      sensitive   = true # 将此输出标记为敏感信息
    }
    ```

### 3.5 敏感数据 (Sensitive Data)

-   将变量或输出标记为 `sensitive = true` 可以防止其值在 `plan` 或 `apply` 的输出中显示。

---

## 4. 提供者与状态 (Providers & State)

### 4.1 提供者 (Providers)

-   定义与特定云平台或服务 API 交互的插件。
-   在 `terraform` 块中声明所需的提供者。
    ```hcl
    terraform {
      required_providers {
        azurerm = {
          source  = "hashicorp/azurerm"
          version = "~> 3.0"
        }
      }
    }
    ```

### 4.2 工作区 (Workspaces)

-   允许在同一套配置下管理多个独立的状态文件。
-   常用于区分不同的环境（如 `dev`, `staging`, `prod`）。
-   命令: `terraform workspace new <name>`, `terraform workspace select <name>`, `terraform workspace list`。

---

## 5. 循环与条件 (Loops & Conditionals)

-   **`count`**: 创建多个相似资源的实例。
    ```hcl
    resource "azurerm_public_ip" "pip" {
      count = 3 # 创建3个公共IP
      name  = "pip-${count.index}"
      # ...
    }
    ```

-   **`for_each`**: 基于 `map` 或 `set` 的键来创建资源，提供更灵活的实例管理。
    ```hcl
    resource "azurerm_resource_group" "rg" {
      for_each = toset(["dev", "staging", "prod"])
      name     = "rg-${each.key}"
      location = "East US"
    }
    ```

-   **条件表达式**: `condition ? true_val : false_val`
    ```hcl
    # 如果是生产环境，则创建2个实例，否则创建1个
    count = var.is_production ? 2 : 1
    ```

---

## 6. 模块 (Modules)

模块是可重用的 Terraform 配置单元。

-   **使用模块**: 从本地路径或远程源（如 Terraform Module Registry）引用模块。
    ```hcl
    module "virtual_network" {
      source              = "Azure/vnet/azurerm"
      version             = "2.5.0"
      resource_group_name = azurerm_resource_group.rg.name
      # ... 其他变量
    }
    ```

-   **创建模块**: 将一组相关的资源组织在一个独立的目录中。
    -   使用 `variable` 块定义输入。
    -   使用 `output` 块定义输出。
    -   模块应遵循**封装**原则，隐藏内部复杂性。

---

## 7. 学习与调试

-   **阅读官方文档 (RTFM)**: Terraform Registry 是查找 Provider 和模块文档的最佳来源。
-   **`terraform fmt`**: 格式化代码以保持一致的风格。
-   **`terraform validate`**: 检查语法是否正确。