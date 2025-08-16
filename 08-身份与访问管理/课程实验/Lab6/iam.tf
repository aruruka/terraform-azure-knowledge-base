# Example: IAM resources for Lab6 (parameterized placeholders)
# This file is a sanitized example showing how to resolve UPNs and create an Azure AD group
# Replace TF var values with real UPNs / ids in your local copy.


data "azuread_client_config" "current" {}

locals {
  remote_user_map = { for u in var.remote_user_upns : lower(trimspace(u)) => lower(trimspace(u)) }
}

# Resolve each UPN to an azuread_user data source
data "azuread_user" "remote_access_users" {
  for_each            = local.remote_user_map
  user_principal_name = each.value
}

resource "azuread_group" "remote_access_users" {
  display_name     = "${var.application_name}-${var.environment_name}-remote-access-users"
  description      = "Group for remote access users in ${var.application_name} ${var.environment_name}"
  mail_nickname    = "${var.application_name}-${var.environment_name}-remote-access-users"
  security_enabled = true

  owners = [data.azuread_client_config.current.object_id]
}

resource "azuread_group_member" "remote_users" {
  for_each         = local.remote_user_map
  group_object_id  = azuread_group.remote_access_users.object_id
  member_object_id = data.azuread_user.remote_access_users[each.key].object_id
}

