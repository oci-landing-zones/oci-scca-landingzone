##########################################################################################################
# Copyright (c) 2022,2023 Oracle and/or its affiliates, All rights reserved.                             #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
##########################################################################################################

terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}

resource "oci_identity_domains_dynamic_resource_group" "group" {

  display_name  = var.group_display_name
  idcs_endpoint = var.idcs_endpoint
  matching_rule = var.matching_rule
  schemas       = ["urn:ietf:params:scim:schemas:oracle:idcs:DynamicResourceGroup"]

  lifecycle {
    ignore_changes = [ idcs_endpoint
    ]
  }
}