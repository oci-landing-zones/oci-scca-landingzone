# ###################################################################################################### #
# Copyright (c) 2023 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

output "compartment_id" {
  value       = oci_identity_compartment.compartment.id
  description = "The OCID of the compartment created"
}

output "compartment_name" {
  value       = oci_identity_compartment.compartment.name
  description = "The name of the compartment created"
}
