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

resource "oci_identity_dynamic_group" "dynamic_group" {
  compartment_id = var.tenancy_ocid
  description    = var.dynamic_group_description
  matching_rule  = var.matching_rule
  name           = var.dynamic_group_name
}
