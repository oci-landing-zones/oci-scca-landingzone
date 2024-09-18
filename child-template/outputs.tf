# ###################################################################################################### #
# Copyright (c) 2024 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

output "scca_child_nfw_ip_ocid" {
  value = var.enable_network_firewall ? module.scca_networking_firewall[0].provisioned_networking_resources.oci_network_firewall_network_firewalls["CHILD-NFW-KEY"].ipv4address_ocid : null
}

output "scca_child_identity_domain_id" {
  value = module.scca_identity_domains[0].identity_domains["SCCA_CHILD_DOMAIN"].id
}

output "scca_child_home_compartment_ocid" {
  value = module.scca_compartments[0].compartments["SCCA_CHILD_HOME_CMP"].id
}

output "scca_child_vdms_compartment_ocid" {
  value = module.scca_compartments[0].compartments["SCCA_CHILD_VDMS_CMP"].id
}

output "scca_child_vdss_compartment_ocid" {
  value = module.scca_compartments[0].compartments["SCCA_CHILD_VDSS_CMP"].id
}

output "scca_child_logging_compartment_ocid" {
  value = var.enable_logging_compartment ? module.scca_compartments[0].compartments["SCCA_CHILD_LOGGING_CMP"].id : null
}

output "child_drg_id" {
  value = module.scca_networking.flat_map_of_provisioned_networking_resources["DRG-HUB"].id
}