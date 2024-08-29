# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "service_connectors" {
  description = "The service connectors."
  value       = var.enable_output ? oci_sch_service_connector.these : null
}

output "service_connector_policies" {
  description = "The service connector policies."
  value       = var.enable_output ? oci_identity_policy.these : null
}

output "service_connector_buckets" {
  description = "The service connector buckets."
  value       = var.enable_output ? oci_objectstorage_bucket.these : null
}

output "service_connector_streams" {
  description = "The service connector streams."
  value       = var.enable_output ? oci_streaming_stream.these : null
}

output "service_connector_topics" {
  description = "The service connector topics."
  value       = var.enable_output ? oci_ons_notification_topic.these : null
}