variable "tenancy_ocid" {
  type         = string
  description = "The OCID of tenancy"
}

variable "compartment_id" {
  type        = string
  description = "The OCID of compartment to create the log group"
}

variable "display_name" {
  type        = string
  description = "The display name of log group"
}

variable "description" {
  type        = string
  description = "The description of log group"
}

variable "namespace" {
  type        = string
  description = "The Logging Analytics namespace used for the request."
}