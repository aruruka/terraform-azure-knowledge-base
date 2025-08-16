variable "remote_user_upns" {
  description = "List of user principal names (UPNs) for remote access users"
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.remote_user_upns) > 0
    error_message = "remote_user_upns must contain at least one UPN"
  }
}

variable "application_name" {
  description = "The name of the application to be deployed."
  type        = string
  nullable    = false
  validation {
    # condition     = trim(var.application_name) != ""
    condition     = trimspace(var.application_name) != ""
    error_message = "application_name must be a non-empty string."
  }
}
variable "environment_name" {
  description = "The name of the environment to be deployed."
  type        = string
  nullable    = false
}
variable "lab_name" {
  description = "The name of the lab"
  type        = string
}
variable "primary_location" {
  description = "The primary location for the resources."
  type        = string
  default     = "japaneast"
}
variable "subnet_name" {
  description = "Name of the subnet to attach the VM network interface to (placeholder)."
  type        = string
  default     = "snet-bravo"
}

variable "network_vnet_name" {
  description = "Virtual network name containing the target subnet (placeholder)."
  type        = string
  default     = "vnet-network-synth"
}

variable "network_resource_group" {
  description = "Resource group for the virtual network (placeholder)."
  type        = string
  default     = "rg-network-synth"
}

variable "key_vault_name" {
  description = "Key Vault name used for storing generated keys (placeholder)."
  type        = string
  default     = "kv-synthvault-xyz123"
}

variable "key_vault_resource_group" {
  description = "Resource group where the Key Vault exists (placeholder)."
  type        = string
  default     = "rg-synthvault"
}

variable "role_assignment_principal_object_id" {
  description = "Optional principal object id for role_assignment; leave empty to use current client."
  type        = string
  default     = ""
}
