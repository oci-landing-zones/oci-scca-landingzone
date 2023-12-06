# ###################################################################################################### #
# Copyright (c) 2023 Oracle and/or its affiliates, All rights reserved.                                  #
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