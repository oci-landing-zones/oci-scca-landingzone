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


variable "mission_owner_key" {
  type        = string
  description = ""
}

variable "workload_name" {
  type        = string
  description = "The name of workload stack"
}

variable "workload_vcn_cidr_block" {
  type    = string
  default = "192.168.2.0/24"
}

variable "workload_subnet_cidr_block" {
  type    = string
  default = "192.168.2.0/24"
}

variable "workload_db_vcn_cidr_block" {
  type    = string
  default = "192.168.3.0/24"
}

variable "workload_db_subnet_cidr_block" {
  type    = string
  default = "192.168.3.0/24"
}

variable "is_workload_vtap_enabled" {
  type    = bool
  default = false
}


variable "workload_2_name" {
  type        = string
  description = "The name of workload_2 stack"
}

variable "workload_2_vcn_cidr_block" {
  type    = string
  default = "192.168.2.0/24"
}

variable "workload_2_subnet_cidr_block" {
  type    = string
  default = "192.168.2.0/24"
}

variable "workload_2_db_vcn_cidr_block" {
  type    = string
  default = "192.168.3.0/24"
}

variable "workload_2_db_subnet_cidr_block" {
  type    = string
  default = "192.168.3.0/24"
}


variable "compartment_id" {
  # Added var to substitute dependancy
}