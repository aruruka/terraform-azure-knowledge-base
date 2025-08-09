variable "application_name" {
  description = "The name of the application to be deployed."
  type        = string
  default     = "synthetic-app"
}
variable "environment_name" {
  description = "The name of the environment to be deployed."
  type        = string
  default     = "synthetic-env"
}
variable "lab_name" {
  description = "The name of the lab"
  type        = string
  default     = "synthetic-lab"
}
variable "primary_location" {
  description = "The primary location for the resources."
  type        = string
  default     = "synthetic-location"
}
