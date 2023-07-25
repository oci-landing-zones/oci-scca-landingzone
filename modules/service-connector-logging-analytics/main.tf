terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}

resource "oci_sch_service_connector" "service_connector" {
  #Required
  compartment_id = var.compartment_id
  display_name   = var.display_name
  source {
    kind = var.source_kind
    log_sources {
      compartment_id = var.compartment_id
      log_group_id = var.source_log_group_id
    }
  }
  target {
    kind = var.target_kind
    log_group_id = var.target_log_group_id
  }

}