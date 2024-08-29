# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
  bucket_replication_policy = {
    name = "CHILD-SCCA-Bucket-Replication-Policy"
  }
}

resource "oci_objectstorage_bucket" "bucket_replica" {
  for_each = { for k, v in (var.service_connectors_configuration.buckets != null ? var.service_connectors_configuration.buckets : {}) : k => v if v.enable_replication == true }
  lifecycle {
    precondition {
      condition = coalesce(each.value.cis_level,"1") == "2" ? (each.value.kms_key_ocid != null ? true : false) : true # false triggers this.
      error_message = "VALIDATION FAILURE (CIS Storage 4.1.2): A customer managed key is required when CIS level is set to 2."
    }
  }
  provider       = oci.secondary_region
  compartment_id = each.value.compartment_id != null ? (length(regexall("^ocid1.*$", each.value.compartment_id)) > 0 ? each.value.compartment_id : var.compartments_dependency[each.value.compartment_id].id) : (length(regexall("^ocid1.*$", var.service_connectors_configuration.default_compartment_id)) > 0 ? var.service_connectors_configuration.default_compartment_id : var.compartments_dependency[var.service_connectors_configuration.default_compartment_id].id)
  name           = "${each.value.name}_replica"
  namespace      = data.oci_objectstorage_namespace.this[0].namespace
  kms_key_id     = ""
  defined_tags   = each.value.defined_tags != null ? each.value.defined_tags : var.service_connectors_configuration.default_defined_tags
  freeform_tags  = merge(local.cislz_module_tag, each.value.freeform_tags != null ? each.value.defined_tags : var.service_connectors_configuration.default_freeform_tags)
  storage_tier = each.value.storage_tier
}

resource "oci_objectstorage_replication_policy" "these" {
  for_each = { for k, v in (var.service_connectors_configuration.buckets != null ? var.service_connectors_configuration.buckets : {}) : k => v if v.enable_replication == true }

  bucket                  = oci_objectstorage_bucket.these[each.key].name
  destination_bucket_name = oci_objectstorage_bucket.bucket_replica[each.key].name
  destination_region_name = each.value.replica_region
  name                    = local.bucket_replication_policy.name
  namespace               = data.oci_objectstorage_namespace.this[0].namespace
}