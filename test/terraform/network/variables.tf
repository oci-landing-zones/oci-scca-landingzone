/*
  VDSS
*/
variable "vdss_vcn_cidr_block" {
  type = string
}

variable "vdss_compartment_id" {
  type = string
}

variable "firewall_subnet_cidr_block" {
  type = string
}

variable "lb_subnet_cidr_block" {
  type = string
}

variable "region_key" {
  type = string
}

/*
  VDMS
*/
variable "vdms_vcn_cidr_block" {
  type = string
}

variable "vdms_compartment_id" {
  type = string
}

variable "vdms_subnet_cidr_block" {
  type = string
}
