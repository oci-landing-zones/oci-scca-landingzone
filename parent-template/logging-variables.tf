# ###################################################################################################### #
# Copyright (c) 2023 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

##########################################################################
####                  Log  Related Variables                         #####
##########################################################################

#Default Log Group
variable "default_log_group_name" {
  type        = string
  description = "the display name of Default Log Group"
  default     = "DEFAULT_PARENT_LOG_GROUP"
}
variable "default_log_group_desc" {
  type        = string
  description = "Default Log Group Description"
  default     = "DEFAULT_PARENT_LOG_GROUP_Description"
}

#Load Balancer Access Log
variable "lb_access_log_name" {
  type        = string
  description = "LB Access Log Name"
  default     = "OCI-SCCA-LZ-PARENT-LB-ACCESS-LOG"
}
variable "lb_access_log_type" {
  type        = string
  description = "LB Access Log Type"
  default     = "SERVICE"
}
variable "lb_access_log_category" {
  type        = string
  description = "LB Access Log Category"
  default     = "access"
}
variable "lb_access_log_resource_id" {
  type        = string
  description = "LB Access Log Rescource ID"
  default     = ""
}
variable "lb_access_log_service" {
  type        = string
  description = "LB Access Log Service"
  default     = "loadbalancer"
}

#Load Balancer Error Log
variable "lb_error_log_name" {
  type        = string
  description = "LB Error Log Name"
  default     = "OCI-SCCA-LZ-PARENT-LB-ERROR-LOG"
}
variable "lb_error_log_type" {
  type        = string
  description = "LB Error Log Type"
  default     = "SERVICE"
}
variable "lb_error_log_category" {
  type        = string
  description = "LB Error Log Category"
  default     = "error"
}
variable "lb_error_log_resource_id" {
  type        = string
  description = "LB Error Log Resource ID"
  default     = ""
}
variable "lb_error_log_service" {
  type        = string
  description = "LB Error Log Service Type"
  default     = "loadbalancer"
}

#OS Write Log
variable "os_write_log_name" {
  type        = string
  description = "OS Write Log Name"
  default     = "OCI-SCCA-LZ-PARENT-OS-WRITE-LOG"
}
variable "os_write_log_type" {
  type        = string
  description = "OS Write Log Type"
  default     = "SERVICE"
}
variable "os_write_log_category" {
  type        = string
  description = "OS Write Log Category"
  default     = "write"
}
variable "os_write_log_service" {
  type        = string
  description = "OS Write Log Service"
  default     = "objectstorage"
}

#OS Read Log
variable "os_read_log_name" {
  type        = string
  description = "OS Read Log"
  default     = "OCI-SCCA-LZ-PARENT-OS-READ-LOG"
}
variable "os_read_log_type" {
  type        = string
  description = "OS Read Log Type"
  default     = "SERVICE"
}
variable "os_read_log_category" {
  type        = string
  description = "OS Read Log Category"
  default     = "read"
}
variable "os_read_log_service" {
  type        = string
  description = "OS Read Log Service Type"
  default     = "objectstorage"
}

#VSS Log
variable "vss_log_name" {
  type        = string
  description = "VSS Log Name"
  default     = "OCI-SCCA-LZ-PARENT-VSS-LOG"
}
variable "vss_log_type" {
  type        = string
  description = "VSS Log Type"
  default     = "SERVICE"
}
variable "vss_log_category" {
  type        = string
  description = "VSS Log Category"
  default     = "all"
}
variable "vss_log_service" {
  type        = string
  description = "VSS Log Service Type"
  default     = "flowlogs"
}

#WAF Log
variable "waf_log_name" {
  type        = string
  description = "WAF Log Name"
  default     = "OCI-SCCA-LZ-PARENT-WAF-LOG"
}
variable "waf_log_type" {
  type        = string
  description = "WAF Log Type"
  default     = "SERVICE"
}
variable "waf_log_category" {
  type        = string
  description = "WAF Log Category"
  default     = "all"
}
variable "waf_log_service" {
  type        = string
  description = "WAF Log Service Type"
  default     = "waf"
}

#Event Log
variable "event_log_name" {
  type        = string
  description = "Event Log Name"
  default     = "OCI-SCCA-LZ-PARENT-EVENT-LOG"
}
variable "event_log_type" {
  type        = string
  description = "Event Log Type"
  default     = "SERVICE"
}
variable "event_log_category" {
  type        = string
  description = "Event Log Category"
  default     = "ruleexecutionlog"
}
variable "event_log_service" {
  type        = string
  description = "Event Log Service Type"
  default     = "cloudevents"
}

#Firewall Threat Log
variable "firewall_threat_log_name" {
  type        = string
  description = "Firewall Threat Log"
  default     = "OCI-SCCA-LZ-PARENT-NFW-THREAT-LOG"
}
variable "firewall_threat_log_type" {
  type        = string
  description = "Firewall Threat Log Type"
  default     = "SERVICE"
}
variable "firewall_threat_log_category" {
  type        = string
  description = "Firewall Threat Log Category"
  default     = "threatlog"
}
variable "firewall_threat_log_service" {
  type        = string
  description = "Firewall Threat Log Service Type"
  default     = "ocinetworkfirewall"
}

#Firewall Traffic Log
variable "firewall_traffic_log_name" {
  type        = string
  description = "Firewall Traffic Log"
  default     = "OCI-SCCA-LZ-PARENT-NFW-TRAFFIC-LOG"
}
variable "firewall_traffic_log_type" {
  type        = string
  description = "Firewall Traffic Log Type"
  default     = "SERVICE"
}
variable "firewall_traffic_log_category" {
  type        = string
  description = "Firewall Traffic Log Category"
  default     = "trafficlog"
}
variable "firewall_traffic_log_service" {
  type        = string
  description = "Firewall Traffic Log Service Type"
  default     = "ocinetworkfirewall"
}

##########################################################################
####                  Bucket  Related Variables                      #####
##########################################################################
variable "backup_bucket_name" {
  type        = string
  default     = "OCI-SCCA-LZ-PARENT-BACKUP"
  description = "Backup Bucket Name."
}

variable "retention_policy_duration_amount" {
  type        = string
  default     = "1"
  description = "Retention Policy Duration Amount."
}

variable "retention_policy_duration_time_unit" {
  type        = string
  default     = "DAYS"
  description = "Retention Policy Duration In Time Unit."
}

variable "bucket_storage_tier" {
  type        = string
  default     = "Archive"
  description = "Bucket Storage Tier."
}

variable "enable_bucket_replication" {
  type        = bool
  default     = false
  description = "Enable to replicate buckets to secondary region."
  validation {
    condition     = can(regex("^([t][r][u][e]|[f][a][l][s][e])$", var.enable_bucket_replication))
    error_message = "The enable_bucket_replication boolean_variable must be either true or false."
  }
}
variable "enable_vcn_flow_logs" {
  type        = bool
  default     = false
  description = "Enable VCN Flow Logs on the VDSS Compartment."
  validation {
    condition     = can(regex("^([t][r][u][e]|[f][a][l][s][e])$", var.enable_vcn_flow_logs))
    error_message = "The enable_vcn_flow_logs boolean_variable must be either true or false."
  }
}

variable "activate_service_connectors" {
  type        = bool
  default     = true
  description = "Activate Service Connector After Provisioning."
  validation {
    condition     = can(regex("^([t][r][u][e]|[f][a][l][s][e])$", var.activate_service_connectors))
    error_message = "The activate_service_connectors boolean_variable must be either true or false."
  }
}
