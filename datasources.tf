# ###################################################################################################### #
# Copyright (c) 2023 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

data "oci_core_services" "all_oci_services" {
  filter {
    name   = "name"
    values = ["All [A-Za-z0-9]+ Services In Oracle Services Network"]
    regex  = true
  }
}

data "oci_events_rules" "event_rules" {
  compartment_id = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid
  display_name = "All events in ${var.vdms_compartment_name}-${local.region_key[0]}-${var.resource_label}"
  depends_on = [
    module.vdms_critical_topic,
    module.vdms_warning_topic,
  ]
}

data "oci_log_analytics_namespaces" "logging_analytics_namespaces" {
  compartment_id = var.tenancy_ocid
}