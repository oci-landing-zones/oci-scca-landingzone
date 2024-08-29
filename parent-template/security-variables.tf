# ###################################################################################################### #
# Copyright (c) 2024 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

##########################################################################
####                     Vault & Key Related Variables               #####
##########################################################################
variable "central_vault_name" {
  type        = string
  description = "the display name of vault"
  default     = "OCI-SCCA-LZ-PARENT-Central-Vault"
}

variable "master_encryption_key_name" {
  type        = string
  description = "the display name of key"
  default     = "OCI-SCCA-LZ-PARENT-MSK"
}

variable "central_vault_type" {
  type        = string
  description = "the type of the central vault: DEFAULT or VIRTUAL_PRIVATE"
  default     = "DEFAULT"
}

variable "enable_vault_replica" {
  type        = bool
  description = "Only support for VIRTUAL_PRIVATE vault type"
  default     = false
}


##########################################################################
####                     Cloud Guard Related Variables               #####
##########################################################################
variable "cloud_guard_name" {
  type        = string
  description = "the cloud guard name"
  default     = "OCI-SCCA-LZ-PARENT-CLOUD-GUARD"
}

variable "cloud_guard_target_name" {
  type        = string
  description = "the cloud guard target name"
  default     = "OCI-SCCA-LZ-PARENT-CLOUD-GUARD-TARGET"
}

variable "enable_cloud_guard" {
  type        = bool
  description = "the flag to enable cloud guard service"
  default     = false
}

##########################################################################
####                      VSS Related Variables                      #####
##########################################################################
variable "host_scan_recipe_display_name" {
  type        = string
  description = "Host Scan Recipe Display Name"
  default     = "OCI-SCCA-LZ-PARENT-HOST-SCAN-RECIPE"
}

variable "vss_target_display_name" {
  type        = string
  description = "VSS Target Recipe Name"
  default     = "OCI-SCCA-LZ-PARENT-VSS-Target"
}

variable "vss_policy_display_name" {
  type        = string
  description = "VSS Policy Name"
  default     = "OCI-SCCA-LZ-PARENT-VSS-Policy"
}

##########################################################################
####                      Bastion Related Variables                  #####
##########################################################################
variable "bastion_client_cidr_block_allow_list" {
  type        = list(string)
  description = "the client CIDR block allow list of bastion"
  default     = ["10.0.0.0/0"]
}
variable "bastion_display_name" {
  type        = string
  description = "the display name of bastion"
  default     = "OCI-SCCA-LZ-PARENT-BASTION"
}
variable "enable_bastion" {
  type        = bool
  description = "Set to true to enable bastion service, set to false to disable bastion"
  default     = false
  validation {
    condition     = can(regex("^([t][r][u][e]|[f][a][l][s][e])$", var.enable_bastion))
    error_message = "The enable_bastion boolean_variable must be either true or false."
  }
}