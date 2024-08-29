# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "service_connectors" {
  description = "The service connectors."
  value       = module.target_stream_connector.service_connectors
}

output "service_connector_streams" {
  description = "The service connector streams."
  value       = module.target_stream_connector.service_connector_streams
}

output "service_connector_policies" {
  description = "The service connector policies."
  value       = module.target_stream_connector.service_connector_policies
}