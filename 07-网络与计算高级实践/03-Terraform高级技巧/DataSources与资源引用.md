# DataSources与资源引用

## 概述
DataSources允许引用Terraform外部或当前状态中的现有资源，实现配置复用。

## 核心概念
- **数据查询**：获取云平台现有资源信息
- **跨模块引用**：访问其他模块输出值
- **依赖管理**：隐式创建资源间依赖关系

## 基本用法
```hcl
data "azurerm_resource_group" "example" {
  name = "existing-rg"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-example"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
}
```

## 注意事项
- 数据源在apply阶段实时查询
- 引用不存在的资源会导致错误
- 敏感数据需特殊处理