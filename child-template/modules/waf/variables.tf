# ###################################################################################################### #
# Copyright (c) 2024 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

variable "waf_configuration" {
  description = "WAF configuration attributes."
  type = object({
    waf = map(object({
      backend_type                 = string
      compartment_id               = string
      load_balancer_id             = string
      display_name                 = optional(string)
      defined_tags                 = optional(map(string))
      freeform_tags                = optional(map(string))
      waf_action1_name             = string
      waf_action1_type             = string
      waf_action2_name             = string
      waf_action2_type             = string
      waf_body_actions_text        = string
      waf_body_action_type         = string
      waf_body_header_code         = string
      waf_body_actions_header      = string
      waf_body_actions_value       = string
      waf_body_actions_name        = string
      waf_body_actions_resp_type   = string
      waf_policy_display_name      = string
    }))
  })
}

variable "compartments_dependency" {
  description = "A map of objects containing the externally managed compartments this module may depend on. All map objects must have the same type and must contain at least an 'id' attribute (representing the compartment OCID) of string type."
  type        = map(any)
  default     = null
}