# ###################################################################################################### #
# Copyright (c) 2023 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

output "bastion_ocid" {
  value = module.bastion.bastion_ocid
}

output "policy_to_add" {
  value = <<EOT
  The remote buckets should be created in the same region as SCCA LZ created.
  Please also add below policy to the root level of the remote tenancy:
  define tenancy SCCA-LZ-Tenancy as ${var.remote_tenancy_ocid},
  admit any-user of tenancy SCCA-LZ-Tenancy to manage object-family in tenancy
  EOT
}
output "idcs_endpoint" {
  value = module.identity_domain[0].domain.url
}