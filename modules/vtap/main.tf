terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}

# -----------------------------------------------------------------------------
# Create VTAP and Capture Filter Resources
# -----------------------------------------------------------------------------
resource "oci_core_vtap" "vtap" {
  capture_filter_id = oci_core_capture_filter.capture_filter.id
  compartment_id    = var.compartment_id
  source_type       = var.vtap_source_type
  source_id         = var.vtap_source_id
  vcn_id            = var.vcn_id
  display_name      = var.vtap_display_name
  is_vtap_enabled   = var.is_vtap_enabled
  target_type       = var.vtap_target_type
  target_id         = oci_network_load_balancer_network_load_balancer.vtap_nlb.id
}

locals {
  filter_rules_defaults = {
    "rule_action"      = null
    "source_cidr"      = null
    "destination_cidr" = null
    "protocol"         = null
    "icmp_options"     = {}
    "tcp_options"      = {}
    "udp_options"      = {}
  }

  filter_rules_normalized = {
    for k, v in var.vtap_capture_filter_rules :
    k => merge(local.filter_rules_defaults, v)
  }
}

resource "oci_core_capture_filter" "capture_filter" {
  compartment_id = var.compartment_id
  filter_type    = var.capture_filter_filter_type
  display_name   = var.capture_filter_display_name

  dynamic "vtap_capture_filter_rules" {
    for_each = local.filter_rules_normalized
    content {

      traffic_direction = vtap_capture_filter_rules.value.traffic_direction
      rule_action       = vtap_capture_filter_rules.value.rule_action
      source_cidr       = vtap_capture_filter_rules.value.source_cidr
      destination_cidr  = vtap_capture_filter_rules.value.destination_cidr
      protocol          = vtap_capture_filter_rules.value.protocol

      dynamic "icmp_options" {
        for_each = vtap_capture_filter_rules.value.icmp_options
        content {
          type = icmp_options.value.icmp_options_type
          code = icmp_options.value.icmp_options_typeicmp_options_code
        }
      }

      dynamic "tcp_options" {
        for_each = vtap_capture_filter_rules.value.tcp_options
        content {
          destination_port_range {
            max = tcp_options.value.tcp_options_destination_port_range_max
            min = tcp_options.value.tcp_options_destination_port_range_min
          }
          source_port_range {
            max = tcp_options.value.tcp_options_source_port_range_max
            min = tcp_options.value.tcp_options_source_port_range_min
          }
        }
      }

      dynamic "udp_options" {
        for_each = vtap_capture_filter_rules.value.udp_options
        content {
          destination_port_range {
            max = udp_options.value.udp_options_destination_port_range_max
            min = udp_options.value.udp_options_destination_port_range_min
          }
          source_port_range {
            max = udp_options.value.udp_options_source_port_range_max
            min = udp_options.value.udp_options_source_port_range_min
          }
        }
      }
    }
  }
}

# -----------------------------------------------------------------------------
# Create NLB Resouces
# -----------------------------------------------------------------------------
resource "oci_network_load_balancer_network_load_balancer" "vtap_nlb" {
  compartment_id = var.compartment_id
  display_name   = var.nlb_display_name
  subnet_id      = var.nlb_subnet_id
}

resource "oci_network_load_balancer_listener" "vtap_nlb_listener" {
  default_backend_set_name = oci_network_load_balancer_backend_set.vtap_nlb_backend_set.name
  name                     = var.nlb_listener_name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.vtap_nlb.id
  port                     = var.nlb_listener_port
  protocol                 = var.nlb_listener_protocol
}

resource "oci_network_load_balancer_backend_set" "vtap_nlb_backend_set" {
  # @TODO switch to backend_sets_unified to make it easier to add backends
  health_checker {
    protocol = var.nlb_backend_set_health_checker_protocol
  }

  name                     = var.nlb_backend_set_name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.vtap_nlb.id
  policy                   = var.nlb_backend_set_policy
}
