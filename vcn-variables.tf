# ###################################################################################################### #
# Copyright (c) 2023 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

variable "vdss_vcn_cidr_block" {
  type    = string
  default = "192.168.0.0/24"
}

variable "vdms_vcn_cidr_block" {
  type    = string
  default = "192.168.1.0/24"
}

variable "firewall_subnet_cidr_block" {
  type    = string
  default = "192.168.0.0/25"
}

variable "is_vdms_vtap_enabled" {
  type    = bool
  default = false
}

variable "lb_subnet_cidr_block" {
  type    = string
  default = "192.168.0.128/25"
}

variable "vdms_subnet_cidr_block" {
  type    = string
  default = "192.168.1.0/24"
}

variable "is_vtap_enabled" {
  type    = bool
  default = true
}
