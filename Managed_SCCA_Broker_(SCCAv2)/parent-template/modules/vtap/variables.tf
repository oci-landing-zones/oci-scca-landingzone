# ###################################################################################################### #
# Copyright (c) 2024 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #


variable "vtap_configuration" {
  type = object({
    default_compartment_id = optional(string)
    capture_filters = optional(map(object({
      compartment_id            = optional(string)
      filter_type               = string
      display_name              = optional(string)
      vtap_capture_filter_rules = optional(map(object({
        traffic_direction = optional(string)
        rule_action       = optional(string)
        source_cidr       = optional(string)
        destination_cidr  = optional(string)
        protocol          = optional(string)
        icmp_options      = optional(map(object({
          type = optional(string)
          code = optional(string)
        })))
        tcp_options       = optional(map(object({
          destination_port_range_max = optional(number)
          destination_port_range_min = optional(number)
          source_port_range_max      = optional(number)
          source_port_range_min      = optional(number)
        })))
        udp_options       = optional(map(object({
          destination_port_range_max = optional(number)
          destination_port_range_min = optional(number)
          source_port_range_max      = optional(number)
          source_port_range_min      = optional(number)
        })))
      })))
    })))

    network_load_balancers = optional(map(object({
      compartment_id = optional(string)
      display_name   = string
      subnet_id      = string
    })))

    vtaps = optional(map(object({
      compartment_id    = optional(string)
      source_type       = optional(string)
      source_id         = string
      vcn_id            = string
      display_name      = optional(string)
      is_vtap_enabled   = optional(bool)
      target_type       = optional(string)
      target_id         = optional(string)
      capture_filter_id = string
    })))

    network_load_balancer_listeners = optional(map(object({
      default_backend_set_name = string
      listener_name            = string
      network_load_balancer_id = string
      port                     = number
      protocol                 = string
    })))

    network_load_balancer_backend_sets = optional(map(object({
      name                     = string
      network_load_balancer_id = string
      policy                   = string
      protocol                 = string
    })))
  })
}

variable network_dependency {
  description = "A map of objects containing the externally managed network resource this module may depend on. All map objects must have the same type and must contain at least an 'id' attribute (representing the VCN OCID) of string type."
  type = map(any)
  default = null
}