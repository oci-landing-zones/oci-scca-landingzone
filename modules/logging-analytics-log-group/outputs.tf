output "log_group_ocid" {
  value       = oci_log_analytics_log_analytics_log_group.log_analytics_log_group.id
  description = "The OCID of log group created"
}