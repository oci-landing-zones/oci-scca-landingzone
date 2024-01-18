# ###################################################################################################### #
# Copyright (c) 2023 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

locals {

  // TODO: need backup bucket spec
  backup_bucket = {
    name                                = "${var.backup_bucket_name}-${var.resource_label}"
    description                         = "Backup bucket"
    retention_rule_display_name         = "backup bucket retention rule"
    retention_policy_duration_amount    = "1"
    retention_policy_duration_time_unit = "DAYS"
  }

  audit_log_bucket = {
    name                                = "auditLogs_archive-${var.resource_label}"
    description                         = "Audit Log bucket"
    retention_rule_display_name         = "audit log bucket retention rule"
    retention_policy_duration_amount    = var.retention_policy_duration_amount
    retention_policy_duration_time_unit = var.retention_policy_duration_time_unit
  }

  default_log_bucket = {
    name                                = "defaultLogs_archive-${var.resource_label}"
    description                         = "Default Log bucket"
    retention_rule_display_name         = "default log bucket retention rule"
    retention_policy_duration_amount    = var.retention_policy_duration_amount
    retention_policy_duration_time_unit = var.retention_policy_duration_time_unit
  }

  service_event_log_bucket = {
    name                                = "serviceEvents_archive-${var.resource_label}"
    description                         = "Service Events Log bucket"
    retention_rule_display_name         = "service events log bucket retention rule"
    retention_policy_duration_amount    = var.retention_policy_duration_amount
    retention_policy_duration_time_unit = var.retention_policy_duration_time_unit
  }

  central_vault = {
    name                     = "${var.central_vault_name}-${var.resource_label}"
    type                     = var.central_vault_type
    enable_vault_replication = var.enable_vault_replication
    replica_region           = var.secondary_region
  }

  default_log_group = {
    name        = "Default_Group"
    description = "**Default log group for ${var.resource_label}"
  }

  master_encryption_key = {
    name            = "${var.master_encryption_key_name}-${var.resource_label}"
    algorithm       = "AES"
    length          = 32
    protection_mode = "HSM"
  }

  service_event_stream = {
    stream_pool_name       = "services-events-pool"
    stream_name            = "serviceEvents"
    stream_partitions      = 1
    rule_action_type       = "OSS"
    rule_action_is_enabled = true
    rule_condition         = "{ }" // MATCH ALL EVENTS IN THIS COMPARTMENT HIERARCHY
    rule_display_name      = "All events in ${var.vdms_compartment_name}-${local.region_key[0]}-${var.resource_label}"
    rule_is_enabled        = true
  }

  cloud_guard = {
    display_name                               = "OCI-SCCA-LZ-Cloud-Guard-${var.resource_label}"
    status                                     = "ENABLED"
    target_resource_type                       = "COMPARTMENT"
    description                                = "OCI SCCA LZ Cloud Guard Target"
    configuration_detector_recipe_display_name = "OCI Configuration Detector Recipe"
    activity_detector_recipe_display_name      = "OCI Activity Detector Recipe"
    threat_detector_recipe_display_name        = "OCI Threat Detector Recipe"
    responder_recipe_display_name              = "OCI Responder Recipe"
  }

  lb_access_log = {
    log_display_name    = "OCI-SCCA-LZ-LB-ACCESS-LOG-${var.resource_label}"
    log_type            = "SERVICE"
    log_source_category = "access"
    log_source_service  = "loadbalancer"
    log_source_type     = "OCISERVICE"
  }

  lb_error_log = {
    log_display_name    = "OCI-SCCA-LZ-LB-ERROR-LOG-${var.resource_label}"
    log_type            = "SERVICE"
    log_source_category = "error"
    log_source_service  = "loadbalancer"
    log_source_type     = "OCISERVICE"
  }

  os_write_log = {
    log_display_name    = "OCI-SCCA-LZ-OS-WRITE-LOG-${var.resource_label}"
    log_type            = "SERVICE"
    log_source_resource = "serviceEvents_archive-${var.resource_label}"
    log_source_category = "write"
    log_source_service  = "objectstorage"
    log_source_type     = "OCISERVICE"
  }

  os_read_log = {
    log_display_name    = "OCI-SCCA-LZ-OS-READ-LOG-${var.resource_label}"
    log_type            = "SERVICE"
    log_source_resource = "serviceEvents_archive-${var.resource_label}"
    log_source_category = "read"
    log_source_service  = "objectstorage"
    log_source_type     = "OCISERVICE"
  }

  vss_log = {
    log_display_name    = "OCI-SCCA-LZ-VSS-LOG-${var.resource_label}"
    log_type            = "SERVICE"
    log_source_resource = module.vdms_network.subnets["OCI-SCCA-LZ-VDMS-SUB-${local.region_key[0]}"]
    log_source_category = "all"
    log_source_service  = "flowlogs"
    log_source_type     = "OCISERVICE"
  }

  waf_log = {
    log_display_name    = "OCI-SCCA-LZ-WAF-LOG-${var.resource_label}"
    log_type            = "SERVICE"
    log_source_category = "all"
    log_source_service  = "waf"
    log_source_type     = "OCISERVICE"
  }

  event_log = {
    log_display_name    = "OCI-SCCA-LZ-EVENT-LOG-${var.resource_label}"
    log_type            = "SERVICE"
    log_source_category = "ruleexecutionlog"
    log_source_resource = module.service_event_stream.event_rule_id
    log_source_service  = "cloudevents"
    log_source_type     = "OCISERVICE"
  }

  firewall_threat_log = {
    log_display_name    = "OCI-SCCA-LZ-NFW-THREAT-LOG-${var.resource_label}"
    log_type            = "SERVICE"
    log_source_category = "threatlog"
    log_source_resource = module.network_firewall.firewall_id
    log_source_service  = "ocinetworkfirewall"
    log_source_type     = "OCISERVICE"
  }

  firewall_traffic_log = {
    log_display_name    = "OCI-SCCA-LZ-NFW-TRAFFIC-LOG-${var.resource_label}"
    log_type            = "SERVICE"
    log_source_category = "trafficlog"
    log_source_resource = module.network_firewall.firewall_id
    log_source_service  = "ocinetworkfirewall"
    log_source_type     = "OCISERVICE"
  }


  audit_log_service_connector = {
    display_name = "schAuditLog_archive"
    source_kind  = "logging"
    target_kind  = "objectStorage"
    log_group_id = "_Audit_Include_Subcompartment"
    # auditLogs_archive bucket
    target_bucket    = var.enable_logging_compartment ? local.audit_log_bucket.name : var.remote_audit_log_bucket_name
    target_namespace = var.enable_logging_compartment ? "" : var.remote_namespace
  }

  default_log_service_connector = {
    display_name = "schDefaultLog_archive"
    source_kind  = "logging"
    target_kind  = "objectStorage"
    # defaultLogs_archive bucket
    target_bucket    = var.enable_logging_compartment ? local.default_log_bucket.name : var.remote_default_log_bucket_name
    target_namespace = var.enable_logging_compartment ? "" : var.remote_namespace
  }

  service_events_service_connector = {
    display_name = "schServiceEvents_archive"
    source_kind  = "streaming"
    target_kind  = "objectStorage"
    # schServiceEvents_archive bucket
    target_bucket    = var.enable_logging_compartment ? local.service_event_log_bucket.name : var.remote_service_event_bucket_name
    target_namespace = var.enable_logging_compartment ? "" : var.remote_namespace
  }

  bastion = {
    name                                 = "OCI-SCCA-LZ-BASTION-${var.resource_label}"
    bastion_client_cidr_block_allow_list = var.bastion_client_cidr_block_allow_list
    target_subnet_id                     = module.workload_network.subnets["OCI-SCCA-LZ-Workload-SUB-${var.workload_name}-${local.region_key[0]}"]
  }
}

module "backup_bucket" {
  source                              = "./modules/bucket"
  count                               = var.home_region_deployment ? 1 : 0
  tenancy_ocid                        = var.tenancy_ocid
  compartment_id                      = module.backup_compartment[0].compartment_id
  name                                = local.backup_bucket.name
  kms_key_id                          = ""
  storage_tier                        = var.bucket_storage_tier
  retention_rule_display_name         = local.backup_bucket.retention_rule_display_name
  retention_policy_duration_amount    = local.backup_bucket.retention_policy_duration_amount
  retention_policy_duration_time_unit = local.backup_bucket.retention_policy_duration_time_unit
  depends_on                          = [time_sleep.compartment_replication_delay]

  providers = {
    oci                  = oci
    oci.secondary_region = oci.secondary_region
  }
}

module "audit_log_bucket" {
  count                               = var.enable_logging_compartment ? 1 : 0
  source                              = "./modules/bucket"
  tenancy_ocid                        = var.tenancy_ocid
  compartment_id                      = var.home_region_deployment ? module.logging_compartment[0].compartment_id : var.multi_region_logging_compartment_ocid
  name                                = local.audit_log_bucket.name
  kms_key_id                          = module.master_encryption_key.key_ocid
  storage_tier                        = var.bucket_storage_tier
  retention_rule_display_name         = local.audit_log_bucket.retention_rule_display_name
  retention_policy_duration_amount    = local.audit_log_bucket.retention_policy_duration_amount
  retention_policy_duration_time_unit = local.audit_log_bucket.retention_policy_duration_time_unit
  enable_replication                  = var.enable_bucket_replication
  replica_region                      = var.secondary_region

  depends_on = [module.key_policy]

  providers = {
    oci                  = oci
    oci.secondary_region = oci.secondary_region
  }
}

module "default_log_bucket" {
  count                               = var.enable_logging_compartment ? 1 : 0
  source                              = "./modules/bucket"
  tenancy_ocid                        = var.tenancy_ocid
  compartment_id                      = var.home_region_deployment ? module.logging_compartment[0].compartment_id : var.multi_region_logging_compartment_ocid
  name                                = local.default_log_bucket.name
  kms_key_id                          = module.master_encryption_key.key_ocid
  storage_tier                        = var.bucket_storage_tier
  retention_rule_display_name         = local.default_log_bucket.retention_rule_display_name
  retention_policy_duration_amount    = local.default_log_bucket.retention_policy_duration_amount
  retention_policy_duration_time_unit = local.default_log_bucket.retention_policy_duration_time_unit
  enable_replication                  = var.enable_bucket_replication
  replica_region                      = var.secondary_region

  depends_on = [module.key_policy]

  providers = {
    oci                  = oci
    oci.secondary_region = oci.secondary_region
  }
}

module "service_event_log_bucket" {
  count                               = var.enable_logging_compartment ? 1 : 0
  source                              = "./modules/bucket"
  tenancy_ocid                        = var.tenancy_ocid
  compartment_id                      = var.home_region_deployment ? module.logging_compartment[0].compartment_id : var.multi_region_logging_compartment_ocid
  name                                = local.service_event_log_bucket.name
  kms_key_id                          = module.master_encryption_key.key_ocid
  storage_tier                        = var.bucket_storage_tier
  retention_rule_display_name         = local.service_event_log_bucket.retention_rule_display_name
  retention_policy_duration_amount    = local.service_event_log_bucket.retention_policy_duration_amount
  retention_policy_duration_time_unit = local.service_event_log_bucket.retention_policy_duration_time_unit
  enable_replication                  = var.enable_bucket_replication
  replica_region                      = var.secondary_region

  depends_on = [module.key_policy]

  providers = {
    oci                  = oci
    oci.secondary_region = oci.secondary_region
  }
}

module "central_vault" {
  source                   = "./modules/vault"
  compartment_id           = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.multi_region_vdms_compartment_ocid
  display_name             = local.central_vault.name
  vault_type               = local.central_vault.type
  enable_vault_replication = local.central_vault.enable_vault_replication
  replica_region           = local.central_vault.replica_region
}

module "default_log_group" {
  source         = "./modules/log_group"
  compartment_id = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.multi_region_vdms_compartment_ocid
  display_name   = local.default_log_group.name
  description    = local.default_log_group.description
}

module "master_encryption_key" {
  source              = "./modules/key"
  compartment_ocid    = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.multi_region_vdms_compartment_ocid
  display_name        = local.master_encryption_key.name
  shape_algorithm     = local.master_encryption_key.algorithm
  shape_length        = local.master_encryption_key.length
  protection_mode     = local.master_encryption_key.protection_mode
  management_endpoint = module.central_vault.management_endpoint
  depends_on          = [module.cloud_guard]
}

module "service_event_stream" {
  source                 = "./modules/stream"
  compartment_id         = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.multi_region_vdms_compartment_ocid
  stream_pool_name       = local.service_event_stream.stream_pool_name
  stream_name            = local.service_event_stream.stream_name
  kms_key_id             = module.master_encryption_key.key_ocid
  stream_partitions      = local.service_event_stream.stream_partitions
  rule_action_type       = local.service_event_stream.rule_action_type
  rule_action_is_enabled = local.service_event_stream.rule_action_is_enabled
  rule_condition         = local.service_event_stream.rule_condition
  rule_display_name      = local.service_event_stream.rule_display_name
  rule_is_enabled        = local.service_event_stream.rule_is_enabled
}

module "default_log_service_connector" {
  source                = "./modules/service-connector"
  tenancy_ocid          = var.tenancy_ocid
  compartment_id        = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.multi_region_vdms_compartment_ocid
  source_compartment_id = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.multi_region_vdms_compartment_ocid
  display_name          = local.default_log_service_connector.display_name
  source_kind           = local.default_log_service_connector.source_kind
  target_kind           = local.default_log_service_connector.target_kind
  log_group_id          = module.default_log_group.log_group_id
  target_bucket         = local.default_log_service_connector.target_bucket
  target_namespace      = local.default_log_service_connector.target_namespace
  # Service connector needs at least one log on the log group, or it errors.
  # Also it takes time for it to recognize this.
  depends_on = [
    time_sleep.first_log_delay
  ]
}

module "audit_log_service_connector" {
  source                = "./modules/service-connector"
  tenancy_ocid          = var.tenancy_ocid
  compartment_id        = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.multi_region_vdms_compartment_ocid
  source_compartment_id = var.home_region_deployment ? module.home_compartment[0].compartment_id : var.multi_region_home_compartment_ocid
  display_name          = local.audit_log_service_connector.display_name
  source_kind           = local.audit_log_service_connector.source_kind
  target_kind           = local.audit_log_service_connector.target_kind
  log_group_id          = local.audit_log_service_connector.log_group_id
  target_bucket         = local.audit_log_service_connector.target_bucket
  target_namespace      = local.audit_log_service_connector.target_namespace
}

module "service_events_service_connector" {
  source                = "./modules/service-connector"
  tenancy_ocid          = var.tenancy_ocid
  compartment_id        = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.multi_region_vdms_compartment_ocid
  source_compartment_id = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.multi_region_vdms_compartment_ocid
  display_name          = local.service_events_service_connector.display_name
  source_kind           = local.service_events_service_connector.source_kind
  target_kind           = local.service_events_service_connector.target_kind
  stream_id             = module.service_event_stream.stream_id
  cursor_kind           = "TRIM_HORIZON"
  target_bucket         = local.service_events_service_connector.target_bucket
  target_namespace      = local.service_events_service_connector.target_namespace
}

locals {
  svc_conn_policy_std_statements = [
    "Allow any-user to read log-content in compartment id ${var.home_region_deployment ? module.home_compartment[0].compartment_id : var.multi_region_home_compartment_ocid} where all {request.principal.type='serviceconnector'}",
    "Allow any-user to read log-groups in compartment id ${var.home_region_deployment ? module.home_compartment[0].compartment_id : var.multi_region_home_compartment_ocid} where all {request.principal.type='serviceconnector'}",
    "Allow any-user to {STREAM_READ, STREAM_CONSUME} in compartment id ${var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.multi_region_vdms_compartment_ocid} where all {request.principal.type='serviceconnector', target.stream.id='${module.service_event_stream.stream_id}', request.principal.compartment.id='${var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.multi_region_vdms_compartment_ocid}'}",
  ]
  svc_conn_policy_log_comp_statements = var.enable_logging_compartment ? [
    "Allow any-user to manage objects in compartment id ${var.home_region_deployment ? module.logging_compartment[0].compartment_id : var.multi_region_logging_compartment_ocid} where all {request.principal.type='serviceconnector', target.bucket.name='*_archive', request.principal.compartment.id='${var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.multi_region_vdms_compartment_ocid}'}",
    "Allow any-user to manage objects in compartment id ${var.home_region_deployment ? module.logging_compartment[0].compartment_id : var.multi_region_logging_compartment_ocid} where all {request.principal.type='serviceconnector', any{target.bucket.name='${local.audit_log_bucket.name}', target.bucket.name='${local.default_log_bucket.name}', target.bucket.name='${local.service_event_log_bucket.name}'}, request.principal.compartment.id='${var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.multi_region_vdms_compartment_ocid}'}",
  ] : []

  service_connector_policy = {
    name        = "OCI-SCCA-LZ-Service-Connector-Policy"
    description = "OCI SCCA Landing Zone Service Connector Policy"
    statements  = concat(local.svc_conn_policy_std_statements, local.svc_conn_policy_log_comp_statements)
  }
}

module "service_connector_policy" {
  source = "./modules/policies"

  count            = var.home_region_deployment ? 1 : 0
  compartment_ocid = var.home_region_deployment ? module.home_compartment[0].compartment_id : var.multi_region_home_compartment_ocid
  policy_name      = local.service_connector_policy.name
  description      = local.service_connector_policy.description
  statements       = local.service_connector_policy.statements
}

module "cloud_guard" {
  source = "./modules/cloud-guard"
  count                                      = var.home_region_deployment ? 1 : 0
  tenancy_ocid                               = var.tenancy_ocid
  region                                     = var.region
  status                                     = local.cloud_guard.status
  compartment_id                             = var.cloud_guard_target_tenancy ? var.tenancy_ocid : var.home_region_deployment ? module.home_compartment[0].compartment_id : var.multi_region_home_compartment_ocid
  display_name                               = local.cloud_guard.display_name
  target_resource_id                         = var.cloud_guard_target_tenancy ? var.tenancy_ocid : var.home_region_deployment ? module.home_compartment[0].compartment_id : var.multi_region_home_compartment_ocid
  target_resource_type                       = local.cloud_guard.target_resource_type
  description                                = local.cloud_guard.description
  configuration_detector_recipe_display_name = local.cloud_guard.configuration_detector_recipe_display_name
  activity_detector_recipe_display_name      = local.cloud_guard.activity_detector_recipe_display_name
  threat_detector_recipe_display_name        = local.cloud_guard.threat_detector_recipe_display_name
  responder_recipe_display_name              = local.cloud_guard.responder_recipe_display_name
  depends_on = [
    module.cloud_guard_policy
  ]

  providers = {
    oci.home_region = oci.home_region
  }
}

locals {
  vss_policy = {
    name        = "OCI-SCCA-LZ-Scanning-Service-Policy"
    description = "OCI SCCA Landing Zone VSS Policy"

    statements = [
      "Allow service vulnerability-scanning-service to manage instances in compartment ${var.home_compartment_name}-${local.region_key[0]}-${var.resource_label}",
      "Allow service vulnerability-scanning-service to read compartments in compartment ${var.home_compartment_name}-${local.region_key[0]}-${var.resource_label}",
      "Allow service vulnerability-scanning-service to read vnics in compartment ${var.home_compartment_name}-${local.region_key[0]}-${var.resource_label}",
      "Allow service vulnerability-scanning-service to read vnic-attachments in compartment ${var.home_compartment_name}-${local.region_key[0]}-${var.resource_label}",
    ]
  }

  # -----------------------------------------------------------------------------
  # Create VSS Resources
  # -----------------------------------------------------------------------------
  vss = {
    host_scan_recipe_display_name              = "OCI-SCCA-LZ-Scanning-Service-Recipe"
    host_scan_target_display_name              = "OCI-SCCA-LZ-Scanning-Service-Target"
    host_scan_recipe_agent_settings_scan_level = "STANDARD"
    host_scan_recipe_port_settings_scan_level  = "STANDARD"
    agent_cis_benchmark_settings_scan_level    = "STRICT"
    vss_scan_schedule                          = "DAILY"
  }
}

module "vss_policy" {
  source = "./modules/policies"

  count            = var.home_region_deployment ? 1 : 0
  compartment_ocid = var.home_region_deployment ? module.home_compartment[0].compartment_id : var.multi_region_home_compartment_ocid
  policy_name      = local.vss_policy.name
  description      = local.vss_policy.description
  statements       = local.vss_policy.statements
}

module "vss" { # WAS THE SPEC ASKING TO CREATE A VSS TARGET AS WELL?
  source = "./modules/vss"

  compartment_ocid                           = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.multi_region_vdms_compartment_ocid
  target_compartment_ocid                    = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.multi_region_vdms_compartment_ocid
  host_scan_recipe_agent_settings_scan_level = local.vss.host_scan_recipe_agent_settings_scan_level
  host_scan_recipe_port_settings_scan_level  = local.vss.host_scan_recipe_port_settings_scan_level
  agent_cis_benchmark_settings_scan_level    = local.vss.agent_cis_benchmark_settings_scan_level
  vss_scan_schedule                          = local.vss.vss_scan_schedule
  host_scan_recipe_display_name              = local.vss.host_scan_recipe_display_name
  host_scan_target_display_name              = local.vss.host_scan_target_display_name
}

# -----------------------------------------------------------------------------
# Create OS Management Group and Policies
# -----------------------------------------------------------------------------
locals {
  osms_dg_policy = {
    name        = "OCI-SCCA-LZ-OSMS-DG-Policy"
    description = "OCI SCCA Landing Zone OS Management Service Dynamic Group Policy"

    statements = [
      # "Allow dynamic-group ${module.osms_dynamic_group.name} to read instance-family in compartment ${module.home_compartment[0].compartment_name}",
      # "Allow dynamic-group ${module.osms_dynamic_group.name} to use osms-managed-instances in compartment ${module.home_compartment[0].compartment_name}"
      "Allow dynamic-group ${local.identity_domain.dynamic_groups.osms_dynamic_group.dynamic_group_name} to read instance-family in compartment ${var.home_compartment_name}-${local.region_key[0]}-${var.resource_label}",
      "Allow dynamic-group ${local.identity_domain.dynamic_groups.osms_dynamic_group.dynamic_group_name} to use osms-managed-instances in compartment ${var.home_compartment_name}-${local.region_key[0]}-${var.resource_label}"
    ]
  }

  osms_policy = {
    name        = "OCI-SCCA-LZ-OSMS-Policy-${var.resource_label}"
    description = "OCI SCCA Landing Zone OSMS Management Service Policy"

    statements = [
      "Allow service osms to read instances in tenancy",
    ]
  }
}

module "osms_policy" {
  source = "./modules/policies"

  count            = var.home_region_deployment ? 1 : 0
  compartment_ocid = var.tenancy_ocid
  policy_name      = local.osms_policy.name
  description      = local.osms_policy.description
  statements       = local.osms_policy.statements
}

module "osms_dg_policy" {
  source = "./modules/policies"

  count            = var.home_region_deployment ? 1 : 0
  compartment_ocid = var.home_region_deployment ? module.home_compartment[0].compartment_id : var.multi_region_home_compartment_ocid
  policy_name      = local.osms_dg_policy.name
  description      = local.osms_dg_policy.description
  statements       = local.osms_dg_policy.statements
}

module "lb_access_log" {
  source = "./modules/service-log"

  log_display_name    = local.lb_access_log.log_display_name
  log_type            = local.lb_access_log.log_type
  log_group_id        = module.default_log_group.log_group_id
  log_source_category = local.lb_access_log.log_source_category
  log_source_resource = module.vdms_load_balancer.lb_id
  log_source_service  = local.lb_access_log.log_source_service
  log_source_type     = local.lb_access_log.log_source_type
}

module "lb_error_log" {
  source = "./modules/service-log"

  log_display_name    = local.lb_error_log.log_display_name
  log_type            = local.lb_error_log.log_type
  log_group_id        = module.default_log_group.log_group_id
  log_source_category = local.lb_error_log.log_source_category
  log_source_resource = module.vdms_load_balancer.lb_id
  log_source_service  = local.lb_error_log.log_source_service
  log_source_type     = local.lb_error_log.log_source_type
}

module "os_write_log" {
  source = "./modules/service-log"

  log_display_name    = local.os_write_log.log_display_name
  log_type            = local.os_write_log.log_type
  log_group_id        = module.default_log_group.log_group_id
  log_source_category = local.os_write_log.log_source_category
  log_source_resource = local.os_write_log.log_source_resource
  log_source_service  = local.os_write_log.log_source_service
  log_source_type     = local.os_write_log.log_source_type

  depends_on = [module.service_event_log_bucket]
}

module "os_read_log" {
  source = "./modules/service-log"

  log_display_name    = local.os_read_log.log_display_name
  log_type            = local.os_read_log.log_type
  log_group_id        = module.default_log_group.log_group_id
  log_source_category = local.os_read_log.log_source_category
  log_source_resource = local.os_read_log.log_source_resource
  log_source_service  = local.os_read_log.log_source_service
  log_source_type     = local.os_read_log.log_source_type

  depends_on = [module.service_event_log_bucket]
}

module "vss_log" {
  source = "./modules/service-log"

  log_display_name    = local.vss_log.log_display_name
  log_type            = local.vss_log.log_type
  log_group_id        = module.default_log_group.log_group_id
  log_source_category = local.vss_log.log_source_category
  log_source_resource = local.vss_log.log_source_resource
  log_source_service  = local.vss_log.log_source_service
  log_source_type     = local.vss_log.log_source_type
}

module "waf_log" {
  source = "./modules/service-log"

  log_display_name    = local.waf_log.log_display_name
  log_type            = local.waf_log.log_type
  log_group_id        = module.default_log_group.log_group_id
  log_source_category = local.waf_log.log_source_category
  log_source_resource = module.vdms_load_balancer.waf_id
  log_source_service  = local.waf_log.log_source_service
  log_source_type     = local.waf_log.log_source_type
}

module "event_log" {
  source = "./modules/service-log"

  log_display_name    = local.event_log.log_display_name
  log_type            = local.event_log.log_type
  log_group_id        = module.default_log_group.log_group_id
  log_source_category = local.event_log.log_source_category
  log_source_resource = local.event_log.log_source_resource
  log_source_service  = local.event_log.log_source_service
  log_source_type     = local.event_log.log_source_type

  depends_on = [module.service_event_stream]
}

resource "time_sleep" "first_log_delay" {
  depends_on      = [module.event_log]
  create_duration = "90s"
}

module "firewall_threat_log" {
  source = "./modules/service-log"

  log_display_name    = local.firewall_threat_log.log_display_name
  log_type            = local.firewall_threat_log.log_type
  log_group_id        = module.default_log_group.log_group_id
  log_source_category = local.firewall_threat_log.log_source_category
  log_source_resource = local.firewall_threat_log.log_source_resource
  log_source_service  = local.firewall_threat_log.log_source_service
  log_source_type     = local.firewall_threat_log.log_source_type
}

module "firewall_traffic_log" {
  source = "./modules/service-log"

  log_display_name    = local.firewall_traffic_log.log_display_name
  log_type            = local.firewall_traffic_log.log_type
  log_group_id        = module.default_log_group.log_group_id
  log_source_category = local.firewall_traffic_log.log_source_category
  log_source_resource = local.firewall_traffic_log.log_source_resource
  log_source_service  = local.firewall_traffic_log.log_source_service
  log_source_type     = local.firewall_traffic_log.log_source_type
}

module "bastion" {
  source = "./modules/bastion"

  compartment_id                       = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.multi_region_vdms_compartment_ocid
  target_subnet_id                     = local.bastion.target_subnet_id
  bastion_client_cidr_block_allow_list = local.bastion.bastion_client_cidr_block_allow_list
  bastion_name                         = local.bastion.name
}
