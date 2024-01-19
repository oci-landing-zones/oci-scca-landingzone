# ###################################################################################################### #
# Copyright (c) 2023 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

variable "compartment_id" {
  type        = string
  description = "The OCID of the compartment to contain the VCN."
}

variable "vcn_cidr_block" {
  type        = string
  description = "The CIDR block of VCN"
}

variable "vcn_display_name" {
  type        = string
  description = "The display name of VCN"
}

variable "vcn_dns_label" {
  type        = string
  description = "The DNS label of VCN"
}

variable "enable_ipv6" {
  type        = bool
  default     = false
  description = "Option to enable ipv6"
}

variable "subnet_map" {
  type = map(object({
    name                       = string,
    description                = string,
    dns_label                  = string,
    cidr_block                 = string,
    prohibit_public_ip_on_vnic = bool
  }))
  description = "The map of subnets including subnet name, description, dns label, subnet cidr block."
}

variable "lockdown_default_seclist" {
  type        = bool
  default     = true
  description = "Block all ingress and egress traffic on the default security list(attached to subnets that do not specify a security list) if enabled, else allow all traffic."
}
