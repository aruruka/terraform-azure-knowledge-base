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
