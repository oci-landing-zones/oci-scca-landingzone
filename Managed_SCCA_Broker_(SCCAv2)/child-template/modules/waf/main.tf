# ###################################################################################################### #
# Copyright (c) 2024 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

resource "oci_waf_web_app_firewall_policy" "these" {
  for_each = var.waf_configuration != null ? (var.waf_configuration.waf != null ? var.waf_configuration.waf : {}) : {}
  actions {
    name = each.value.waf_action1_name
    type = each.value.waf_action1_type
  }
  actions {
    name = each.value.waf_action2_name
    type = each.value.waf_action2_type
  }
  actions {
    body {
      text = each.value.waf_body_actions_text
      type = each.value.waf_body_action_type
    }
    code = each.value.waf_body_header_code
    headers {
      name  = each.value.waf_body_actions_header
      value = each.value.waf_body_actions_value
    }
    name = each.value.waf_body_actions_name
    type = each.value.waf_body_actions_resp_type
  }
  compartment_id = each.value.compartment_id != null ? (length(regexall("^ocid1.*$", each.value.compartment_id)) > 0 ? each.value.compartment_id : var.compartments_dependency[each.value.compartment_id].id) : null
  display_name   = each.value.waf_policy_display_name
}


resource "oci_waf_web_app_firewall" "these" {
  for_each = var.waf_configuration != null ? (var.waf_configuration.waf != null ? var.waf_configuration.waf : {}) : {}
  backend_type     = upper(each.value.backend_type)

  compartment_id   = each.value.compartment_id != null ? (length(regexall("^ocid1.*$", each.value.compartment_id)) > 0 ? each.value.compartment_id : var.compartments_dependency[each.value.compartment_id].id) : null

  load_balancer_id = each.value.load_balancer_id

  web_app_firewall_policy_id = oci_waf_web_app_firewall_policy.these[each.key].id

  defined_tags  = each.value.defined_tags != null ? each.value.defined_tags : null

  display_name = each.value.display_name != null ? each.value.display_name : null

  freeform_tags = each.value.freeform_tags != null ? each.value.freeform_tags : null
}