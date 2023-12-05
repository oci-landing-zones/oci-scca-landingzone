variable "tenancy_ocid" {
  type        = string
  description = "The OCID of tenancy"
}

variable "compartment_id" {
  type        = string
  description = "The OCID of the root compartment."
}

variable "is_onboarded" {
  type        = bool
  description = "Use true if tenancy is to be onboarded to logging analytics and false if tenancy is to be offboarded."
}

variable "resource_label" {
  type = string
}

variable "home_region_deployment" {
  type        = bool
  description = "Set to true if deploying in home region, set to false or BackUp Region Deployment"
  default     = true
}
