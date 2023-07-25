data "oci_core_services" "all_oci_services" {
  filter {
    name   = "name"
    values = ["All [A-Za-z0-9]+ Services In Oracle Services Network"]
    regex  = true
  }
}

data "oci_events_rules" "event_rules" {
  compartment_id = module.vdms_compartment.compartment_id
  depends_on = [
    module.vdms_critical_topic,
    module.vdms_warning_topic,
  ]
}

data "oci_log_analytics_namespaces" "logging_analytics_namespaces" {
  compartment_id = var.tenancy_ocid
}