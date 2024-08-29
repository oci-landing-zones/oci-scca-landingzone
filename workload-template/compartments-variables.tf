# ###################################################################################################### #
# Copyright (c) 2024 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

#--------------------------------------------------------------------------------------------#
# Workload Compartment variable
#--------------------------------------------------------------------------------------------#
variable "workload_compartment_name" {
  type        = string
  description = "the name of workload compartment"
  default     = "OCI-SCCA-LZ-WORKLOAD"
}

variable "scca_child_home_compartment_ocid" {
  type        = string
  description = "the ocid of SCCA home compartment"
  default     = ""
}

variable "enable_compartment_delete" {
  type        = bool
  default     = true
  description = "Set to true to allow the compartments to delete on terraform destroy"
  validation {
    condition     = can(regex("^([t][r][u][e]|[f][a][l][s][e])$", var.enable_compartment_delete))
    error_message = "The enable_compartment_delete boolean_variable must be either true or false."
  }
}

variable "resource_label" {
  type        = string
  description = "Resource label to append to resource names to prevent collisions."
  default     = "WRK"
  validation {
    condition     = length(var.resource_label) < 6
    error_message = "Resource Label Cannot Exceed Five Characters."
  }
  validation {
    condition     = can(regex("^[0-9A-Za-z]+$", var.resource_label))
    error_message = "Resource Label Can Have Only Alpha Numeric Charcter with no Special Character."
  }
}
