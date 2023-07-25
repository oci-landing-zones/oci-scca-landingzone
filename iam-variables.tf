variable "realm_key" {
  type        = string
  default     = "1"
  description = "1 for OC1 (commercial) and 3 for OC3 (Government)"
}

variable "enable_domain_replication" {
  type        = bool
  default     = false
  description = "Enable to replicate domain to secondary region."
}
