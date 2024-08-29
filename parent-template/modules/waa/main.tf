# ###################################################################################################### #
# Copyright (c) 2024 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

resource "oci_waa_web_app_acceleration_policy" "these" {
  for_each       = var.waa_configuration.web_app_accelerations != null ? var.waa_configuration.web_app_accelerations : {}
  compartment_id = each.value.compartment_id != null ? (length(regexall("^ocid1.*$", each.value.compartment_id)) > 0 ? each.value.compartment_id : var.compartments_dependency[each.value.compartment_id].id) : null
  response_caching_policy {
    is_response_header_based_caching_enabled = each.value.is_response_header_based_caching_enabled
  }
  response_compression_policy {
    gzip_compression {
      is_enabled = each.value.gzip_compression_is_enabled
    }
  }
}

resource "oci_waa_web_app_acceleration" "these" {
  for_each                       = var.waa_configuration.web_app_accelerations != null ? var.waa_configuration.web_app_accelerations : {}
  compartment_id                 = each.value.compartment_id != null ? (length(regexall("^ocid1.*$", each.value.compartment_id)) > 0 ? each.value.compartment_id : var.compartments_dependency[each.value.compartment_id].id) : null
  backend_type                   = each.value.backend_type
  load_balancer_id               = each.value.load_balancer_id
  web_app_acceleration_policy_id = oci_waa_web_app_acceleration_policy.these[each.key].id

  display_name = each.value.display_name != null ? each.value.display_name : "webappacceleration"
  depends_on   = [oci_waa_web_app_acceleration_policy.these]
}
