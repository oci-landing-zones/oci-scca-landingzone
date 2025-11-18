# ###################################################################################################### #
# Copyright (c) 2023 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

variable "tenancy_ocid" {
  type        = string
  description = "The OCID of tenancy"
}

variable "region" {
  type        = string
  description = "The reporting region value."
}

variable "status" {
  type        = string
  description = "Status of Cloud Guard Tenant"
}

variable "compartment_id" {
  type        = string
  description = "The OCID of the compartment in which to list resources."
}

variable "display_name" {
  type        = string
  description = "The display name of cloud guard target"
}

variable "target_resource_id" {
  type        = string
  description = "Resource ID which the target uses to monitor."
}

variable "target_resource_type" {
  type        = string
  description = "The type of targets."
}

variable "description" {
  type        = string
  description = "The target description."
}

variable "configuration_detector_recipe_display_name" {
  type        = string
  description = "The display name of configuration detector recipe."
}

variable "activity_detector_recipe_display_name" {
  type        = string
  description = "The display name of activity detector recipe."
}

variable "threat_detector_recipe_display_name" {
  type        = string
  description = "The display name of threat detector recipe."
}

#variable "responder_recipe_display_name" {
#  type        = string
#  description = "The display name of responder recipe."
#}

variable "target_description" {
  default = "Custom Target for High Security Zone Compartment"
}
variable "target_display_name" {
  default = "TF Demo Target"
}
variable "target_state" {
  default = "ACTIVE"
}
variable "target_target_resource_type" {
  default = "COMPARTMENT"
}
variable "target_target_detector_recipes_detector_rules_details_condition_groups_condition" {
  default = "{\"kind\":\"SIMPLE\",\"parameter\":\"lbCertificateExpiringSoonFilter\",\"operator\":\"EQUALS\",\"value\":\"20\",\"valueType\":\"CUSTOM\"}"
}
variable "target_target_responder_recipes_responder_rules_details_mode" {
  default = "USERACTION"
}
variable "detector_recipe_description" {
  default = "Custom Detector Recipe"
}
variable "detector_recipe_display_name" {
  default = "TF Demo Detector Recipe"
}
variable "detector_recipe_detector_rules_details_risk_level" {
  default = "HIGH"
}
variable "detector_recipe_detector_rules_details_condition" {
  default = "{\"kind\":\"SIMPLE\",\"parameter\":\"lbCertificateExpiringSoonFilter\",\"operator\":\"EQUALS\",\"value\":\"10\",\"valueType\":\"CUSTOM\"}"
}
variable "detector_recipe_detector_rules_details_configurations_config_key" {
  default = "lbCertificateExpiringSoonConfig"
}
variable "detector_recipe_detector_rules_details_configurations_data_type" {
  default = "int"
}
variable "detector_recipe_detector_rules_details_configurations_name" {
  default = "Days before expiring"
}
variable "detector_recipe_detector_rules_details_configurations_value" {
  default = "30"
}
variable "detector_recipe_detector_rules_details_is_enabled" {
  default = true
}
variable "detector_recipe_detector_rules_details_labels" {
  default = ["hsz-lb-certs"]
}
variable "detector_recipe_state" {
  default = "ACTIVE"
}
variable "responder_recipe_description" {
  default = "Custom Responder Recipe"
}
variable "responder_recipe_display_name" {
  default = "TF Demo Responder Recipe"
}
variable "responder_recipe_responder_rules_details_is_enabled" {
  default = false
}
variable "responder_recipe_state" {
  default = "ACTIVE"
}

variable "managed_list_description" {
  default = "Bucket Resource Ocids in a High Security Zone which absolutely should not be public"
}
variable "managed_list_display_name" {
  default = "Bucket OCIDS in High Security Zone"
}
variable "managed_list_list_items" {
  default = ["namespace/test1", "namespace/test2", "namespace/test3"]
}
variable "managed_list_list_type" {
  default = "RESOURCE_OCID"
}
variable "managed_list_state" {
  default = "ACTIVE"
}

