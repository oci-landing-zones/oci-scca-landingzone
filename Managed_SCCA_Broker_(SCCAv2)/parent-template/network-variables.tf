# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "vdss_vcn_cidr_block" {
  type        = string
  description = "CIDR block for the VDSS VCN"
  default     = "192.168.0.0/24"
}

variable "lb_subnet_cidr_block" {
  type        = string
  description = "CIDR block for the load balancer subnet"
  default     = "192.168.0.128/25"
}

variable "lb_subnet_name" {
  type        = string
  description = "Display name of the load balancer subnet"
  default     = "OCI-SCCA-LZ-LB-SUBNET"
}

variable "lb_dns_label" {
  type        = string
  description = "DNS label of the load balancer"
  default     = "lbsubnet"
}

variable "firewall_subnet_name" {
  type        = string
  description = "Display name of the firewall subnet"
  default     = "OCI-SCCA-LZ-FW-SUBNET"
}

variable "firewall_subnet_cidr_block" {
  type        = string
  description = "CIDR block for the firewall subnet"
  default     = "192.168.0.0/25"
}

variable "firewall_dns_label" {
  type        = string
  description = "DNS label of the firewall"
  default     = "firewallsubnet"
}

variable "workload_additionalsubnets_cidr_blocks" {
  type        = list(string)
  description = "A list of subnets cidr blocks in additional workload stack in prod"
  default     = []
}

variable "vdms_vcn_cidr_block" {
  type        = string
  description = "CIDR block of the VDMS VCN"
  default     = "192.168.1.0/24"
}

variable "vdms_subnet_cidr_block" {
  type        = string
  description = "CIDR block of the VDMS subnet"
  default     = "192.168.1.0/24"
}

variable "vdms_dns_label" {
  type        = string
  description = "DNS label of the VDMS subnet"
  default     = "vdmssubnet"
}

variable "enable_vtap" {
  type        = bool
  description = "Set to true to enable VTAP, set to false to disable VTAP"
  default     = true
  validation {
    condition     = can(regex("^([t][r][u][e]|[f][a][l][s][e])$", var.enable_vtap))
    error_message = "The enable_vtap boolean_variable must be either true or false."
  }
}

variable "enable_network_firewall" {
  type        = bool
  description = "Set to true to deploy the Network Firewall, set to false otherwise"
  default     = true
  validation {
    condition     = can(regex("^([t][r][u][e]|[f][a][l][s][e])$", var.enable_network_firewall))
    error_message = "The enable_network_firewall boolean_variable must be either true or false."
  }
}

variable "enable_waf" {
  type        = bool
  description = "Set to true to deploy and enable the WAF and WAA, set to false otherwise"
  default     = true
  validation {
    condition     = can(regex("^([t][r][u][e]|[f][a][l][s][e])$", var.enable_waf))
    error_message = "The enable_waf boolean_variable must be either true or false."
  }
}

variable "enable_service_deployment" {
  type        = bool
  description = "Enable NFW Route Rules on the VDSS VCN."
  default     = false
  validation {
    condition     = can(regex("^([t][r][u][e]|[f][a][l][s][e])$", var.enable_service_deployment))
    error_message = "The enable_service_deployment boolean_variable must be either true or false."
  }
}
variable "nfw_ip_ocid" {
  type        = string
  description = "NFW Forwarding IP OCID."
  default = ""
}
variable "child_vdss_vcn_cidr" {
  type        = string
  description = "CIDR block of the Child Template VDSS VCN."
  default     = "192.168.1.0/24"
}
variable "child_vdms_vcn_cidr" {
  type        = string
  description = "CIDR block of the Child Template VDMS VCN."
  default     = "192.168.1.0/24"
}