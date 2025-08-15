# Locals深入应用

## 概述
Locals是Terraform中定义局部变量的关键特性，用于简化复杂表达式并提高代码可读性。

## 核心概念
- **重用表达式**：避免在多个位置重复相同计算
- **模块化配置**：将相关变量组织在locals块中
- **条件逻辑**：结合条件表达式实现动态配置

## 应用场景
```hcl
locals {
  environment = terraform.workspace == "prod" ? "production" : "development"
  naming_prefix = "app-${local.environment}"
}
```

## 最佳实践
1. 避免过度复杂逻辑
2. 优先用于跨资源共享的值
3. 与输入变量配合使用