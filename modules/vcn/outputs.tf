# ###################################################################################################### #
# Copyright (c) 2023 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

output "vcn_id" {
  value       = oci_core_vcn.vcn.id
  description = "The OCID of the VCN created"
}

output "vcn" {
  value = oci_core_vcn.vcn
}

output "subnets" {
  value = { for subnet in oci_core_subnet.subnet :
    subnet.display_name => subnet.id
  }
  description = "The subnet OCID"
}

