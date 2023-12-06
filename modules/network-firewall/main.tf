# ###################################################################################################### #
# Copyright (c) 2023 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

# Reference
# https://github.com/oracle-quickstart/oci-network-firewall/tree/master/oci-network-firewall-reference-architecture
terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}

resource "time_sleep" "network_firewall_ip_delay" {
  depends_on      = [oci_network_firewall_network_firewall.network_firewall]
  create_duration = "90s"
}

resource "oci_network_firewall_network_firewall" "network_firewall" {
  compartment_id             = var.compartment_id
  network_firewall_policy_id = oci_network_firewall_network_firewall_policy.network_firewall_policy.id
  subnet_id                  = var.network_firewall_subnet_id
  display_name               = var.network_firewall_name
}

resource "oci_network_firewall_network_firewall_policy" "network_firewall_policy" {
  display_name   = var.network_firewall_policy_name
  compartment_id = var.compartment_id
}

resource "oci_network_firewall_network_firewall_policy_address_list" "network_firewall_policy_address_list" {
  for_each                   = var.ip_address_lists
  network_firewall_policy_id = var.network_firewall_policy_id
  type                       = var.network_firewall_policy_address_list_type
  name                       = each.key
  addresses                  = each.value
}

resource "oci_network_firewall_network_firewall_policy_security_rule" "network_firewall_policy_security_rule" {
  for_each = var.security_rules
  name     = each.key
  action   = each.value.security_rules_action
  condition {
    application         = each.value.security_rules_condition_application
    destination_address = each.value.security_rules_condition_destination_address
    source_address      = each.value.security_rules_condition_source_address
    service             = each.value.security_rules_condition_service
    url                 = each.value.security_rules_condition_url
  }
  network_firewall_policy_id = var.network_firewall_policy_id
}