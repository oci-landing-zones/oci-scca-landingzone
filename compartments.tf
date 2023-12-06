# ###################################################################################################### #
# Copyright (c) 2023 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

locals {
  home_compartment = {
    name        = "${var.home_compartment_name}-${local.region_key[0]}-${var.resource_label}"
    description = "Landing Zone Home"
  }

  vdms_compartment = {
    name        = "${var.vdms_compartment_name}-${local.region_key[0]}-${var.resource_label}"
    description = "Virtual Datacenter Management Stack"
  }

  vdss_compartment = {
    name        = "${var.vdss_compartment_name}-${local.region_key[0]}-${var.resource_label}"
    description = "Virtual Datacenter Security Stack"
  }

  logging_compartment = {
    name        = "${var.logging_compartment_name}-${local.region_key[0]}-${var.resource_label}"
    description = "Logging Stack"
  }

  backup_compartment = {
    name        = "${var.backup_compartment_name}-${var.resource_label}"
    description = "Backup Stack"
  }
}

module "home_compartment" {
  source = "./modules/compartment"

  count                     = var.home_region_deployment ? 1 : 0
  compartment_parent_id     = var.tenancy_ocid
  compartment_name          = local.home_compartment.name
  compartment_description   = local.home_compartment.description
  enable_compartment_delete = var.enable_compartment_delete

  providers = {
    oci = oci.home_region
  }
}

module "vdms_compartment" {
  source = "./modules/compartment"

  count                     = var.home_region_deployment ? 1 : 0
  compartment_parent_id     = var.home_region_deployment ? module.home_compartment[0].compartment_id : var.secondary_home_compartment_ocid
  compartment_name          = local.vdms_compartment.name
  compartment_description   = local.vdms_compartment.description
  enable_compartment_delete = var.enable_compartment_delete

  providers = {
    oci = oci.home_region
  }
}

module "vdss_compartment" {
  source = "./modules/compartment"

  count                     = var.home_region_deployment ? 1 : 0
  compartment_parent_id     = var.home_region_deployment ? module.home_compartment[0].compartment_id : var.secondary_home_compartment_ocid
  compartment_name          = local.vdss_compartment.name
  compartment_description   = local.vdss_compartment.description
  enable_compartment_delete = var.enable_compartment_delete

  providers = {
    oci = oci.home_region
  }
}

module "logging_compartment" {
  source = "./modules/compartment"

  count                     = var.home_region_deployment && var.enable_logging_compartment ? 1 : 0
  compartment_parent_id     = var.home_region_deployment ? module.home_compartment[0].compartment_id : var.secondary_home_compartment_ocid
  compartment_name          = local.logging_compartment.name
  compartment_description   = local.logging_compartment.description
  enable_compartment_delete = var.enable_compartment_delete

  providers = {
    oci = oci.home_region
  }
}

module "backup_compartment" {
  source = "./modules/compartment"

  count                     = var.home_region_deployment ? 1 : 0
  compartment_parent_id     = var.home_region_deployment ? module.home_compartment[0].compartment_id : var.secondary_home_compartment_ocid
  compartment_name          = local.backup_compartment.name
  compartment_description   = local.backup_compartment.description
  enable_compartment_delete = var.enable_compartment_delete

  providers = {
    oci = oci.home_region
  }
}

resource "time_sleep" "compartment_replication_delay" {
  depends_on = [module.backup_compartment]

  create_duration = "90s"
}

