# ###################################################################################################### #
# Copyright (c) 2023 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

variable "home_compartment_name" {
  type        = string
  description = "Name of the Landing Zone Home compartment."
  default     = "OCI-SCCA-LZ-Home"
  validation {
    condition     = can(regex("^([\\w\\.-]){1,100}$", var.home_compartment_name))
    error_message = "Allowed maximum 100 characters, including letters, numbers, periods, hyphens, underscores, and is unique within its parent compartment."
  }
}

variable "vdms_compartment_name" {
  type        = string
  description = "Name of the VDMS compartment."
  default     = "OCI-SCCA-LZ-VDMS"
  validation {
    condition     = can(regex("^([\\w\\.-]){1,100}$", var.vdms_compartment_name))
    error_message = "Allowed maximum 100 characters, including letters, numbers, periods, hyphens, underscores, and is unique within its parent compartment."
  }
}

variable "vdss_compartment_name" {
  type        = string
  description = "Name of the VDSS compartment."
  default     = "OCI-SCCA-LZ-VDSS"
  validation {
    condition     = can(regex("^([\\w\\.-]){1,100}$", var.vdss_compartment_name))
    error_message = "Allowed maximum 100 characters, including letters, numbers, periods, hyphens, underscores, and is unique within its parent compartment."
  }
}

variable "logging_compartment_name" {
  type        = string
  description = "Name of the Logging compartment."
  default     = "OCI-SCCA-LZ-Logging"
  validation {
    condition     = can(regex("^([\\w\\.-]){1,100}$", var.logging_compartment_name))
    error_message = "Allowed maximum 100 characters, including letters, numbers, periods, hyphens, underscores, and is unique within its parent compartment."
  }
}

variable "backup_compartment_name" {
  type        = string
  description = "Name of the Logging compartment."
  default     = "OCI-SCCA-LZ-IAC-TF-Configbackup"
  validation {
    condition     = can(regex("^([\\w\\.-]){1,100}$", var.backup_compartment_name))
    error_message = "Allowed maximum 100 characters, including letters, numbers, periods, hyphens, underscores, and is unique within its parent compartment."
  }
}

variable "resource_label" {
  type        = string
  description = "Resource label to append to resource names to prevent collisions."
  # @TODO add regex for 4 character max letter only string eg.prod/dev/staging
  #  validation {
  #   condition     = can(regex("^([\\w\\.-]){1,100}$", var.vdss_compartment_name))
  #   error_message = "Allowed maximum 100 characters, including letters, numbers, periods, hyphens, underscores, and is unique within its parent compartment."
  # } 
}

variable "enable_compartment_delete" {
  type        = bool
  description = "Set to true to allow the compartments to delete on terraform destroy."
  default     = true
}

variable "enable_logging_compartment" {
  type        = bool
  description = "Set to true to enable logging compartment, to false if you already had existing buckets in another tenancy"
  default     = true
}

variable "multi_region_home_compartment_ocid" {
  type        = string
  description = "OCID of the home compartment created in home region for multi-region deployment"
  default     = ""
}

variable "multi_region_logging_compartment_ocid" {
  type        = string
  description = "OCID of the workload compartment created in home region for multi-region deployment"
  default     = ""
}

variable "multi_region_vdss_compartment_ocid" {
  type        = string
  description = "OCID of the vdss compartment created in home region for multi-region deployment"
  default     = ""
}

variable "multi_region_vdms_compartment_ocid" {
  type        = string
  description = "OCID of the vdms compartment created in home region for multi-region deployment"
  default     = ""
}

variable "multi_region_workload_compartment_ocid" {
  type        = string
  description = "OCID of the workload compartment created in home region for multi-region deployment"
  default     = ""
}