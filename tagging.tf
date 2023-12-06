# ###################################################################################################### #
# Copyright (c) 2023 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

locals {
  architecture_tag = {
    tag_namespace_description = "ArchitectureCenterTagNamespace"
    tag_namespace_name        = "ArchitectureCenter\\oracle-enterprise-landing-zone-SCCA-${random_id.tag.hex}"
    is_namespace_retired      = false
    tag_map = {
      architecture_tag = {
        description      = "ArchitectureCenterTag"
        name             = "release"
        validator_type   = "ENUM"
        validator_values = ["release", "1.0.0", "2.0.0"]
        is_cost_tracking = false
        is_retired       = false
      }
    }
    tag_default_map = {
      architecture_tag = {
        compartment_id      = var.home_region_deployment ? module.home_compartment[0].compartment_id : var.secondary_home_compartment_ocid
        tag_definition_name = "architecture_tag"
        value               = "2.0.0"
        is_required         = false
      }
    }
  }
}

resource "random_id" "tag" {
  byte_length = 2
}

module "architecture_tag" {
  source                    = "./modules/tag"
  count                     = var.home_region_deployment ? 1 : 0
  compartment_id            = var.tenancy_ocid
  tag_namespace_description = local.architecture_tag.tag_namespace_description
  tag_namespace_name        = local.architecture_tag.tag_namespace_name
  is_namespace_retired      = local.architecture_tag.is_namespace_retired
  tag_map                   = local.architecture_tag.tag_map
  tag_default_map           = local.architecture_tag.tag_default_map
}