# Azure虚拟网络(VNet)与子网规划

## 核心概念
- **虚拟网络(VNet)**：Azure资源的逻辑隔离边界
- **子网(Subnet)**：VNet内部的IP地址分段

## 规划原则
1. **地址空间设计**
   - 使用私有IP范围（RFC 1918）
   - 避免地址空间重叠
2. **子网划分策略**
   - 按功能划分（前端/后端/数据库）
   - 按安全要求划分（公开/私有）

## 最佳实践
```terraform
# Terraform VNet配置示例
resource "azurerm_virtual_network" "main" {
  name                = "prod-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}
```

> 注意：预留足够地址空间供未来扩展