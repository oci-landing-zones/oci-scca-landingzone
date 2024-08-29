# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

data "oci_objectstorage_namespace" "this" {
  count = var.oci_shared_config_bucket_name != null ? 1 : 0
    compartment_id = var.tenancy_ocid
}

data "oci_objectstorage_object" "compartments" {
  count = var.oci_shared_config_bucket_name != null && var.oci_compartments_object_name != null ? 1 : 0
    bucket    = var.oci_shared_config_bucket_name
    namespace = data.oci_objectstorage_namespace.this[0].namespace
    object    = var.oci_compartments_object_name
}

data "oci_objectstorage_object" "streams" {
  count = var.oci_shared_config_bucket_name != null && var.oci_streams_object_name != null ? 1 : 0
    bucket    = var.oci_shared_config_bucket_name
    namespace = data.oci_objectstorage_namespace.this[0].namespace
    object    = var.oci_streams_object_name
}

module "vision_connector" {
  source         = "../.."
  providers = {
    oci = oci
    oci.home = oci.home
  }
  tenancy_ocid     = var.tenancy_ocid
  service_connectors_configuration = var.service_connectors_configuration
  compartments_dependency = var.oci_compartments_object_name != null ? jsondecode(data.oci_objectstorage_object.compartments[0].content) : null
  streams_dependency = var.oci_streams_object_name != null ? jsondecode(data.oci_objectstorage_object.streams[0].content) : null
}
