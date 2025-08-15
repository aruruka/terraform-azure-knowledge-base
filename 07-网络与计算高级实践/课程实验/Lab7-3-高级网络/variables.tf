variable "application_name" {
  description = "The name of the application to be deployed."
  type        = string
}
variable "environment_name" {
  description = "The name of the environment to be deployed."
  type        = string
}
variable "lab_name" {
  description = "The name of the lab"
  type        = string
}
variable "primary_location" {
  description = "The primary location for the resources."
  type        = string
  default     = "synthetic-location"
}
