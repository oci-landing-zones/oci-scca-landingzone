variable "mission_owner_key" {
  type        = string
  description = ""
}

variable "workload_name" {
  type        = string
  description = "The name of workload stack"
}

variable "workload_vcn_cidr_block" {
  type    = string
  default = "192.168.2.0/24"
}

variable "workload_subnet_cidr_block" {
  type    = string
  default = "192.168.2.0/24"
}

variable "workload_db_vcn_cidr_block" {
  type    = string
  default = "192.168.3.0/24"
}

variable "workload_db_subnet_cidr_block" {
  type    = string
  default = "192.168.3.0/24"
}

variable "is_workload_vtap_enabled" {
  type    = bool
  default = false
}

variable "workload_critical_topic_endpoints" {
  type        = list(string)
  default     = []
  description = "List of email addresses for Workload Critical notifications."
  validation {
    condition = length(
      [for e in var.workload_critical_topic_endpoints :
      e if length(regexall("^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", e)) > 0]
    ) == length(var.workload_critical_topic_endpoints)
    error_message = "Validation failed workload_critical_topic_endpoints: invalid email address."
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
    error_message = "Validation failed workload_warning_topic_endpoints: invalid email address."
  }
}

variable "enable_workload_warning_alarm" {
  type        = bool
  default     = false
  description = "Enable warning alarms in Workload compartment"
}

variable "enable_workload_critical_alarm" {
  type        = bool
  default     = false
  description = "Enable critical alarms in Workload compartment"
}

variable "backup_vdms_compartment_ocid" {
  type        = string
  description = "OCID of the vdms compartment in the secondary region"
  default     = ""
}