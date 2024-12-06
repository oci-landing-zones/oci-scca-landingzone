# ###################################################################################################### #
# Copyright (c) 2024 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

data "oci_identity_domain" "scca_identity_domain" {
  domain_id = var.scca_child_identity_domain_id
}

data "oci_identity_compartments" "scca_compartments" {
  compartment_id = var.scca_child_home_compartment_ocid
}

locals {
  ##############################################################################################
  #############         WORKLOAD IDENTITY DOMAIN CONFIGURATION         #########################
  ##############################################################################################

  workload_identity_domains_groups_configuration = {
    groups : {
      SECURITY_ADMIN : {
        identity_domain_id = var.scca_child_identity_domain_id
        name               = "WRK_SECURITY_ADMIN_CHILD_${var.resource_label}"
        description        = "Security Admin Group for SCCA Workload"
      }
      NETWORK_ADMIN : {
        identity_domain_id = var.scca_child_identity_domain_id
        name               = "WRK_NETWORK_ADMIN_CHILD_${var.resource_label}"
        description        = "Network Admin Group for SCCA Workload"
      }
      SYSTEM_ADMIN : {
        identity_domain_id = var.scca_child_identity_domain_id
        name               = "WRK_SYSTEM_ADMIN_CHILD_${var.resource_label}"
        description        = "System Admin Group for SCCA Workload"
      }
      APPLICATION_ADMIN : {
        identity_domain_id = var.scca_child_identity_domain_id
        name               = "WRK_APPLICATION_ADMIN_CHILD_${var.resource_label}"
        description        = "Application Admin Group for SCCA Workload"
      }
      AUDIT_ADMIN : {
        identity_domain_id = var.scca_child_identity_domain_id
        name               = "WRK_AUDIT_ADMIN_CHILD_${var.resource_label}"
        description        = "Audit Admin Group for SCCA Workload"
      }
      BUSINESS_ADMIN : {
        identity_domain_id = var.scca_child_identity_domain_id
        name               = "WRK_BUSINESS_ADMIN_CHILD_${var.resource_label}"
        description        = "Business Admin Group for SCCA Workload"
      }
    }
  }

  ##############################################################################################
  #############            WORKLOAD POLICIES CONFIGURATION             #########################
  ##############################################################################################

  scca_compartment_map = { for compartment in data.oci_identity_compartments.scca_compartments.compartments : compartment.id => compartment.name }

  security_admin    = "'${data.oci_identity_domain.scca_identity_domain.display_name}'/'${local.workload_identity_domains_groups_configuration.groups.SECURITY_ADMIN.name}'"
  network_admin     = "'${data.oci_identity_domain.scca_identity_domain.display_name}'/'${local.workload_identity_domains_groups_configuration.groups.NETWORK_ADMIN.name}'"
  system_admin      = "'${data.oci_identity_domain.scca_identity_domain.display_name}'/'${local.workload_identity_domains_groups_configuration.groups.SYSTEM_ADMIN.name}'"
  application_admin = "'${data.oci_identity_domain.scca_identity_domain.display_name}'/'${local.workload_identity_domains_groups_configuration.groups.APPLICATION_ADMIN.name}'"
  audit_admin       = "'${data.oci_identity_domain.scca_identity_domain.display_name}'/'${local.workload_identity_domains_groups_configuration.groups.AUDIT_ADMIN.name}'"
  business_admin    = "'${data.oci_identity_domain.scca_identity_domain.display_name}'/'${local.workload_identity_domains_groups_configuration.groups.BUSINESS_ADMIN.name}'"

  workload_policies_configuration = {
    supplied_policies : {
      "WKL-POLICY" : {
        name : "OCI-SCCA-LZ-Workload-Policy-${var.resource_label}"
        description : "OCI SCCA Landing Zone Workload Admin Policy"
        compartment_id : var.scca_child_home_compartment_ocid
        statements : [
          "Allow group ${local.system_admin} to read bucket in compartment ${module.workload_compartment.compartments["WKL-CMP"].name}",
          "Allow group ${local.system_admin} to inspect object in compartment ${module.workload_compartment.compartments["WKL-CMP"].name}",
          "Allow group ${local.system_admin} to manage object-family in compartment ${module.workload_compartment.compartments["WKL-CMP"].name} where any {request.permission = 'OBJECT_DELETE', request.permission = 'BUCKET_DELETE'}",
          "Allow group ${local.system_admin} to read volume-family in compartment ${module.workload_compartment.compartments["WKL-CMP"].name}",
          "Allow group ${local.system_admin} to manage volume-family in compartment ${module.workload_compartment.compartments["WKL-CMP"].name} where any {request.permission = 'VOLUME_DELETE', request.permission = 'VOLUME_BACKUP_DELETE', request.permission = 'BOOT_VOLUME_BACKUP_DELETE'}",
          "Allow group ${local.system_admin} to read file-family in compartment ${module.workload_compartment.compartments["WKL-CMP"].name}",
          "Allow group ${local.system_admin} to manage file-family in compartment ${module.workload_compartment.compartments["WKL-CMP"].name} where any {request.permission = 'FILE_SYSTEM_DELETE', request.permission = 'MOUNT_TARGET_DELETE', request.permission = 'EXPORT_SET_UPDATE', request.permission = 'FILE_SYSTEM_NFSv3_UNEXPORT', request.permission = 'EXPORT_SET_DELETE', request.permission = 'FILE_SYSTEM_DELETE_SNAPSHOT'}",
          "Allow group ${local.system_admin} to manage management-agents in compartment ${module.workload_compartment.compartments["WKL-CMP"].name}",
          "Allow group ${local.system_admin} to use metrics in compartment ${module.workload_compartment.compartments["WKL-CMP"].name}",
          "Allow group ${local.system_admin} to use tag-namespaces in compartment ${module.workload_compartment.compartments["WKL-CMP"].name}",
          "Allow group ${local.application_admin} to read virtual-network-family in compartment ${local.scca_compartment_map[var.scca_child_vdss_compartment_ocid]}",
          "Allow group ${local.application_admin} to use subnets in compartment ${local.scca_compartment_map[var.scca_child_vdss_compartment_ocid]}",
          "Allow group ${local.application_admin} to use network-security-groups in compartment ${local.scca_compartment_map[var.scca_child_vdss_compartment_ocid]}",
          "Allow group ${local.application_admin} to use vnics in compartment ${local.scca_compartment_map[var.scca_child_vdss_compartment_ocid]}",
          "Allow group ${local.application_admin} to use load-balancers in compartment ${local.scca_compartment_map[var.scca_child_vdss_compartment_ocid]}",
          "Allow group ${local.application_admin} to read vss-family in compartment ${local.scca_compartment_map[var.scca_child_vdms_compartment_ocid]}",
          "Allow group ${local.application_admin} to use vaults in compartment ${local.scca_compartment_map[var.scca_child_vdms_compartment_ocid]}",
          "Allow group ${local.application_admin} to use bastion in compartment ${local.scca_compartment_map[var.scca_child_vdms_compartment_ocid]}",
          "Allow group ${local.application_admin} to manage bastion-session in compartment ${local.scca_compartment_map[var.scca_child_vdms_compartment_ocid]}",
          "Allow group ${local.application_admin} to read logging-family in compartment ${local.scca_compartment_map[var.scca_child_vdms_compartment_ocid]}",
          "Allow group ${local.application_admin} to manage all-resources in compartment ${module.workload_compartment.compartments["WKL-CMP"].name}",
          "Allow group ${local.application_admin} to read all-resources in compartment ${module.workload_compartment.compartments["WKL-CMP"].name}",
          "Allow group ${local.application_admin} to manage functions-family in compartment ${module.workload_compartment.compartments["WKL-CMP"].name}",
          "Allow group ${local.application_admin} to manage api-gateway-family in compartment ${module.workload_compartment.compartments["WKL-CMP"].name}",
          "Allow group ${local.application_admin} to manage ons-family in compartment ${module.workload_compartment.compartments["WKL-CMP"].name}",
          "Allow group ${local.application_admin} to manage streams in compartment ${module.workload_compartment.compartments["WKL-CMP"].name}",
          "Allow group ${local.application_admin} to manage cluster-family in compartment ${module.workload_compartment.compartments["WKL-CMP"].name}",
          "Allow group ${local.application_admin} to manage alarms in compartment ${module.workload_compartment.compartments["WKL-CMP"].name}",
          "Allow group ${local.application_admin} to manage metrics in compartment ${module.workload_compartment.compartments["WKL-CMP"].name}",
          "Allow group ${local.application_admin} to manage logging-family in compartment ${module.workload_compartment.compartments["WKL-CMP"].name}",
          "Allow group ${local.application_admin} to manage instance-family in compartment ${module.workload_compartment.compartments["WKL-CMP"].name}",
          "Allow group ${local.application_admin} to manage volume-family in compartment ${module.workload_compartment.compartments["WKL-CMP"].name} where all {request.permission != 'VOLUME_BACKUP_DELETE', request.permission != 'VOLUME_DELETE', request.permission != 'BOOT_VOLUME_BACKUP_DELETE'}",
          "Allow group ${local.application_admin} to manage object-family in compartment ${module.workload_compartment.compartments["WKL-CMP"].name} where all {request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE'}",
          "Allow group ${local.application_admin} to manage file-family in compartment ${module.workload_compartment.compartments["WKL-CMP"].name} where all {request.permission != 'FILE_SYSTEM_DELETE', request.permission != 'MOUNT_TARGET_DELETE', request.permission != 'EXPORT_SET_DELETE', request.permission != 'FILE_SYSTEM_DELETE_SNAPSHOT', request.permission != 'FILE_SYSTEM_NFSv3_UNEXPORT'}",
          "Allow group ${local.application_admin} to manage repos in compartment ${module.workload_compartment.compartments["WKL-CMP"].name}",
          "Allow group ${local.application_admin} to manage orm-stacks in compartment ${module.workload_compartment.compartments["WKL-CMP"].name}",
          "Allow group ${local.application_admin} to manage orm-jobs in compartment ${module.workload_compartment.compartments["WKL-CMP"].name}",
          "Allow group ${local.application_admin} to manage orm-config-source-providers in compartment ${module.workload_compartment.compartments["WKL-CMP"].name}",
          "Allow group ${local.application_admin} to manage bastion-session in compartment ${module.workload_compartment.compartments["WKL-CMP"].name}",
          "Allow group ${local.application_admin} to manage cloudevents-rules in compartment ${module.workload_compartment.compartments["WKL-CMP"].name}",
          "Allow group ${local.application_admin} to use vnics in compartment ${module.workload_compartment.compartments["WKL-CMP"].name}",
          "Allow group ${local.application_admin} to manage keys in compartment ${module.workload_compartment.compartments["WKL-CMP"].name}",
          "Allow group ${local.application_admin} to use key-delegate in compartment ${module.workload_compartment.compartments["WKL-CMP"].name}",
          "Allow group ${local.application_admin} to manage secret-family in compartment ${module.workload_compartment.compartments["WKL-CMP"].name}",
          "Allow group ${local.application_admin} to manage database-family in compartment ${module.workload_compartment.compartments["WKL-CMP"].name}",
          "Allow group ${local.application_admin} to manage autonomous-database-family in compartment ${module.workload_compartment.compartments["WKL-CMP"].name}",
          "Allow group ${local.application_admin} to manage data-safe-family in compartment ${module.workload_compartment.compartments["WKL-CMP"].name}",
          "Allow group ${local.application_admin} to read autonomous-database-family in compartment ${module.workload_compartment.compartments["WKL-CMP"].name}",
          "Allow group ${local.application_admin} to read database-family in compartment ${module.workload_compartment.compartments["WKL-CMP"].name}",
        ]
      }
    }
  }
}

##############################################################################################
###################          TERRAFORM MODULE CREATION           #############################
##############################################################################################
module "workload_identity_domains" {
  source                               = "github.com/oci-landing-zones/terraform-oci-modules-iam//identity-domains?ref=v0.2.3"
  tenancy_ocid                         = var.tenancy_ocid
  identity_domain_groups_configuration = local.workload_identity_domains_groups_configuration
}

module "sccalz_workload_policies" {
  source                  = "github.com/oci-landing-zones/terraform-oci-modules-iam//policies?ref=v0.2.3"
  tenancy_ocid            = var.tenancy_ocid
  policies_configuration  = local.workload_policies_configuration
  compartments_dependency = module.workload_compartment.compartments
}