# ###################################################################################################### #
# Copyright (c) 2023 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

variable "compartment_id" {
  type        = string
  description = "The OCID of the comparment to create the service connector in."
}

variable "display_name" {
  type        = string
  description = "The display name of service connector"
}

variable "source_kind" {
  type        = string
  description = "The source type discriminator."
}

variable "target_kind" {
  type        = string
  description = "The target type discriminator."
}

variable "source_log_group_id" {
  type        = string
  description = "The OCID of source log group"
}

variable "target_log_group_id" {
  type = string
  description = "The OCID of target log group"
}



