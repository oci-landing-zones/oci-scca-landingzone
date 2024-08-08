# ###################################################################################################### #
# Copyright (c) 2023 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

variable "backup_bucket_name" {
  type        = string
  default     = "OCI-SCCA-LZ-IAC-Backup"
  description = ""
}

variable "central_vault_name" {
  type    = string
  default = "OCI-SCCA-LZ-Central-Vault"
  description = "Vault Name"
}

variable "central_vault_type" {
  type        = string
  default     = "DEFAULT"
  description = "Set value to DEFAULT for testing purpose. The default should be VIRTUAL_PRIVATE"
}

variable "enable_vault_replication" {
  type        = bool
  default     = false
  description = "Enable to replicate vault to secondary region. Can only be enabled when vault type is VIRTUAL_PRIVATE"
}

variable "master_encryption_key_name" {
  type    = string
  default = "OCI-SCCA-LZ-MSK"
}

// Cloud Guard Variable
variable "cloud_guard_target_tenancy" {
  type    = bool
  default = false
}

// variables to enable logging bucket
variable "retention_policy_duration_amount" {
  type    = string
  default = "1"
}

variable "retention_policy_duration_time_unit" {
  type    = string
  default = "DAYS"
}

variable "bucket_storage_tier" {
  type    = string
  default = "Archive"
}

// variables to use remote bucket

variable "remote_tenancy_ocid" {
  type    = string
  default = ""
}

variable "remote_tenancy_name" {
  type    = string
  default = ""
}

variable "remote_namespace" {
  type    = string
  default = ""
}

variable "remote_audit_log_bucket_name" {
  type    = string
  default = ""
}

variable "remote_default_log_bucket_name" {
  type    = string
  default = ""
}

variable "remote_service_event_bucket_name" {
  type    = string
  default = ""
}

variable "enable_bucket_replication" {
  type        = bool
  default     = false
  description = "Enable to replicate buckets to secondary region."
}

// Bastion Variables
variable "bastion_client_cidr_block_allow_list" {
  type    = list(string)
  default = []
}

