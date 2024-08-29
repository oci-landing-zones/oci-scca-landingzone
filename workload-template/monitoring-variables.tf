# ###################################################################################################### #
# Copyright (c) 2024 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #


variable "workload_critical_topic_endpoints" {
  type        = list(string)
  default     = []
  description = "List of email addresses for Workload Critical notifications."
  validation {
    condition = length(
      [for e in var.workload_critical_topic_endpoints :
      e if length(regexall("^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", e)) > 0]
    ) == length(var.workload_critical_topic_endpoints)
    error_message = "Validation failed vdms_critical_topic_endpoints: invalid email address."
  }
}
variable "workload_warning_topic_endpoints" {
  type        = list(string)
  default     = []
  description = "List of email addresses for Workload Warning notifications."
  validation {
    condition = length(
      [for e in var.workload_warning_topic_endpoints :
      e if length(regexall("^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", e)) > 0]
    ) == length(var.workload_warning_topic_endpoints)
    error_message = "Validation failed vdms_warning_topic_endpoints: invalid email address."
  }
}

variable "enable_workload_critical_alarm" {
  type        = bool
  default     = false
  description = "Enable critical alarms in workload compartment"
  validation {
    condition     = can(regex("^([t][r][u][e]|[f][a][l][s][e])$", var.enable_workload_critical_alarm))
    error_message = "The enable_workload_critical_alarm boolean_variable must be either true or false."
  }
}

variable "enable_workload_warning_alarm" {
  type        = bool
  default     = false
  description = "Enable warning alarms in workload compartment"
  validation {
    condition     = can(regex("^([t][r][u][e]|[f][a][l][s][e])$", var.enable_workload_warning_alarm))
    error_message = "The enable_workload_warning_alarm boolean_variable must be either true or false."
  }
}