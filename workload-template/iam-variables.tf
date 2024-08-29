# ###################################################################################################### #
# Copyright (c) 2024 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

##############################################################################################
###############      WORKLOAD IDENTITY GROUP RELATED VARIABLES         #######################
##############################################################################################

variable "identity_domain_url" {
  default     = ""
  type        = string
  description = "the url of identity domain created in SCCA Landing Zone home stack"
}

variable "scca_child_identity_domain_id" {
  default     = ""
  type        = string
  description = "the OCID of identity domain created in SCCA Landing Zone home stack"
  validation {
    condition     = can(regex("^domain$", split(".", var.scca_child_identity_domain_id)[1]))
    error_message = "Only Identity Domain OCID is allowed."
  }
}

variable "scca_child_vdms_compartment_ocid" {
  type        = string
  description = "Child Template VDMS Compartment OCID value."
  validation {
    condition     = can(regex("^compartment$", split(".", var.scca_child_vdms_compartment_ocid)[1]))
    error_message = "Only Compartment OCID is allowed."
  }
}

variable "scca_child_vdss_compartment_ocid" {
  type        = string
  description = "Child Template VDSS Compartment OCID value."
  validation {
    condition     = can(regex("^compartment$", split(".", var.scca_child_vdss_compartment_ocid)[1]))
    error_message = "Only Compartment OCID is allowed."
  }
}