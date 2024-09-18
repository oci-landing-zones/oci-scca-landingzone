# ###################################################################################################### #
# Copyright (c) 2024 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

variable "child_drg_id" {
  type        = string
  description = "DRG OCID of Child Template."
  validation {
    condition     = can(regex("^drg$", split(".", var.child_drg_id)[1]))
    error_message = "Only DRG OCID is allowed."
  }
}
variable "lb_subnet_cidr_block_child" {
  type        = string
  default     = "11.1.0.0/24"
  description = "Child Template: Load Balancer IP CIDR Block."
  validation {
    condition     = can(regex("^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", split("/", var.lb_subnet_cidr_block_child)[0]))
    error_message = "Incorrect IP Address."
  }
  validation {
    condition     = can(regex("^(?:[0-9]|[1-2][0-9]|3[0-2])$", split("/", var.lb_subnet_cidr_block_child)[1]))
    error_message = "Incorrect IP Address Network Mask."
  }
}
variable "fw_subnet_cidr_block_child" {
  type        = string
  default     = "11.2.0.0/24"
  description = "Child Template: Network Firewall IP CIDR Block."
  validation {
    condition     = can(regex("^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", split("/", var.fw_subnet_cidr_block_child)[0]))
    error_message = "Incorrect IP Address."
  }
  validation {
    condition     = can(regex("^(?:[0-9]|[1-2][0-9]|3[0-2])$", split("/", var.fw_subnet_cidr_block_child)[1]))
    error_message = "Incorrect IP Address Network Mask."
  }
}
variable "wrk_vcn_cidr_block" {
  type        = string
  default     = "13.0.0.0/16"
  description = "Workload VCN CIDR Block."
  validation {
    condition     = can(regex("^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", split("/", var.wrk_vcn_cidr_block)[0]))
    error_message = "Incorrect IP Address."
  }
  validation {
    condition     = can(regex("^(?:[0-9]|[1-2][0-9]|3[0-2])$", split("/", var.wrk_vcn_cidr_block)[1]))
    error_message = "Incorrect IP Address Network Mask."
  }
}
variable "wrk_vcn_dns_label" {
  type        = string
  default     = "wrkvcndns"
  description = "Workload VCN DNS Label"
}
variable "web_subnet_dns_label" {
  type        = string
  default     = "webdnslabel"
  description = "Workload Web Subnet DNS Label."
}
variable "web_subnet_cidr_block" {
  type        = string
  default     = "13.0.1.0/24"
  description = "Workload Web Subnet IP CIDR Block."
  validation {
    condition     = can(regex("^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", split("/", var.web_subnet_cidr_block)[0]))
    error_message = "Incorrect IP Address."
  }
  validation {
    condition     = can(regex("^(?:[0-9]|[1-2][0-9]|3[0-2])$", split("/", var.web_subnet_cidr_block)[1]))
    error_message = "Incorrect IP Address Network Mask."
  }
}
variable "web_subnet_name" {
  type        = string
  default     = "OCI-SCCA-LZ-WRK-Web-Subnet"
  description = "Workload DB Subnet Name."
}
variable "app_subnet_dns_label" {
  type        = string
  default     = "appdnslabel"
  description = "Workload App Subnet DNS Label."
}
variable "app_subnet_cidr_block" {
  type        = string
  default     = "13.0.2.0/24"
  description = "Workload App Subnet IP CIDR Block."
  validation {
    condition     = can(regex("^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", split("/", var.app_subnet_cidr_block)[0]))
    error_message = "Incorrect IP Address."
  }
  validation {
    condition     = can(regex("^(?:[0-9]|[1-2][0-9]|3[0-2])$", split("/", var.app_subnet_cidr_block)[1]))
    error_message = "Incorrect IP Address Network Mask."
  }
}
variable "app_subnet_name" {
  type        = string
  default     = "OCI-SCCA-LZ-WRK-App-Subnet"
  description = "Workload DB Subnet Name."
}
variable "db_subnet_dns_label" {
  type        = string
  default     = "dbdnslabel"
  description = "Workload DB Subnet DNS Label."
}
variable "db_subnet_cidr_block" {
  type        = string
  default     = "13.0.3.0/24"
  description = "Workload DB Subnet IP CIDR Block."
  validation {
    condition     = can(regex("^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", split("/", var.db_subnet_cidr_block)[0]))
    error_message = "Incorrect IP Address."
  }
  validation {
    condition     = can(regex("^(?:[0-9]|[1-2][0-9]|3[0-2])$", split("/", var.db_subnet_cidr_block)[1]))
    error_message = "Incorrect IP Address Network Mask."
  }
}
variable "db_subnet_name" {
  type        = string
  default     = "OCI-SCCA-LZ-WRK-DB-Subnet"
  description = "Workload DB Subnet Name."
}

variable "enable_workload_network_firewall" {
  type        = bool
  default     = false
  description = "Enable Network Firewall on Workload."
  validation {
    condition     = can(regex("^([t][r][u][e]|[f][a][l][s][e])$", var.enable_workload_network_firewall))
    error_message = "The enable_workload_network_firewall boolean variable must be either true or false."
  }
}

variable "enable_bastion_wrk" {
  type        = bool
  default     = false
  description = "Enable Bastion on Workload."
  validation {
    condition     = can(regex("^([t][r][u][e]|[f][a][l][s][e])$", var.enable_bastion_wrk))
    error_message = "The enable_bastion_wrk boolean_variable must be either true or false."
  }
}

variable "bastion_client_cidr_block_allow_list" {
  type        = list(string)
  description = "the client CIDR block allow list of bastion"
  default     = ["13.0.0.0/16"]
}

variable "bastion_display_name" {
  type        = string
  description = "the display name of bastion"
  default     = "OCI-SCCA-LZ-WRK-BASTION"
}