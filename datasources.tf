data "oci_core_services" "all_oci_services" {
  filter {
    name   = "name"
    values = ["All [A-Za-z0-9]+ Services In Oracle Services Network"]
    regex  = true
  }
}

data "oci_events_rules" "event_rules" {
  compartment_id = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid
  depends_on = [
    module.vdms_critical_topic,
    module.vdms_warning_topic,
  ]
}

data "oci_log_analytics_namespaces" "logging_analytics_namespaces" {
  compartment_id = var.tenancy_ocid
}

data "oci_identity_compartments" "compartments" {
  compartment_id = var.secondary_home_compartment_ocid
}