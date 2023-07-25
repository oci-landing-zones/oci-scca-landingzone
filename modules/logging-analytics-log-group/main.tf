terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}

resource "oci_log_analytics_log_analytics_log_group" "log_analytics_log_group" {
  compartment_id = var.compartment_id
  display_name   = var.display_name
  namespace      = var.namespace
  description    = var.description
}