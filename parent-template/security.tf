# ###################################################################################################### #
# Copyright (c) 2024 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

locals {
  vaults_configuration = {
    default_compartment_id = null
    vaults = {
      CENTRAL-VAULT = {
        compartment_id = "SCCA_PARENT_VDMS_CMP"
        name           = "${var.central_vault_name}-${var.resource_label}"
        type           = var.central_vault_type
        replica_region = var.enable_vault_replica ? var.secondary_region : null
      }
    }
    keys = {
      MASTER-ENCRYPTION_KEY = {
        compartment_id = "SCCA_PARENT_VDMS_CMP"
        name           = "${var.master_encryption_key_name}-${var.resource_label}"
        vault_key      = "CENTRAL-VAULT"
      }
    }
  }

  cloud_guard_configuration = {
    tenancy_ocid     = var.tenancy_ocid
    display_name     = "${var.cloud_guard_name}-${var.resource_label}"
    enable           = true
    reporting_region = var.region

    targets = {
      CLOUD-GUARD-TARGET-1 = {
        name        = "${var.cloud_guard_target_name}-${var.resource_label}"
        resource_id = "SCCA_PARENT_HOME_CMP"
      }
    }
  }

  scanning_configuration = {
    default_compartment_id = null
    host_recipes = {
      HOST-RECIPE = {
        compartment_id  = module.scca_compartments[0].compartments["SCCA_PARENT_VDMS_CMP"].id
        name            = "${var.host_scan_recipe_display_name}-${var.resource_label}"
        port_scan_level = "STANDARD"
        schedule_setting = {
          type = "DAILY"
        }
        agent_settings = {
          scan_level               = "STANDARD"
          vendor                   = "OCI"
          cis_benchmark_scan_level = "STRICT"
        }
      }
    }

    host_targets = {
      HOST-TARGET = {
        compartment_id        = module.scca_compartments[0].compartments["SCCA_PARENT_VDMS_CMP"].id
        target_compartment_id = module.scca_compartments[0].compartments["SCCA_PARENT_VDMS_CMP"].id
        host_recipe_id        = "HOST-RECIPE"
        name                  = "${var.vss_target_display_name}-${var.resource_label}"
      }
    }
  }

  vss_policies_configuration = {
    supplied_policies : {
      VSS-POLICY : {
        name : "${var.vss_policy_display_name}-${var.resource_label}"
        description : "OCI SCCA Landing Zone PARENT VSS Policy"
        compartment_id : var.home_region_deployment ? "SCCA_PARENT_HOME_CMP" : var.multi_region_home_compartment_ocid
        statements : [
          "Allow service vulnerability-scanning-service to manage instances in compartment ${var.home_compartment_name}-${local.region_key[0]}-${var.resource_label}",
          "Allow service vulnerability-scanning-service to read compartments in compartment ${var.home_compartment_name}-${local.region_key[0]}-${var.resource_label}",
          "Allow service vulnerability-scanning-service to read vnics in compartment ${var.home_compartment_name}-${local.region_key[0]}-${var.resource_label}",
          "Allow service vulnerability-scanning-service to read vnic-attachments in compartment ${var.home_compartment_name}-${local.region_key[0]}-${var.resource_label}",
        ]
      }
    }
  }

  bastions_configuration = {
    bastions = {
      BASTION-1 = {
        compartment_id        = module.scca_compartments[0].compartments["SCCA_PARENT_VDMS_CMP"].id
        subnet_id             = "PARENT-VDMS-SUBNET"
        cidr_block_allow_list = var.bastion_client_cidr_block_allow_list
        name                  = "${var.bastion_display_name}-${var.resource_label}"
      }
    }
  }
}

module "central_vault_and_key" {
  source                  = "github.com/oci-landing-zones/terraform-oci-modules-security//vaults?ref=v0.1.7"
  vaults_configuration    = local.vaults_configuration
  enable_output           = true
  compartments_dependency = module.scca_compartments[0].compartments
  providers = {
    oci      = oci
    oci.home = oci.home
  }
}

module "cloud_guard" {
  count                     = var.enable_cloud_guard ? 1 : 0
  source                    = "github.com/oci-landing-zones/terraform-oci-modules-security//cloud-guard?ref=v0.1.7"
  cloud_guard_configuration = local.cloud_guard_configuration
  enable_output             = true
  tenancy_ocid              = var.tenancy_ocid
  compartments_dependency   = module.scca_compartments[0].compartments
}

# TODO: CIS Module needs to be updated
module "vss" {
  source                  = "github.com/oci-landing-zones/terraform-oci-modules-security//vss?ref=v0.1.7"
  scanning_configuration  = local.scanning_configuration
  enable_output           = true
  compartments_dependency = module.scca_compartments[0].compartments
}

module "vss_policy" {
  source                  = "github.com/oci-landing-zones/terraform-oci-modules-iam//policies?ref=v0.2.3"
  policies_configuration  = local.vss_policies_configuration
  tenancy_ocid            = var.tenancy_ocid
  compartments_dependency = module.scca_compartments[0].compartments
}

module "bastion" {
  count                   = var.enable_bastion ? 1 : 0
  source                  = "github.com/oci-landing-zones/terraform-oci-modules-security//bastion?ref=v0.1.7"
  bastions_configuration  = local.bastions_configuration
  enable_output           = true
  compartments_dependency = module.scca_compartments[0].compartments
  network_dependency      = module.scca_networking.provisioned_networking_resources
}

