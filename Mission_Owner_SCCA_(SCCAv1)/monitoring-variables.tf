# ###################################################################################################### #
# Copyright (c) 2023 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

variable "vdms_critical_topic_endpoints" {
  type        = list(string)
  default     = []
  description = "List of email addresses for VDMS Critical notifications."
  validation {
    condition = length(
      [for e in var.vdms_critical_topic_endpoints :
      e if length(regexall("^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", e)) > 0]
    ) == length(var.vdms_critical_topic_endpoints)
    error_message = "Validation failed vdms_critical_topic_endpoints: invalid email address."
  }
}

variable "vdms_warning_topic_endpoints" {
  type        = list(string)
  default     = []
  description = "List of email addresses for VDMS Warning notifications."
  validation {
    condition = length(
      [for e in var.vdms_warning_topic_endpoints :
      e if length(regexall("^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", e)) > 0]
    ) == length(var.vdms_warning_topic_endpoints)
    error_message = "Validation failed vdms_warning_topic_endpoints: invalid email address."
  }
}

variable "vdss_critical_topic_endpoints" {
  type        = list(string)
  default     = []
  description = "List of email addresses for VDSS Critical notifications."
  validation {
    condition = length(
      [for e in var.vdss_critical_topic_endpoints :
      e if length(regexall("^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", e)) > 0]
    ) == length(var.vdss_critical_topic_endpoints)
    error_message = "Validation failed vdss_critical_topic_endpoints: invalid email address."
  }
}

variable "vdss_warning_topic_endpoints" {
  type        = list(string)
  default     = []
  description = "List of email addresses for VDSS Warning notifications."
  validation {
    condition = length(
      [for e in var.vdss_warning_topic_endpoints :
      e if length(regexall("^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", e)) > 0]
    ) == length(var.vdss_warning_topic_endpoints)
    error_message = "Validation failed vdss_warning_topic_endpoints: invalid email address."
  }
}

variable "onboard_log_analytics" {
  type        = bool
  default     = true
  description = "Set to true ONLY if your tenancy has NOT been onboarded onto log analytics (fails otherwise). Verify by visiting log analytics in the console."
}

variable "enable_vdss_warning_alarm" {
  type        = bool
  default     = false
  description = "Enable warning alarms in VDSS compartment"
}

variable "enable_vdss_critical_alarm" {
  type        = bool
  default     = false
  description = "Enable critical alarms in VDSS compartment"
}

variable "enable_vdms_warning_alarm" {
  type        = bool
  default     = false
  description = "Enable warning alarms in VDMS compartment"
}

variable "enable_vdms_critical_alarm" {
  type        = bool
  default     = false
  description = "Enable critical alarms in VDMS compartment"
}
