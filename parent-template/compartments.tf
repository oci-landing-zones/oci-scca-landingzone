# ###################################################################################################### #
# Copyright (c) 2024 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

locals {
  #--------------------------------------------------------------------------------------------#
  # Compartment input variables
  #--------------------------------------------------------------------------------------------#

  home_compartment = {
    name        = "${var.home_compartment_name}-${local.region_key[0]}-${var.resource_label}"
    description = "Landing Zone Home Compartment"
  }

  vdms_compartment = {
    name        = "${var.vdms_compartment_name}-${local.region_key[0]}-${var.resource_label}"
    description = "Virtual Datacenter Management and Security Stack"
  }

  vdss_compartment = {
    name        = "${var.vdss_compartment_name}-${local.region_key[0]}-${var.resource_label}"
    description = "Virtual Datacenter Network Stack"
  }

  backup_compartment = {
    name        = "${var.backup_compartment_name}-${local.region_key[0]}-${var.resource_label}"
    description = "Backup Stack"
  }

  logging_compartment = {
    name        = "${var.logging_compartment_name}-${local.region_key[0]}-${var.resource_label}"
    description = "Logging Stack"
  }
  #--------------------------------------------------------------------------------------------#
  # compartment key maps
  #--------------------------------------------------------------------------------------------#
  child_cmp = {
    SCCA_PARENT_VDMS_CMP : {
      name : local.vdms_compartment.name,
      description : local.vdms_compartment.description,
      defined_tags : null,
      freeform_tags : {
        "cislz-cmp-type" : "security"
      }
      children : {}
    }
    SCCA_PARENT_VDSS_CMP : {
      name : local.vdss_compartment.name,
      description : local.vdss_compartment.description,
      defined_tags : null,
      freeform_tags : {
        "cislz-cmp-type" : "network"
      }
      children : {}
    }
    SCCA_PARENT_BACKUP_CMP : {
      name : local.backup_compartment.name,
      description : local.backup_compartment.description,
      defined_tags : null,
      freeform_tags : {
        "cislz-cmp-type" : "backup"
      }
      children : {}
    }
  }
  logging_cmp = var.enable_logging_compartment ? {
    SCCA_PARENT_LOGGING_CMP : {
      name : local.logging_compartment.name,
      description : local.logging_compartment.description,
      defined_tags : null,
      freeform_tags : {
        "cislz-cmp-type" : "logging"
      }
      children : {}
    }
  } : {}

  home_cmp = {
    SCCA_PARENT_HOME_CMP : {
      name : local.home_compartment.name,
      description : local.home_compartment.description,
      defined_tags : null,
      freeform_tags : {
        "cislz-cmp-type" : "enclosing"
      }
      children : merge(local.child_cmp, local.logging_cmp)
    }
  }
  #--------------------------------------------------------------------------------------------#
  # Compartment configurations
  #--------------------------------------------------------------------------------------------#
  scca_compartments_configuration = {
    default_parent_id = var.tenancy_ocid
    enable_delete     = var.enable_compartment_delete
    compartments : local.home_cmp
  }
}

module "scca_compartments" {
  count  = var.home_region_deployment ? 1 : 0
  source = "github.com/oci-landing-zones/terraform-oci-modules-iam//compartments?ref=v0.2.3"

  tenancy_ocid               = var.tenancy_ocid
  compartments_configuration = local.scca_compartments_configuration
  providers                  = { oci = oci.home_region }
}

resource "time_sleep" "compartment_replication_delay" {
  depends_on      = [module.scca_compartments[0]]
  create_duration = "90s"
}
