data "oci_core_services" "object_storage_services" {
  filter {
    name   = "name"
    values = ["OCI [A-Za-z0-9]+ Object Storage"]
    regex  = true
  }
}

data "oci_core_services" "all_oci_services" {
  filter {
    name   = "name"
    values = ["All [A-Za-z0-9]+ Services In Oracle Services Network"]
    regex  = true
  }
}
