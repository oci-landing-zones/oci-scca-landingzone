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
