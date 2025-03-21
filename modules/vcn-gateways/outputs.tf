# ###################################################################################################### #
# Copyright (c) 2023 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

output "route_table_id" {
  value       = oci_core_route_table.route_table.id
  description = "The OCID of the route table"
}

output "sgw_id" {
  value       = oci_core_service_gateway.sgw.id
  description = "The OCID of the service gateway"
}
