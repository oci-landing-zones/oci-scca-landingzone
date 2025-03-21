# ###################################################################################################### #
# Copyright (c) 2023 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

output "stream_id" {
  value       = oci_streaming_stream.stream.id
  description = "The OCID of the stream created"
}

output "event_rule_id" {
  value = oci_events_rule.rule.id
}