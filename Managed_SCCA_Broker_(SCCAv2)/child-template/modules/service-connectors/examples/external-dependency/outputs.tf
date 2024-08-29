# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "service_connectors" {
  description = "The service connectors."
  value       = module.vision_connector.service_connectors
}

output "service_connector_buckets" {
  description = "The service connector buckets."
  value       = module.vision_connector.service_connector_buckets
}

output "service_connector_policies" {
  description = "The service connector policies."
  value       = module.vision_connector.service_connector_policies
}