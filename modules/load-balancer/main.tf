# ###################################################################################################### #
# Copyright (c) 2023 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}

resource "oci_load_balancer_load_balancer" "load_balancer" {
  compartment_id = var.compartment_id
  display_name   = var.load_balancer_display_name
  shape          = var.load_balancer_shape
  subnet_ids     = var.load_balancer_subnet_ids

  ip_mode    = var.load_balancer_ip_mode
  is_private = var.load_balancer_is_private

  shape_details {
    maximum_bandwidth_in_mbps = var.load_balancer_max_bw_mbps
    minimum_bandwidth_in_mbps = var.load_balancer_min_bw_mbps
  }
}

resource "oci_waf_web_app_firewall_policy" "waf_policy" {
  count = var.lb_add_waf ? 1 : 0
  actions {
    name = "Pre-configured Check Action"
    type = "CHECK"
  }
  actions {
    name = "Pre-configured Allow Action"
    type = "ALLOW"
  }
  actions {
    body {
      text = "{\"code\":\"401\",\"message\":\"Unauthorized\"}"
      type = "STATIC_TEXT"
    }
    code = "401"
    headers {
      name  = "Content-Type"
      value = "application/json"
    }
    name = "Pre-configured 401 Response Code Action"
    type = "RETURN_HTTP_RESPONSE"
  }
  compartment_id = var.compartment_id
  display_name   = "webappfirewallpolicy"
}

resource "oci_waf_web_app_firewall" "waf" {
  count                      = var.lb_add_waf ? 1 : 0
  backend_type               = "LOAD_BALANCER"
  compartment_id             = var.compartment_id
  load_balancer_id           = oci_load_balancer_load_balancer.load_balancer.id
  web_app_firewall_policy_id = oci_waf_web_app_firewall_policy.waf_policy[count.index].id
  display_name               = "webappfirewall"
}

resource "oci_waa_web_app_acceleration_policy" "waa_policy" {
  count = var.lb_add_waa ? 1 : 0

  compartment_id = var.compartment_id
  display_name   = "webappaccelerationpolicy"

  response_caching_policy {
    is_response_header_based_caching_enabled = "true"
  }
  response_compression_policy {
    gzip_compression {
      is_enabled = "true"
    }
  }
}

resource "oci_waa_web_app_acceleration" "waa" {
  count = var.lb_add_waa ? 1 : 0

  backend_type   = "LOAD_BALANCER"
  compartment_id = var.compartment_id
  display_name   = "webappaccelerator"

  load_balancer_id               = oci_load_balancer_load_balancer.load_balancer.id
  web_app_acceleration_policy_id = oci_waa_web_app_acceleration_policy.waa_policy[count.index].id
}
