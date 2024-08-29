/**
 * ## CIS Landing Zone Service Connector Hub (SCH) Module.
 *
 * This module manages OCI Service Connector Hub resources. 
 * Supported sources: "logging", "streaming".
 * Supported targets: "objectstorage", "streaming", "functions", "logginganalytics".
 * Object Storage buckets are optionally managed. They can be encrypted with either an Oracle managed key or customer managed key.
 * If cis_level = 1, the bucket is encrypted with an Oracle managed key.
 * If cis_level = 2, a customer managed key is required. Write logs are enabled for the bucket only if cis_level = 2.
 * If target.kind is 'streaming, a stream OCID must be provided in target.id parameter.
 * If target.kind is 'functions', a function OCID must be provided in target.id parameter.
 * If target.kind is 'logginganalytics', a log group OCID for Logging Analytics service must be provided in target.id parameter.
 * An IAM policy is created to allow the Service Connector Hub service to push data to the chosen target. 
 */

# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

#--------------------------------------------------
#--- SCH (Service Connector Hub) resource:
#--- 1. oci_sch_service_connector
#--------------------------------------------------
resource "oci_sch_service_connector" "these" {
  for_each = var.service_connectors_configuration.service_connectors
    lifecycle {
      precondition {
        condition = contains(local.sources,lower(each.value.source.kind))
        error_message = "VALIDATION FAILURE : \"${each.value.source.kind}\" value is invalid for \"source kind\" attribute in \"${each.key}\" service connector. Valid values are ${join(", ",local.sources)} (case insensitive)."
      }
      precondition {
        condition = contains(local.targets,lower(each.value.target.kind))
        error_message = "VALIDATION FAILURE : \"${each.value.target.kind}\" value is invalid for \"target kind\" attribute in \"${each.key}\" service connector. Valid values are ${join(", ",local.targets)} (case insensitive)."
      }
      precondition {
        condition = (lower(each.value.target.kind) == local.TARGET_OBJECT_STORAGE && each.value.target.bucket_name != null) || (lower(each.value.target.kind) == local.TARGET_STREAMING && each.value.target.stream_id != null) || (lower(each.value.target.kind) == local.TARGET_FUNCTIONS && each.value.target.function_id != null) || (lower(each.value.target.kind) == local.TARGET_LOGGING_ANALYTICS && each.value.target.log_group_id != null) || (lower(each.value.target.kind) == local.TARGET_NOTIFICATIONS && each.value.target.topic_id != null)
        error_message = "VALIDATION FAILURE : \"${each.value.target.kind}\" target kind requires a corresponding target resource in \"${each.key}\" service connector. Make sure to set target's attribute \"${local.target_resource_dependencies[each.value.target.kind]}\" with the target resource name (if target is a bucket) or id (if target is not a bucket)."
      }
    } 
    provider = oci
    compartment_id = each.value.compartment_id != null ? (length(regexall("^ocid1.*$", each.value.compartment_id)) > 0 ? each.value.compartment_id : var.compartments_dependency[each.value.compartment_id].id) : (length(regexall("^ocid1.*$", var.service_connectors_configuration.default_compartment_id)) > 0 ? var.service_connectors_configuration.default_compartment_id : var.compartments_dependency[var.service_connectors_configuration.default_compartment_id].id)
    display_name   = each.value.display_name 
    description    = each.value.description != null ? each.value.description : each.value.display_name
    defined_tags   = each.value.defined_tags != null ? each.value.defined_tags : var.service_connectors_configuration.default_defined_tags
    freeform_tags  = merge(local.cislz_module_tag, each.value.freeform_tags != null ? each.value.freeform_tags : var.service_connectors_configuration.default_freeform_tags)
    source {
      kind = lower(each.value.source.kind)
      dynamic "cursor" {
        for_each = lower(each.value.source.kind) == local.SOURCE_STREAMING ? each.value.source.cursor_kind != null ? [each.value.source.cursor_kind] : [] : []
        iterator = ls
        content {
          kind = upper(ls.value)
        }
      }
      dynamic "log_sources" {
      for_each = lower(each.value.source.kind) == local.SOURCE_LOGGING ? each.value.source.audit_logs != null ? toset(each.value.source.audit_logs) : [] : []
        iterator = ls
        content {
          compartment_id = upper(ls.value.cmp_id) == "ALL" ? var.tenancy_ocid : length(regexall("^ocid1.*$", ls.value.cmp_id)) > 0 ? ls.value.cmp_id : var.compartments_dependency[ls.value.cmp_id].id
          log_group_id = upper(ls.value.cmp_id) == "ALL" ? "_Audit_Include_Subcompartment" : "_Audit"
          log_id       = ""
        }
      }
      dynamic "log_sources" {
      for_each = lower(each.value.source.kind) == local.SOURCE_LOGGING ? each.value.source.non_audit_logs != null ? toset(each.value.source.non_audit_logs) : [] : []
        iterator = ls
        content {
          compartment_id = length(regexall("^ocid1.*$", ls.value.cmp_id)) > 0 ? ls.value.cmp_id : var.compartments_dependency[ls.value.cmp_id].id
          log_group_id   = ls.value.log_group_id != null ? (length(regexall("^ocid1.*$", ls.value.log_group_id)) > 0 ? ls.value.log_group_id : var.logs_dependency[ls.value.log_group_id].id) : ""
          log_id         = ls.value.log_id != null ? (length(regexall("^ocid1.*$", ls.value.log_id)) > 0 ? ls.value.log_id : var.logs_dependency[ls.value.log_id].id) : ""
        }
      }
      stream_id = lower(each.value.source.kind) == local.SOURCE_STREAMING ? (length(regexall("^ocid1.*$", each.value.source.stream_id)) > 0 ? each.value.source.stream_id : var.streams_dependency[each.value.source.stream_id].id) : null
    }
    target {
      kind               = lower(each.value.target.kind)
      compartment_id     = each.value.target.compartment_id != null ? (length(regexall("^ocid1.*$", each.value.target.compartment_id)) > 0 ? each.value.target.compartment_id : var.compartments_dependency[each.value.target.compartment_id].id) : each.value.compartment_id != null ? (length(regexall("^ocid1.*$", each.value.compartment_id)) > 0 ? each.value.compartment_id : var.compartments_dependency[each.value.compartment_id].id) : (length(regexall("^ocid1.*$", var.service_connectors_configuration.default_compartment_id)) > 0 ? var.service_connectors_configuration.default_compartment_id : var.compartments_dependency[var.service_connectors_configuration.default_compartment_id].id)
      bucket             = lower(each.value.target.kind) == local.TARGET_OBJECT_STORAGE ? (each.value.target.bucket_name != null ? (contains(keys(oci_objectstorage_bucket.these),each.value.target.bucket_name) ? oci_objectstorage_bucket.these[each.value.target.bucket_name].name : each.value.target.bucket_name) : null) : null
      object_name_prefix = lower(each.value.target.kind) == local.TARGET_OBJECT_STORAGE ? (each.value.target.bucket_object_name_prefix != null ? each.value.target.bucket_object_name_prefix : null) : null
      #namespace          = lower(each.value.target.kind) == local.TARGET_OBJECT_STORAGE ? (each.value.object_storage_target_details.bucket_namespace != null ? each.value.object_storage_target_details.bucket_namespace : data.oci_objectstorage_namespace.this.namespace) : null
      namespace          = lower(each.value.target.kind) == local.TARGET_OBJECT_STORAGE ? (each.value.target.bucket_namespace != null ? each.value.target.bucket_namespace : data.oci_objectstorage_namespace.this[0].namespace) : null
      batch_rollover_size_in_mbs = lower(each.value.target.kind) == local.TARGET_OBJECT_STORAGE ? coalesce(each.value.target.bucket_batch_rollover_size_in_mbs, 100) : null
      batch_rollover_time_in_ms  = lower(each.value.target.kind) == local.TARGET_OBJECT_STORAGE ? coalesce(each.value.target.bucket_batch_rollover_time_in_ms, 420000) : null
      stream_id          = lower(each.value.target.kind) == local.TARGET_STREAMING ? (each.value.target.stream_id != null ? (length(regexall("^ocid1.*$", each.value.target.stream_id)) > 0 ? each.value.target.stream_id : (contains(keys(oci_streaming_stream.these),each.value.target.stream_id) ? oci_streaming_stream.these[each.value.target.stream_id].id : var.streams_dependency[each.value.target.stream_id].id)) : null) : null
      topic_id           = lower(each.value.target.kind) == local.TARGET_NOTIFICATIONS ? (each.value.target.topic_id != null ? (length(regexall("^ocid1.*$", each.value.target.topic_id)) > 0 ? each.value.target.topic_id : (contains(keys(oci_ons_notification_topic.these),each.value.target.topic_id) ? oci_ons_notification_topic.these[each.value.target.topic_id].id : var.topics_dependency[each.value.target.topic_id].id)) : null) : null
      function_id        = lower(each.value.target.kind) == local.TARGET_FUNCTIONS ? (each.value.target.function_id != null ? (length(regexall("^ocid1.*$", each.value.target.function_id)) > 0 ? each.value.target.function_id : var.functions_dependency[each.value.target.function_id].id) : null) : null
      log_group_id       = lower(each.value.target.kind) == local.TARGET_LOGGING_ANALYTICS ? (each.value.target.log_group_id != null ? (length(regexall("^ocid1.*$", each.value.target.log_group_id)) > 0 ? each.value.target.log_group_id : var.logs_dependency[each.value.target.log_group_id].id) : null) : null   
    }

    dynamic "tasks" {
    for_each = lower(each.value.source.kind) == local.SOURCE_LOGGING ? each.value.log_rule_filter != null ? [each.value.log_rule_filter] : [] : []
      iterator = t
      content {
        kind = local.TASK_LOG_RULE
        condition = t.value
      }
    }
    state  = each.value.activate != null ? each.value.activate == true ? local.SCH_ACTIVE_STATE : local.SCH_INACTIVE_STATE : local.SCH_INACTIVE_STATE
}
