# ###################################################################################################### #
# Copyright (c) 2024 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

variable "region" {
  type        = string
  description = "the OCI home region"
}

variable "secondary_region" {
  type        = string
  description = "The secondary region used for replication and backup"
}

variable "tenancy_ocid" {
  type        = string
  description = "The OCID of tenancy"
}

variable "current_user_ocid" {
  type        = string
  description = "OCID of the current user"
}

variable "api_fingerprint" {
  type        = string
  description = "The fingerprint of API"
  default     = ""
}

variable "api_private_key_path" {
  type        = string
  description = "The local path to the API private key"
  default     = ""
}

variable "home_region_deployment" {
  type        = bool
  description = "Set to true if deploying in home region, set to false for Backup Region Deployment"
  default     = true
}

variable "compartments_dependency" {
  description = "A map of objects containing the externally managed compartments this module may depend on. All map objects must have the same type and must contain at least an 'id' attribute (representing the compartment OCID) of string type."
  type        = map(any)
  default     = null
}

variable "topics_dependency" {
  description = "A map of objects containing the externally managed topics this module may depend on. All map objects must have the same type and must contain at least an 'id' attribute (representing the topic OCID) of string type."
  type        = map(any)
  default     = null
}
variable "deployment_type" {
  type        = string
  description = "Deployment Type : Variable \"SINGLE\" for SCCAv1 or SCCAV1.2 Single Tenancy Deployment. Variable NULL \"\" Multi Tenancy Deployment"
  default     = ""
}