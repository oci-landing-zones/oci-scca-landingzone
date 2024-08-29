# ###################################################################################################### #
# Copyright (c) 2023 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

output "domain" {
  value = oci_identity_domain.domain
}

output "url" {
  value = oci_identity_domain.domain.url
}

output "name" {
  value = oci_identity_domain.domain.display_name
}
