```plaintext
keray@Ray-FB-T6ax MINGW64 /d/Work/Azure-Terraform-Windows (main)
$ az storage blob list --account-name syntheticaccount --container-name tfstate --output table --auth-mode login

You do not have the required permissions needed to perform this operation.
Depending on your operation, you may need to be assigned one of the following roles:
    "Storage Blob Data Owner"
    "Storage Blob Data Contributor"
    "Storage Blob Data Reader"
    "Storage Queue Data Contributor"
    "Storage Queue Data Reader"
    "Storage Table Data Contributor"
    "Storage Table Data Reader"

If you want to use the old authentication method and allow querying for the right account key, please use the "--auth-mode" parameter and "key" value.

(uv-project) 
keray@Ray-FB-T6ax MINGW64 /d/Work/Azure-Terraform-Windows (main)
$ az account show
{
  "environmentName": "AzureCloud",
  "homeTenantId": "synthetic-tenant-id",
  "id": "synthetic-subscription-id",
  "isDefault": true,
  "managedByTenants": [
    {
      "tenantId": "synthetic-managed-tenant-id"
    }
  ],
  "name": "Azure subscription 1",
  "state": "Enabled",
  "tenantId": "synthetic-tenant-id",
  "user": {
    "name": "synthetic-user@live.com",
    "type": "user"
  }
}
```

---

你之前提到了下面的信息: \
```plaintext
解决方法：
让管理员为你的账户分配 Storage Blob Data Reader 或更高权限到目标 Storage Account 或容器。
或者使用 --auth-mode key 并提供存储账户密钥（不推荐生产环境）。
```
关于第一种方案，是否可以通过命令行操作？还是说只能通过Azure Portal操作？

---
