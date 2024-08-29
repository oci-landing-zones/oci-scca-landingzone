# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

#--------------------------------------------------
#--- SCH Object Storage bucket target resources:
#--- 1. oci_objectstorage_bucket
#--- 2. oci_logging_log_group
#--- 3. oci_logging_log
#--------------------------------------------------

data "oci_objectstorage_namespace" "this" {
  count = var.service_connectors_configuration.buckets != null ? 1 : 0
  provider = oci
  compartment_id = var.tenancy_ocid
}

resource "oci_objectstorage_bucket" "these" {
  for_each = var.service_connectors_configuration.buckets != null ? var.service_connectors_configuration.buckets : {}
    lifecycle {
      precondition {
        condition = coalesce(each.value.cis_level,"1") == "2" ? (each.value.kms_key_id != null ? true : false) : true # false triggers this.
        error_message = "VALIDATION FAILURE (CIS Storage 4.1.2): A customer managed key is required when CIS level is set to 2."
      }
      precondition {
        condition = contains(local.storage_tier_types, coalesce(each.value.storage_tier, "Standard"))
        error_message = "VALIDATION FAILURE : Invalid value for \"storage_tier\" attribute. Valid values are ${join(", ",local.storage_tier_types)} (case sensitive)."
      }
    }  
    provider       = oci
    compartment_id = each.value.compartment_id != null ? (length(regexall("^ocid1.*$", each.value.compartment_id)) > 0 ? each.value.compartment_id : var.compartments_dependency[each.value.compartment_id].id) : (length(regexall("^ocid1.*$", var.service_connectors_configuration.default_compartment_id)) > 0 ? var.service_connectors_configuration.default_compartment_id : var.compartments_dependency[var.service_connectors_configuration.default_compartment_id].id)
    name           = each.value.name
    namespace      = data.oci_objectstorage_namespace.this[0].namespace
    kms_key_id     = each.value.kms_key_id != null ? (length(regexall("^ocid1.*$", each.value.kms_key_id)) > 0 ? each.value.kms_key_id : var.kms_dependency[each.value.kms_key_id].id) : null
    versioning     = coalesce(each.value.cis_level,"1") == "2" ? "Enabled" : "Disabled"
    defined_tags   = each.value.defined_tags != null ? each.value.defined_tags : var.service_connectors_configuration.default_defined_tags
    freeform_tags  = merge(local.cislz_module_tag, each.value.freeform_tags != null ? each.value.defined_tags : var.service_connectors_configuration.default_freeform_tags)
    
    storage_tier = each.value.storage_tier
    dynamic retention_rules {
      for_each = coalesce(each.value.cis_level,"1") == "2" ? {} : ( each.value.retention_rules != null ? each.value.retention_rules : {} ) # cannot add retention rules to a bucket that has versioning enabled
      iterator = ls
      content {
        display_name = ls.value.display_name
        duration {
            time_amount = ls.value.time_amount
            time_unit = upper(ls.value.time_unit)
        }
      }
   }
}

/* locals {
  buckets_cis_level = [ for v in (var.service_connectors_configuration.buckets != null ? var.service_connectors_configuration.buckets : {}) : coalesce(v.cis_level,"1") == "2" ]
} */
#-- Log group for bucket write access logs
resource "oci_logging_log_group" "bucket" {
  #count = anytrue(local.buckets_cis_level) ? 1 : 0
  for_each = { for k, v in (var.service_connectors_configuration.buckets != null ? var.service_connectors_configuration.buckets : {}) : k => v if coalesce(v.cis_level,"1") == "2" }
    provider       = oci
    compartment_id = each.value.compartment_id != null ? (length(regexall("^ocid1.*$", each.value.compartment_id)) > 0 ? each.value.compartment_id : var.compartments_dependency[each.value.compartment_id].id) : (length(regexall("^ocid1.*$", var.service_connectors_configuration.default_compartment_id)) > 0 ? var.service_connectors_configuration.default_compartment_id : var.compartments_dependency[var.service_connectors_configuration.default_compartment_id].id)
    display_name   = "${each.value.name}-log-group"
    description    = "Service Connector bucket log group."
    defined_tags   = each.value.defined_tags != null ? each.value.defined_tags : var.service_connectors_configuration.default_defined_tags
    freeform_tags  = merge(local.cislz_module_tag, each.value.freeform_tags != null ? each.value.defined_tags : var.service_connectors_configuration.default_freeform_tags)
}

#-- Log for bucket write access logs
resource "oci_logging_log" "bucket" {
  for_each = { for k, v in (var.service_connectors_configuration.buckets != null ? var.service_connectors_configuration.buckets : {}) : k => v if coalesce(v.cis_level,"1") == "2" }
    provider     = oci
    display_name = "${each.value.name}-log"
    log_group_id = oci_logging_log_group.bucket[each.key].id
    log_type     = "SERVICE"
    
    configuration {
      source {
        category    = "write"
        resource    = oci_objectstorage_bucket.these[each.key].name
        service     = "objectstorage"
        source_type = "OCISERVICE"
      }
      compartment_id = each.value.compartment_id != null ? (length(regexall("^ocid1.*$", each.value.compartment_id)) > 0 ? each.value.compartment_id : var.compartments_dependency[each.value.compartment_id].id) : (length(regexall("^ocid1.*$", var.service_connectors_configuration.default_compartment_id)) > 0 ? var.service_connectors_configuration.default_compartment_id : var.compartments_dependency[var.service_connectors_configuration.default_compartment_id].id)
    }
    is_enabled         = true
    retention_duration = 30
    defined_tags       = each.value.defined_tags != null ? each.value.defined_tags : var.service_connectors_configuration.default_defined_tags
    freeform_tags      = merge(local.cislz_module_tag, each.value.freeform_tags != null ? each.value.defined_tags : var.service_connectors_configuration.default_freeform_tags)
}