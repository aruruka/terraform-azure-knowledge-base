# Azure网络安全组(NSG)配置指南

## NSG核心功能
- **流量过滤**：基于5元组的网络层访问控制
- **应用场景**：
  - 子网级保护
  - 虚拟机级精细控制

## 规则配置最佳实践
1. **优先级设计**
   - 从高优先级(100)开始向下配置
   - 间隔预留（如每次递减10）
2. **最小权限原则**
   - 仅开放必要端口
   - 限制源IP范围

## Terraform配置示例
```terraform
# 网络安全组基础配置
resource "azurerm_network_security_group" "web" {
  name                = "web-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}
```

## 注意事项
⚠️ 避免规则冲突：高优先级规则会覆盖低优先级规则  
✅ 定期审核规则：使用Azure策略自动检查NSG配置合规性