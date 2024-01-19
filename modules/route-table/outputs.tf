# ###################################################################################################### #
# Copyright (c) 2023 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

output "id" {
  value       = var.is_default == false ? oci_core_route_table.route_table[0].id : oci_core_default_route_table.defaultRouteTable[0].id
  description = "The OCID of the route table"
}
