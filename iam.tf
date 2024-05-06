# ###################################################################################################### #
# Copyright (c) 2023 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

locals {
  identity_domain = {
    domain_description        = "OCI SCCA Landing Zone Identity Domain"
    domain_display_name       = "OCI-SCCA-LZ-Domain-${local.region_key[0]}-${var.resource_label}"
    domain_license_type       = "premium"
    domain_is_hidden_on_login = false
    vdss_admin_group_name     = "VDSSAdmin"
    vdms_admin_group_name     = "VDMSAdmin"
    workload_admin_group_name = "WorkloadAdmin"
    dynamic_groups = {
      osms_dynamic_group = {
        dynamic_group_name = "OCI-SCCA-LZ-Instance-Group-${var.resource_label}"
        matching_rule      = "Any { instance.compartment.id = '${var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.multi_region_vdms_compartment_ocid}', instance.compartment.id = '${var.home_region_deployment ? module.vdss_compartment[0].compartment_id : var.multi_region_vdss_compartment_ocid}', instance.compartment.id = '${var.home_region_deployment ? module.workload_compartment[0].compartment_id : var.multi_region_workload_compartment_ocid}', instance.compartment.id = '${var.home_region_deployment ? module.home_compartment[0].compartment_id : var.multi_region_home_compartment_ocid}'}"
      }
    }
  }
}

module "identity_domain" {
  source                    = "./modules/identity-domain"
  count                     = var.home_region_deployment ? 1 : 0
  compartment_id            = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.multi_region_vdms_compartment_ocid
  domain_description        = local.identity_domain.domain_description
  domain_display_name       = local.identity_domain.domain_display_name
  domain_license_type       = local.identity_domain.domain_license_type
  domain_is_hidden_on_login = local.identity_domain.domain_is_hidden_on_login
  domain_home_region        = var.region
  enable_domain_replication = var.enable_domain_replication
  domain_replica_region     = var.secondary_region
}

module "vdss_admin_group" {
  source                   = "./modules/non-default-domain-group"
  count                    = var.home_region_deployment ? 1 : 0
  idcs_endpoint            = var.home_region_deployment ? module.identity_domain[0].domain.url : ""
  group_display_name       = local.identity_domain.vdss_admin_group_name
}

module "vdms_admin_group" {
  source                   = "./modules/non-default-domain-group"
  count                    = var.home_region_deployment ? 1 : 0
  idcs_endpoint            = var.home_region_deployment ? module.identity_domain[0].domain.url : ""
  group_display_name       = local.identity_domain.vdms_admin_group_name
}

module "workload_admin_group" {
  source                   = "./modules/non-default-domain-group"
  count                    = var.home_region_deployment ? 1 : 0
  idcs_endpoint            = var.home_region_deployment ? module.identity_domain[0].domain.url : ""
  group_display_name       = local.identity_domain.workload_admin_group_name
}

module "osms_dynamic_group" {
  source                   = "./modules/identity-domain-dynamic-group"
  count                    = var.home_region_deployment ? 1 : 0
  idcs_endpoint            = var.home_region_deployment ? module.identity_domain[0].domain.url : ""
  group_display_name       = local.identity_domain.dynamic_groups.osms_dynamic_group.dynamic_group_name
  matching_rule            = local.identity_domain.dynamic_groups.osms_dynamic_group.matching_rule
}

locals {
  bucket_replication_policy = {
    name        = "OCI-SCCA-LZ-Bucket-Replication-Policy-${var.resource_label}"
    description = "OCI SCCA Landing Zone Bucket Replication Service Policy"

    statements = [
      "Allow service objectstorage-${var.region}, objectstorage-${var.secondary_region} to manage object-family in compartment ${var.logging_compartment_name}-${local.region_key[0]}-${var.resource_label}"
    ]
  }

  vault_policy = {
    name        = "OCI-SCCA-LZ-Vault-Policy-${var.resource_label}"
    description = "OCI SCCA Landing Zone Vault Policy"

    statements = [
      "Allow service keymanagementservice to manage vaults in compartment ${var.home_compartment_name}-${local.region_key[0]}-${var.resource_label}"
    ]
  }

  key_policy = {
    name        = "OCI-SCCA-LZ-Key-Policy-${var.resource_label}"
    description = "OCI SCCA Landing Zone Key Policy"

    statements = [
      "Allow service objectstorage-${var.region} to use keys in compartment ${var.vdms_compartment_name}-${local.region_key[0]}-${var.resource_label} where target.key.id = ${module.master_encryption_key.key_ocid}",
      "Allow service objectstorage-${var.secondary_region} to use keys in compartment ${var.vdms_compartment_name}-${local.region_key[0]}-${var.resource_label} where target.key.id = ${module.master_encryption_key.key_ocid}",
      "Allow service blockstorage,FssOc${var.realm_key}Prod,oke,streaming to use keys in compartment ${var.vdms_compartment_name}-${local.region_key[0]}-${var.resource_label} where target.key.id = ${module.master_encryption_key.key_ocid}",
      "Allow service blockstorage, objectstorage-${var.region}, objectstorage-${var.secondary_region}, FssOc${var.realm_key}Prod, oke, streaming to use keys in compartment ${var.vdms_compartment_name}-${local.region_key[0]}-${var.resource_label}"
    ]
  }

  cloud_guard_policy = {
    name        = "OCI-SCCA-LZ-Cloud-Guard-Policy-${var.resource_label}"
    description = "OCI SCCA Landing Zone Cloud Guard Policy"

    statements = [
      "Allow service cloudguard to read vaults in tenancy",
      "Allow service cloudguard to read keys in tenancy",
      "Allow service cloudguard to read compartments in tenancy",
      "Allow service cloudguard to read tenancies in tenancy",
      "Allow service cloudguard to read audit-events in tenancy",
      "Allow service cloudguard to read compute-management-family in tenancy",
      "Allow service cloudguard to read instance-family in tenancy",
      "Allow service cloudguard to read virtual-network-family in tenancy",
      "Allow service cloudguard to read volume-family in tenancy",
      "Allow service cloudguard to read database-family in tenancy",
      "Allow service cloudguard to read object-family in tenancy",
      "Allow service cloudguard to read load-balancers in tenancy",
      "Allow service cloudguard to read users in tenancy",
      "Allow service cloudguard to read groups in tenancy",
      "Allow service cloudguard to read policies in tenancy",
      "Allow service cloudguard to read dynamic-groups in tenancy",
      "Allow service cloudguard to read authentication-policies in tenancy",
      "Allow service cloudguard to use network-security-groups in tenancy",
      "Allow service cloudguard to read data-safe-family in tenancy",
      "Allow service cloudguard to read autonomous-database-family in tenancy",
      "Allow service cloudguard to manage cloudevents-rules in tenancy where target.rule.type='managed'",
      "Allow service cloudguard to manage instance-family in compartment ${var.home_compartment_name}-${local.region_key[0]}-${var.resource_label}",
      "Allow service cloudguard to manage object-family in compartment ${var.home_compartment_name}-${local.region_key[0]}-${var.resource_label}",
      "Allow service cloudguard to manage buckets in compartment ${var.home_compartment_name}-${local.region_key[0]}-${var.resource_label}",
      "Allow service cloudguard to manage users in compartment ${var.home_compartment_name}-${local.region_key[0]}-${var.resource_label}",
      "Allow service cloudguard to manage policies in compartment ${var.home_compartment_name}-${local.region_key[0]}-${var.resource_label}",
      "Allow service cloudguard to manage keys in compartment ${var.home_compartment_name}-${local.region_key[0]}-${var.resource_label}",
    ]
  }

  remote_tenancy_policy = {
    name        = "OCI-SCCA-LZ-Remote-Tenancy-Policy-${var.resource_label}"
    description = "OCI SCCA Landing Zone Remote Tenancy Policy"

    statements = [
      "Define tenancy ${var.remote_tenancy_name} as ${var.remote_tenancy_ocid}",
      "Endorse any-user to manage object-family in tenancy ${var.remote_tenancy_name}",
    ]
  }

  vdss_policy = {
    name        = "OCI-SCCA-LZ-VDSS-Policy"
    description = "This account corresponds to all transit services corresponding to the DISA SCCA Virtual Data Center Security Stack (VDSS)"
    statements = [
      "Allow group ${local.identity_domain.domain_display_name}/VDSSAdmin to manage all-resources in compartment ${var.vdss_compartment_name}-${local.region_key[0]}-${var.resource_label}",
      "Allow group ${local.identity_domain.domain_display_name}/VDSSAdmin to use key-delegate in compartment ${var.vdms_compartment_name}-${local.region_key[0]}-${var.resource_label} where target.key.id = ${module.master_encryption_key.key_ocid}",
      "Allow group ${local.identity_domain.domain_display_name}/VDSSAdmin to manage virtual-network-family in compartment ${var.home_compartment_name}-${local.region_key[0]}-${var.resource_label}",
    ]
  }

  vdms_policy = {
    name        = "OCI-SCCA-LZ-VDMS-Policy"
    description = "This account corresponds to all of the core services required for managing the operations of the environment, the Virtual Data Center Management Stack (VDMS)"
    statements = [
      "Allow group ${local.identity_domain.domain_display_name}/VDMSAdmin to manage all-resources in compartment ${var.vdms_compartment_name}-${local.region_key[0]}-${var.resource_label}",
      "Allow group ${local.identity_domain.domain_display_name}/VDMSAdmin to read threat-intel-family in compartment ${var.home_compartment_name}-${local.region_key[0]}-${var.resource_label}",
      "Allow group ${local.identity_domain.domain_display_name}/VDMSAdmin to manage vss-family in compartment ${var.home_compartment_name}-${local.region_key[0]}-${var.resource_label}",
      "Allow group ${local.identity_domain.domain_display_name}/VDMSAdmin to manage cloudevents-rules in compartment ${var.home_compartment_name}-${local.region_key[0]}-${var.resource_label}",
      "Allow group ${local.identity_domain.domain_display_name}/VDMSAdmin to manage bastion-family in compartment ${var.home_compartment_name}-${local.region_key[0]}-${var.resource_label}",
      "Allow group ${local.identity_domain.domain_display_name}/VDMSAdmin to manage virtual-network-family in compartment ${var.home_compartment_name}-${local.region_key[0]}-${var.resource_label}",
      "Allow group ${local.identity_domain.domain_display_name}/VDMSAdmin to read instance-family in compartment ${var.home_compartment_name}-${local.region_key[0]}-${var.resource_label}",
      "Allow group ${local.identity_domain.domain_display_name}/VDMSAdmin to read instance-agent-plugins in compartment ${var.home_compartment_name}-${local.region_key[0]}-${var.resource_label}",
      "Allow group ${local.identity_domain.domain_display_name}/VDMSAdmin to inspect work-requests in compartment ${var.home_compartment_name}-${local.region_key[0]}-${var.resource_label}"
    ]
  }

  workload_policy = {
    name        = "OCI-SCCA-LZ-Workload-Policy"
    description = "This account is required for the management of the Mission Application workloads."
    statements = [
      "Allow group ${local.identity_domain.domain_display_name}/WorkloadAdmin to manage all-resources in compartment OCI-SCCA-LZ-${var.workload_name}-${var.mission_owner_key}",
      "Allow group ${local.identity_domain.domain_display_name}/WorkloadAdmin to use key-delegate in compartment ${var.vdms_compartment_name}-${local.region_key[0]}-${var.resource_label} where target.key.id = ${module.master_encryption_key.key_ocid}"
    ]
  }
}

module "bucket_replication_policy" {
  count            = var.home_region_deployment && var.enable_logging_compartment ? 1 : 0
  source           = "./modules/policies"
  compartment_ocid = var.home_region_deployment ? module.home_compartment[0].compartment_id : var.multi_region_home_compartment_ocid
  policy_name      = local.bucket_replication_policy.name
  description      = local.bucket_replication_policy.description
  statements       = local.bucket_replication_policy.statements
  depends_on = [
    module.logging_compartment[0]
  ]
}

module "vault_policy" {
  source           = "./modules/policies"
  count            = var.home_region_deployment ? 1 : 0
  compartment_ocid = var.home_region_deployment ? module.home_compartment[0].compartment_id : var.multi_region_home_compartment_ocid
  policy_name      = local.vault_policy.name
  description      = local.vault_policy.description
  statements       = local.vault_policy.statements
}

module "key_policy" {
  source           = "./modules/policies"
  count            = var.home_region_deployment ? 1 : 0
  compartment_ocid = var.home_region_deployment ? module.home_compartment[0].compartment_id : var.multi_region_home_compartment_ocid
  policy_name      = local.key_policy.name
  description      = local.key_policy.description
  statements       = local.key_policy.statements
  depends_on       = [module.master_encryption_key]
}

module "cloud_guard_policy" {
  source           = "./modules/policies"
  count            = var.home_region_deployment ? 1 : 0
  compartment_ocid = var.tenancy_ocid
  policy_name      = local.cloud_guard_policy.name
  description      = local.cloud_guard_policy.description
  statements       = local.cloud_guard_policy.statements
  depends_on = [
    module.home_compartment[0]
  ]
}

module "vdss_policy" {
  source           = "./modules/policies"
  count            = var.home_region_deployment ? 1 : 0
  compartment_ocid = var.home_region_deployment ? module.home_compartment[0].compartment_id : var.multi_region_home_compartment_ocid
  policy_name      = local.vdss_policy.name
  description      = local.vdss_policy.description
  statements       = local.vdss_policy.statements
}

module "vdms_policy" {
  source           = "./modules/policies"
  count            = var.home_region_deployment ? 1 : 0
  compartment_ocid = var.home_region_deployment ? module.home_compartment[0].compartment_id : var.multi_region_home_compartment_ocid
  policy_name      = local.vdms_policy.name
  description      = local.vdms_policy.description
  statements       = local.vdms_policy.statements
}

module "workload_policy" {
  source           = "./modules/policies"
  count            = var.home_region_deployment ? 1 : 0
  compartment_ocid = var.home_region_deployment ? module.home_compartment[0].compartment_id : var.multi_region_home_compartment_ocid
  policy_name      = local.workload_policy.name
  description      = local.workload_policy.description
  statements       = local.workload_policy.statements
}

module "remote_tenancy_policy" {
  count            = var.home_region_deployment && !var.enable_logging_compartment ? 1 : 0
  source           = "./modules/policies"
  compartment_ocid = var.tenancy_ocid
  policy_name      = local.remote_tenancy_policy.name
  description      = local.remote_tenancy_policy.description
  statements       = local.remote_tenancy_policy.statements
}
