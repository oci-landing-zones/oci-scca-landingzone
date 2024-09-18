# ###################################################################################################### #
# Copyright (c) 2024 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

##############################################################################################
###############          WORKLOAD COMPARTMENT CONFIGURATION            #######################
##############################################################################################
locals {
  workload_compartment = {
    WKL-CMP : {
      name : "${var.workload_compartment_name}-${local.region_key[0]}-${var.resource_label}"
      description : "SCCA Workload Stack"
      defined_tags : null,
      freeform_tags : {
        "cislz-cmp-type" : "application"
      }
      children : {}
    }
  }

  workload_compartment_configuration = {
    default_parent_id = var.scca_child_home_compartment_ocid
    enable_delete     = var.enable_compartment_delete
    compartments : local.workload_compartment
  }

}

module "workload_compartment" {
  source                     = "github.com/oci-landing-zones/terraform-oci-modules-iam//compartments?ref=v0.2.3"
  tenancy_ocid               = var.tenancy_ocid
  compartments_configuration = local.workload_compartment_configuration
}
