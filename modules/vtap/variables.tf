# ###################################################################################################### #
# Copyright (c) 2023 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

variable "compartment_id" {
  type        = string
  description = "The OCID of the compartment containing the Vtap resource."
}

variable "vtap_source_type" {
  type        = string
  description = "Supported values are: VNIC,SUBNET,LOAD_BALANCER,DB_SYSTEM,EXADATA_VM_CLUSTER,AUTONOMOUS_DATA_WAREHOUSE."
}

variable "vtap_source_id" {
  type        = string
  description = "The OCID of the source point where packets are captured."
}

variable "vcn_id" {
  type        = string
  description = "The OCID of the VCN"
}

variable "vtap_display_name" {
  type        = string
  description = "The display name of the vtap"
}

variable "is_vtap_enabled" {
  type        = bool
  default     = false
  description = "Option to enbale vtap"
}

variable "vtap_target_type" {
  type        = string
  description = "Supported values are: VNIC,NETWORK_LOAD_BALANCER,IP_ADDRESS"
  default     = "NETWORK_LOAD_BALANCER"
}

variable "capture_filter_filter_type" {
  type        = string
  default     = "VTAP"
  description = "Indicates which service will use this capture filter"
}

variable "capture_filter_display_name" {
  type        = string
  description = "The display name of capture filter"
}

variable "vtap_capture_filter_rules" {
  type        = map(any)
  description = "The rules of vtap capture filter"
}

variable "nlb_display_name" {
  type        = string
  description = "The display name of network load balancer"
}

variable "nlb_subnet_id" {
  type        = string
  description = "The subnet OCID of network load balancer"
}

variable "nlb_listener_name" {
  type = string
  description = "The name of network load balancer listener"
}

variable "nlb_listener_port" {
  type        = string
  default     = "4789"
  description = "The port of network load balancer"
}

variable "nlb_listener_protocol" {
  type    = string
  default = "UDP"
  description = "The protocol of network load balancer listener"
}

variable "nlb_backend_set_health_checker_protocol" {
  type = string
  default = "TCP"
  description = "The backend set health checker protocol of network load balancer"
}

variable "nlb_backend_set_name" {
  type        = string
  description = "The name of network load balancer backend set"
}

variable "nlb_backend_set_policy" {
  type = string
  description = "Supported values are: FIVE_TUPLE,THREE_TUPLE,TWO_TUPLE"
  default = "FIVE_TUPLE"
}
