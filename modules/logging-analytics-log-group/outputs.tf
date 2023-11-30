# ###################################################################################################### #
# Copyright (c) 2023 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

output "log_group_ocid" {
  value       = oci_log_analytics_log_analytics_log_group.log_analytics_log_group.id
  description = "The OCID of log group created"
}