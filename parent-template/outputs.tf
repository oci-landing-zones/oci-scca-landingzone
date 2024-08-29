# ###################################################################################################### #
# Copyright (c) 2024 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

output "scca_parent_nfw_ip_ocid" {
  value = var.enable_network_firewall ? module.scca_networking_firewall[0].provisioned_networking_resources.oci_network_firewall_network_firewalls["PARENT-NFW-KEY"].ipv4address_ocid : null
}

output "scca_parent_identity_domain_id" {
  value = module.scca_identity_domains[0].identity_domains["SCCA_PARENT_DOMAIN"].id
}

output "scca_parent_logging_compartment_ocid" {
  value = var.enable_logging_compartment ? module.scca_compartments[0].compartments["SCCA_PARENT_LOGGING_CMP"].id : null
}

output "parent_namespace" {
  value = data.oci_objectstorage_namespace.ns.namespace
}