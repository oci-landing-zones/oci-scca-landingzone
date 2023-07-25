variable "compartment_id" {
  description = "Compartment id where to create lb resources"
  type        = string
}

variable "load_balancer_display_name" {
  description = "(Updatable) Name of Load Balancer. Does not have to be unique."
  type        = string
  validation {
    condition     = length(var.load_balancer_display_name) > 0
    error_message = "The load_balancer_display_name value cannot be an empty string."
  }
}

variable "load_balancer_shape" {
  description = "Shape for Load Balancer"
  type        = string
  default     = "flexible"
}

variable "load_balancer_subnet_ids" {
  type        = list(string)
  description = "Subnet OCIDs for LB"
}

variable "load_balancer_ip_mode" {
  description = "IP mode (IPv4 or IPv6) for Load balancer"
  type        = string
  default     = "IPV4"
}

variable "load_balancer_is_private" {
  description = "Is LB private? (true/false)"
  type        = bool
  default     = true
}

variable "load_balancer_max_bw_mbps" {
  description = "Maximum bandwidth for flexible LB shape"
  type        = number
  default     = 30
}

variable "load_balancer_min_bw_mbps" {
  description = "Minimum bandwidth for flexible LB shape"
  type        = number
  default     = 10
}

variable "lb_add_waf" {
  description = "Add Web Application Firewall to LB?"
  type        = bool
  default     = false
}

variable "lb_add_waa" {
  description = "Add Web Application Accelerator to LB?"
  type        = bool
  default     = false
}
