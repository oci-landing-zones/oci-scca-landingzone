# ###################################################################################################### #
# Copyright (c) 2023 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}

# -----------------------------------------------------------------------------
# Create VCN
# -----------------------------------------------------------------------------
resource "oci_core_vcn" "vcn" {
  cidr_blocks    = [var.vcn_cidr_block]
  compartment_id = var.compartment_id
  display_name   = var.vcn_display_name
  dns_label      = var.vcn_dns_label
  is_ipv6enabled = var.enable_ipv6
}

# -----------------------------------------------------------------------------
# Create Subnets
# -----------------------------------------------------------------------------
resource "oci_core_subnet" "subnet" {
  for_each                   = var.subnet_map
  cidr_block                 = each.value.cidr_block
  display_name               = each.value.name
  dns_label                  = each.value.dns_label
  compartment_id             = var.compartment_id
  prohibit_public_ip_on_vnic = each.value.prohibit_public_ip_on_vnic
  vcn_id                     = oci_core_vcn.vcn.id
}

# -----------------------------------------------------------------------------
# Create Default Security List
# -----------------------------------------------------------------------------
resource "oci_core_default_security_list" "lockdown" {
  count                      = var.lockdown_default_seclist == true ? 1 : 0
  manage_default_resource_id = oci_core_vcn.vcn.default_security_list_id
}

resource "oci_core_default_security_list" "open" {
  count                      = var.lockdown_default_seclist == false ? 1 : 0
  manage_default_resource_id = oci_core_vcn.vcn.default_security_list_id

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "all"
    source   = "0.0.0.0/0"
  }
}
