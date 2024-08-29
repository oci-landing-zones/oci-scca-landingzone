# ###################################################################################################### #
# Copyright (c) 2023 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

output "vtap_id" {
  value       = oci_core_vtap.vtap.id
  description = "The OCID of the vtap created"
}

output "nlb_id" {
  value       = oci_network_load_balancer_network_load_balancer.vtap_nlb.id
  description = "The OCID of the network load balancer"
}

output "nlb_backend_set_name" {
  value       = oci_network_load_balancer_backend_set.vtap_nlb_backend_set.name
  description = "The name of the network load balancer backend set"
}
