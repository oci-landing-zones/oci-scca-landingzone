# ###################################################################################################### #
# Copyright (c) 2023 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

variable "realm_key" {
  type        = string
  default     = "3"
  description = "1 for OC1 (commercial) and 3 for OC3 (Government)"
}

variable "enable_domain_replication" {
  type        = bool
  default     = false
  description = "Enable to replicate domain to secondary region."
  validation {
    condition     = can(regex("^([t][r][u][e]|[f][a][l][s][e])$", var.enable_domain_replication))
    error_message = "The enable_domain_replication boolean_variable must be either true or false."
  }
}

variable "identity_domain_license_type" {
  type        = string
  default     = "premium"
  description = "The license type of the identity domain."
}

variable "parent_tenancy_ocid" {
  type        = string
  default     = ""
  description = "The tenancy OCID of parent template"
}