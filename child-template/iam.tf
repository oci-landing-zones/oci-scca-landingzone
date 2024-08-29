# ###################################################################################################### #
# Copyright (c) 2024 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

locals {

  #--------------------------------------------------------------------------------------------#
  # IDENTITY DOMAIN and GROUPS
  #--------------------------------------------------------------------------------------------#

  identity_domains_configuration = {
    default_compartment_id : null
    default_defined_tags : null
    default_freeform_tags : null
    identity_domains : {
      SCCA_CHILD_DOMAIN : {
        compartment_id            = "SCCA_CHILD_HOME_CMP"
        display_name              = var.deployment_type == "SINGLE" ? "OCI-SCCA-DOMAIN-${local.region_key[0]}-${var.resource_label}" : "OCI-SCCA-CHILD-DOMAIN-${local.region_key[0]}-${var.resource_label}"
        description               = "OCI SCCA Landing Zone Identity Domain"
        home_region               = var.region
        license_type              = var.identity_domain_license_type
        is_hidden_on_login        = false
        is_notification_bypassed  = false
        is_primary_email_required = true
        replica_region            = var.enable_domain_replication ? var.secondary_region : null
      }
    }
  }

  identity_domain_groups_configuration = {
    default_identity_domain_id : "SCCA_CHILD_DOMAIN"
    default_defined_tags : null
    default_freeform_tags : null
    groups : {
      SECURITY_ADMIN_CHILD : {
        name        = var.deployment_type == "SINGLE" ? "SECURITY_ADMIN" : "SECURITY_ADMIN_CHILD"
        description = "Security Admin Group for OCI SCCA Landing Zone Child Tenancy"

      }
      NETWORK_ADMIN_CHILD : {
        name        = var.deployment_type == "SINGLE" ? "NETWORK_ADMIN"  : "NETWORK_ADMIN_CHILD"
        description = "Network Admin Group for OCI SCCA Landing Zone Child Tenancy"
      }
      SYSTEM_ADMIN_CHILD : {
        name        = var.deployment_type == "SINGLE" ? "SYSTEM_ADMIN"  : "SYSTEM_ADMIN_CHILD"
        description = "System Admin Group for OCI SCCA Landing Zone Child Tenancy"
      }
      APPLICATION_ADMIN_CHILD : {
        name        = var.deployment_type == "SINGLE" ? "APPLICATION_ADMIN" :  "APPLICATION_ADMIN_CHILD"
        description = "Application Admin Group for OCI SCCA Landing Zone Child Tenancy"
      }
      AUDIT_ADMIN_CHILD : {
        name        = var.deployment_type == "SINGLE" ? "AUDIT_ADMIN" : "AUDIT_ADMIN_CHILD"
        description = "Audit Admin Group for OCI SCCA Landing Zone Child Tenancy"
      }
      BUSINESS_ADMIN_CHILD : {
        name        = var.deployment_type == "SINGLE" ? "BUSINESS_ADMIN" : "BUSINESS_ADMIN_CHILD"
        description = "Business Admin Group for OCI SCCA Landing Zone Child Tenancy"
      }
    }
  }

  security_admin    = "'${local.identity_domains_configuration.identity_domains.SCCA_CHILD_DOMAIN.display_name}'/'${local.identity_domain_groups_configuration.groups.SECURITY_ADMIN_CHILD.name}'"
  network_admin     = "'${local.identity_domains_configuration.identity_domains.SCCA_CHILD_DOMAIN.display_name}'/'${local.identity_domain_groups_configuration.groups.NETWORK_ADMIN_CHILD.name}'"
  system_admin      = "'${local.identity_domains_configuration.identity_domains.SCCA_CHILD_DOMAIN.display_name}'/'${local.identity_domain_groups_configuration.groups.SYSTEM_ADMIN_CHILD.name}'"
  application_admin = "'${local.identity_domains_configuration.identity_domains.SCCA_CHILD_DOMAIN.display_name}'/'${local.identity_domain_groups_configuration.groups.APPLICATION_ADMIN_CHILD.name}'"
  audit_admin       = "'${local.identity_domains_configuration.identity_domains.SCCA_CHILD_DOMAIN.display_name}'/'${local.identity_domain_groups_configuration.groups.AUDIT_ADMIN_CHILD.name}'"
  business_admin    = "'${local.identity_domains_configuration.identity_domains.SCCA_CHILD_DOMAIN.display_name}'/'${local.identity_domain_groups_configuration.groups.BUSINESS_ADMIN_CHILD.name}'"

  #--------------------------------------------------------------------------------------------#
  # POLICIES
  #--------------------------------------------------------------------------------------------#

  #-- Compartment metadata attributes. These are passed to the policy module via supplied_compartments' cislz_metadata attribute.
  cislz_compartments_metadata = {
    "enclosing" : {
      "cislz-cmp-type" : "enclosing",
      "cislz-consumer-groups-security" : local.security_admin,
      "cislz-consumer-groups-iam" : local.security_admin,
      "cislz-consumer-groups-application" : local.application_admin,
    },
    "network" : {
      "cislz-cmp-type" : "network",
      "cislz-consumer-groups-network" : local.network_admin,
      "cislz-consumer-groups-storage" : local.system_admin,
      "cislz-consumer-groups-security" : local.security_admin
      "cislz-consumer-groups-application" : local.application_admin,
    },
    "security" : {
      "cislz-cmp-type" : "security",
      "cislz-consumer-groups-security" : local.security_admin,
      "cislz-consumer-groups-network" : local.network_admin,
      "cislz-consumer-groups-application" : local.application_admin,
      "cislz-consumer-groups-storage" : local.system_admin
    },
    "application" : {
      "cislz-cmp-type" : "application",
      "cislz-consumer-groups-security" : local.security_admin,
      "cislz-consumer-groups-application" : local.application_admin,
      "cislz-consumer-groups-storage" : local.system_admin,
      #"cislz-consumer-groups-dyn-compute-agent":"appdev-computeagent-dynamic-group"  ## for dynamic group
    },
    "logging" : {
      "cislz-cmp-type" : "logging",
    },
    "backup" : {
      "cislz-cmp-type" : "backup",
    },
  }

  cmps_from_cmp_module = var.home_region_deployment ? {
    for cmp in module.scca_compartments[0].compartments : cmp.name =>
    {
      name : cmp.name,
      id : cmp.id,
      cislz_metadata : local.cislz_compartments_metadata[cmp.freeform_tags["cislz-cmp-type"]] #-- This example expects compartments to be freeform tagged with "cislz-cmp-type", so it can figure out the compartments intent and associate it with the appropriate metadata.
    }
    #if lookup(cmp.freeform_tags, "sccalz", "") == var.resource_label
  } : {}

  policies_configuration = {
    supplied_policies : { ## supplied scca policy statements
      "VAULT-POLICY" : {
        name : "OCI-SCCA-LZ-Vault-Policy-${var.resource_label}"
        description : "OCI SCCA Landing Zone Vault Policy"
        compartment_id : var.home_region_deployment ? "SCCA_CHILD_HOME_CMP" : var.multi_region_home_compartment_ocid
        statements : [
          "Allow service keymanagementservice to manage vaults in compartment ${module.scca_compartments[0].compartments["SCCA_CHILD_HOME_CMP"].name}"
        ]
      }
      "AUDITOR-POLICY" : {
        name : "OCI-SCCA-LZ-Auditor-Policy-${var.resource_label}"
        description : "OCI SCCA Landing Zone Auditor Admin Policy"
        compartment_id : var.home_region_deployment ? "SCCA_CHILD_HOME_CMP" : var.multi_region_home_compartment_ocid
        statements : [
          "Allow group ${local.audit_admin} to inspect all-resources in compartment ${module.scca_compartments[0].compartments["SCCA_CHILD_HOME_CMP"].name}",
          "Allow group ${local.audit_admin} to read instances in compartment ${module.scca_compartments[0].compartments["SCCA_CHILD_HOME_CMP"].name}",
          "Allow group ${local.audit_admin} to read load-balancers in compartment ${module.scca_compartments[0].compartments["SCCA_CHILD_HOME_CMP"].name}",
          "Allow group ${local.audit_admin} to read buckets in compartment ${module.scca_compartments[0].compartments["SCCA_CHILD_HOME_CMP"].name}",
          "Allow group ${local.audit_admin} to read nat-gateways in compartment ${module.scca_compartments[0].compartments["SCCA_CHILD_HOME_CMP"].name}",
          "Allow group ${local.audit_admin} to read public-ips in compartment ${module.scca_compartments[0].compartments["SCCA_CHILD_HOME_CMP"].name}",
          "Allow group ${local.audit_admin} to read file-family in compartment ${module.scca_compartments[0].compartments["SCCA_CHILD_HOME_CMP"].name}",
          "Allow group ${local.audit_admin} to read instance-configurations in compartment ${module.scca_compartments[0].compartments["SCCA_CHILD_HOME_CMP"].name}",
          "Allow group ${local.audit_admin} to read network-security-groups in compartment ${module.scca_compartments[0].compartments["SCCA_CHILD_HOME_CMP"].name}",
          "Allow group ${local.audit_admin} to read resource-availability in compartment ${module.scca_compartments[0].compartments["SCCA_CHILD_HOME_CMP"].name}",
          "Allow group ${local.audit_admin} to read audit-events in compartment ${module.scca_compartments[0].compartments["SCCA_CHILD_HOME_CMP"].name}",
          "Allow group ${local.audit_admin} to read users in compartment ${module.scca_compartments[0].compartments["SCCA_CHILD_HOME_CMP"].name}",
          "Allow group ${local.audit_admin} to read vss-family in compartment ${module.scca_compartments[0].compartments["SCCA_CHILD_HOME_CMP"].name}",
          "Allow group ${local.audit_admin} to read data-safe-family in compartment ${module.scca_compartments[0].compartments["SCCA_CHILD_HOME_CMP"].name}",
          "Allow group ${local.audit_admin} to read usage-budgets in compartment ${module.scca_compartments[0].compartments["SCCA_CHILD_HOME_CMP"].name}",
        ]
      }
    }

    template_policies : {
      tenancy_level_settings : {
        groups_with_tenancy_level_roles : [
          { "name" : local.business_admin, "roles" : "cost" },
          # { "name":local.audit_admin, "roles":"auditor" },
          # { "name":local.security_admin, "roles":"security,basic,cred" },
          # { "name":local.system_admin, "roles":"announcement-reader" },
        ]
        oci_services : { //Policies can be enabled for all services at once or on a per service basis. 
          # enable_all_policies : true  # when set to true, policies are enabled for all services.
          enable_scanning_policies       = true,
          enable_cloud_guard_policies    = true,
          enable_os_management_policies  = true,
          enable_block_storage_policies  = true,
          enable_file_storage_policies   = true,
          enable_streaming_policies      = true,
          enable_object_storage_policies = true,
          # enable_oke_policies = true,
        }
        #policy_name_prefix : "sccalz-${var.resource_label}"
      }
      compartment_level_settings : {
        supplied_compartments : local.cmps_from_cmp_module
      }
    }
    policy_name_prefix : "sccalz-${var.resource_label}"
  }

  key_policies_configuration = {
    supplied_policies : {
      "KEY-POLICY" : {
        name : "OCI-SCCA-LZ-Key-Policy-${var.resource_label}"
        description : "OCI SCCA Landing Zone Key Policy"
        compartment_id : var.home_region_deployment ? "SCCA_CHILD_HOME_CMP" : var.multi_region_home_compartment_ocid
        statements : [
          "Allow service objectstorage-${var.region} to use keys in compartment ${local.vdms_compartment.name} where target.key.id = ${module.central_vault_and_key.keys["MASTER-ENCRYPTION_KEY"].id}",
          "Allow service objectstorage-${var.secondary_region} to use keys in compartment ${local.vdms_compartment.name} where target.key.id = ${module.central_vault_and_key.keys["MASTER-ENCRYPTION_KEY"].id}",
          "Allow service blockstorage,FssOc${var.realm_key}Prod,oke,streaming to use keys in compartment ${local.vdms_compartment.name} where target.key.id = ${module.central_vault_and_key.keys["MASTER-ENCRYPTION_KEY"].id}",
          "Allow service blockstorage, objectstorage-${var.region}, objectstorage-${var.secondary_region}, FssOc${var.realm_key}Prod, oke, streaming to use keys in compartment ${local.vdms_compartment.name}",
        ]
      }
    }
  }

  bucket_replication_policies_configuration = var.home_region_deployment && var.enable_logging_compartment ? {
    supplied_policies : {
      "BUCKET-REPLICATION-POLICY" : {
        name : "OCI-SCCA-LZ-Bucket-Replication-Policy-${var.resource_label}"
        description : "OCI SCCA Landing Zone Bucket Replication Service Policy"
        compartment_id : var.home_region_deployment ? "SCCA_CHILD_HOME_CMP" : var.multi_region_home_compartment_ocid
        statements : [
          "Allow group ${local.system_admin} to manage buckets in compartment ${local.logging_compartment.name}",
          "Allow group ${local.system_admin} to manage objects in compartment ${local.logging_compartment.name}",
          "Allow service objectstorage-${var.region}, objectstorage-${var.secondary_region} to manage object-family in compartment ${local.logging_compartment.name}",
        ]
      }
    }
  } : null

  rpc_requester_policies_configuration = var.enable_service_deployment && var.home_region_deployment ? {
    supplied_policies : {
      "RPC-REQUESTOR-POLICY" : {
        name : "OCI-SCCA-LZ-RPC-Requestor-Policy-${var.resource_label}"
        description : "OCI SCCA Landing Zone RPC Requester Policy"
        compartment_id : "TENANCY-ROOT"
        statements : [
          "Define tenancy Acceptor as ${var.parent_tenancy_ocid}",
          "Allow group Administrators to manage remote-peering-from in compartment ${local.home_compartment.name}:${local.vdss_compartment.name}",
          "Endorse group Administrators to manage remote-peering-to in tenancy Acceptor"
        ]
      }
    }
  } : null

  cross_tenancy_service_connector_policies_configuration = var.enable_service_deployment && var.home_region_deployment && var.enable_logging_compartment ? {
    supplied_policies : {
      "CROSS-TENANCY-SERVICE-CONNECTOR-POLICY" : {
        name : "OCI-SCCA-LZ-Service-Connector-Remote-Logging-Policy-${var.resource_label}"
        description : "OCI SCCA Landing Zone Service Connector From Local Logging to Remote Bucket"
        compartment_id : "TENANCY-ROOT"
        statements : [
          "Define tenancy DestinationTenancy as ${var.parent_tenancy_ocid}",
          "Endorse any-user to manage object-family in tenancy DestinationTenancy where all { request.principal.type='serviceconnector' }",
        ]
      }
    }
  } : null
}

module "scca_identity_domains" {
  count                                = var.home_region_deployment ? 1 : 0
  source                               = "./modules/identity-domains"

  compartments_dependency              = module.scca_compartments[0].compartments
  tenancy_ocid                         = var.tenancy_ocid
  identity_domains_configuration       = local.identity_domains_configuration
  identity_domain_groups_configuration = local.identity_domain_groups_configuration
}

module "sccalz_policies" {
  count                   = var.home_region_deployment ? 1 : 0
  source                  = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam//policies?ref=v0.2.2"

  tenancy_ocid            = var.tenancy_ocid
  policies_configuration  = local.policies_configuration
  compartments_dependency = module.scca_compartments[0].compartments
}

module "key_policy" {
  count                   = var.home_region_deployment ? 1 : 0
  source                  = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam//policies?ref=v0.2.2"

  tenancy_ocid            = var.tenancy_ocid
  compartments_dependency = module.scca_compartments[0].compartments
  policies_configuration  = local.key_policies_configuration
  depends_on              = [module.central_vault_and_key.keys]
}

module "bucket_replication_policy" {
  count                   = var.home_region_deployment && var.enable_logging_compartment ? 1 : 0
  source                  = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam//policies?ref=v0.2.2"

  tenancy_ocid            = var.tenancy_ocid
  compartments_dependency = module.scca_compartments[0].compartments
  policies_configuration  = local.bucket_replication_policies_configuration
}

module "rpc_requestor_policy" {
  count                   = var.home_region_deployment && var.enable_service_deployment ? 1 : 0
  source                  = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam//policies?ref=v0.2.2"
  tenancy_ocid            = var.tenancy_ocid
  compartments_dependency = module.scca_compartments[0].compartments
  policies_configuration  = local.rpc_requester_policies_configuration
}

module "cross_tenancy_service_connector_policy" {
  count                  = var.home_region_deployment && var.enable_logging_compartment && var.enable_service_deployment ? 1 : 0
  source                 = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam//policies?ref=v0.2.2"
  
  tenancy_ocid           = var.tenancy_ocid
  policies_configuration = local.cross_tenancy_service_connector_policies_configuration
}
