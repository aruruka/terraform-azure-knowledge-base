# CIDR表示法与IP地址管理

## CIDR基础
- **无类别域间路由(CIDR)**：IP地址分配标准
- 表示法：`IP地址/前缀长度`（如 `10.0.0.0/24`）

## Azure IP管理要点
1. **地址分配类型**
   - 动态 vs 静态分配
   - 公共 vs 私有IP
2. **保留地址策略**
   - 网关子网预留（Azure要求/27或更大）
   - 服务终结点预留

## Terraform实践
```terraform
# 子网CIDR配置示例
resource "azurerm_subnet" "frontend" {
  name                 = "frontend-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}
```

> 提示：使用IPAM工具跟踪地址使用情况