# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "vdss_vcn_cidr_block" {
  type    = string
  default = "192.168.0.0/24"
}

variable "lb_subnet_cidr_block" {
  type    = string
  default = "192.168.0.128/25"
}

variable "lb_subnet_name" {
  type    = string
  default = "OCI-SCCA-CHILD-LZ-VDSS-LB-SUBNET"
}

variable "lb_dns_label" {
  type    = string
  default = "lbsubnet"
}

variable "firewall_subnet_name" {
  type    = string
  default = "OCI-SCCA-CHILD-LZ-VDSS-FW-SUBNET"
}

variable "firewall_subnet_cidr_block" {
  type    = string
  default = "192.168.0.0/25"
}

variable "firewall_dns_label" {
  type    = string
  default = "firewallsubnet"
}

variable "workload_additionalsubnets_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "A list of subnets cidr blocks in additional workload stack in prod"
}

variable "vdms_vcn_cidr_block" {
  type    = string
  default = "192.168.1.0/24"
}

variable "vdms_subnet_cidr_block" {
  type    = string
  default = "192.168.1.0/24"
}

variable "vdms_subnet_name" {
  type    = string
  default = "OCI-SCCA-CHILD-LZ-VDMS-LB-SUBNET"
}

variable "vdms_dns_label" {
  type    = string
  default = "vdmssubnet"
}

variable "enable_vtap" {
  type    = bool
  default = true
  validation {
    condition     = can(regex("^([t][r][u][e]|[f][a][l][s][e])$", var.enable_vtap))
    error_message = "The enable_vtap boolean_variable must be either true or false."
  }
}

variable "enable_network_firewall" {
  type    = bool
  default = true
  validation {
    condition     = can(regex("^([t][r][u][e]|[f][a][l][s][e])$", var.enable_network_firewall))
    error_message = "The enable_network_firewall boolean_variable must be either true or false."
  }
}

variable "nfw_ip_ocid" {
  type        = string
  default     = ""
  description = "OCID of the Network Firewall's Private IP"
}

variable "enable_waf" {
  type    = bool
  default = true
  validation {
    condition     = can(regex("^([t][r][u][e]|[f][a][l][s][e])$", var.enable_waf))
    error_message = "The enable_waf boolean_variable must be either true or false."
  }
}
variable "enable_service_deployment" {
  type    = bool
  default = false
  validation {
    condition     = can(regex("^([t][r][u][e]|[f][a][l][s][e])$", var.enable_service_deployment))
    error_message = "The enable_service_deployment boolean_variable must be either true or false."
  }
}

variable "rpc_acceptor_ocid" {
  default     = ""
  type        = string
  description = "The RPC acceptor ocid from parent template"
}

variable "parent_region_name" {
  default     = ""
  type        = string
  description = "Region name of the parent tenancy"
}

variable "parent_vdss_vcn_cidr" {
  type        = string
  description = "VDSS VCN CIDR block of the Parent tenancy"
  default     = ""
}

variable "parent_vdms_vcn_cidr" {
  type        = string
  description = "VDMS VCN CIDR block of the Parent tenancy"
  default     = ""
}