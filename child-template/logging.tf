# ###################################################################################################### #
# Copyright (c) 2023 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #
locals {
  nfw_forwarding_ip_ocid = [try(module.scca_networking_firewall[0].provisioned_networking_resources.oci_network_firewall_network_firewalls["CHILD-NFW-KEY"].id, ""), ""][var.enable_network_firewall ? 0 : 1]

  single_default_log_group_name    = "DEFAULT_LOG_GROUP_NAME"
  single_lb_access_log_name        = "OCI-SCCA-LZ-LB-ACCESS-LOG"
  single_lb_error_log_name         = "OCI-SCCA-LZ-LB-ERROR-LOG"
  single_os_write_log_name         = "OCI-SCCA-LZ-OS-WRITE-LOG"
  single_os_read_log_name          = "OCI-SCCA-LZ-OS-READ-LOG"
  single_vss_log_name              = "OCI-SCCA-LZ-VSS-LOG"
  single_waf_log_name              = "OCI-SCCA-LZ-WAF-LOG"
  single_event_log_name            = "OCI-SCCA-LZ-EVENT-LOG"
  single_firewall_threat_log_name  = "OCI-SCCA-LZ-NFW-THREAT-LOG"
  single_firewall_traffic_log_name = "OCI-SCCA-LZ-NFW-TRAFFIC-LOG"
  single_backup_bucket_name        = "OCI-SCCA-LZ-BACKUP"

  logging_configuration_nfw = {
    default_compartment_id = var.enable_logging_compartment && var.home_region_deployment ? module.scca_compartments[0].compartments["SCCA_CHILD_LOGGING_CMP"].id : var.multi_region_logging_compartment_ocid

    log_groups = {
      DEFAULT_LOG_GROUP = {
        name           = var.deployment_type == "SINGLE" ? "${local.single_default_log_group_name}-${var.resource_label}" : "${var.default_log_group_name}-${var.resource_label}"
        compartment_id = var.enable_logging_compartment && var.home_region_deployment ? module.scca_compartments[0].compartments["SCCA_CHILD_LOGGING_CMP"].id : var.multi_region_logging_compartment_ocid
        description    = "${var.default_log_group_desc}-${var.resource_label}"
      }
    }
    service_logs = {
      LB_ACCESS_LOG = {
        name         = var.deployment_type == "SINGLE" ? "${local.single_lb_access_log_name}-${var.resource_label}" : "${var.lb_access_log_name}-${var.resource_label}"
        log_group_id = "DEFAULT_LOG_GROUP"
        log_type     = "${var.lb_access_log_type}"
        category     = "${var.lb_access_log_category}"
        resource_id  = module.scca_networking_lb.provisioned_networking_resources.l7_load_balancers.l7_load_balancers["CHILD-VDMS-LB"].id
        service      = "${var.lb_access_log_service}"
      }
      LB_ERROR_LOG = {
        name         = var.deployment_type == "SINGLE" ? "${local.single_lb_error_log_name}-${var.resource_label}" : "${var.lb_error_log_name}-${var.resource_label}"
        log_group_id = "DEFAULT_LOG_GROUP"
        log_type     = "${var.lb_error_log_type}"
        category     = "${var.lb_error_log_category}"
        resource_id  = module.scca_networking_lb.provisioned_networking_resources.l7_load_balancers.l7_load_balancers["CHILD-VDMS-LB"].id
        service      = "${var.lb_error_log_service}"
      }
      OS_WRITE_LOG = {
        name         = var.deployment_type == "SINGLE" ? "${local.single_os_write_log_name}-${var.resource_label}" : "${var.os_write_log_name}-${var.resource_label}"
        log_group_id = "DEFAULT_LOG_GROUP"
        log_type     = "${var.os_write_log_type}"
        category     = "${var.os_write_log_category}"
        resource_id  = local.service_event_log_bucket.name
        service      = "${var.os_write_log_service}"
      }
      OS_READ_LOG = {
        name         = var.deployment_type == "SINGLE" ? "${local.single_os_read_log_name}-${var.resource_label}" : "${var.os_read_log_name}-${var.resource_label}"
        log_group_id = "DEFAULT_LOG_GROUP"
        log_type     = "${var.os_read_log_type}"
        category     = "${var.os_read_log_category}"
        resource_id  = local.service_event_log_bucket.name
        service      = "${var.os_read_log_service}"
      }
      VSS_LOG = {
        name         = var.deployment_type == "SINGLE" ? "${local.single_vss_log_name}-${var.resource_label}" : "${var.vss_log_name}-${var.resource_label}"
        log_group_id = "DEFAULT_LOG_GROUP"
        log_type     = "${var.vss_log_type}"
        category     = "${var.vss_log_category}"
        resource_id  = module.scca_networking.provisioned_networking_resources.subnets["CHILD-VDMS-SUBNET"].id
        service      = "${var.vss_log_service}"
      }
      EVENT_LOG = {
        name         = var.deployment_type == "SINGLE" ? "${local.single_event_log_name}-${var.resource_label}" : "${var.event_log_name}-${var.resource_label}"
        log_group_id = "DEFAULT_LOG_GROUP"
        log_type     = "${var.event_log_type}"
        category     = "${var.event_log_category}"
        resource_id  = module.service_events.events["SERVICE-EVENT-RULE"].id
        service      = "${var.event_log_service}"
      }
      FIREWALL_THREAT_LOG = {
        name         = var.deployment_type == "SINGLE" ? "${local.single_firewall_threat_log_name}-${var.resource_label}" : "${var.firewall_threat_log_name}-${var.resource_label}"
        log_group_id = "DEFAULT_LOG_GROUP"
        log_type     = "${var.firewall_threat_log_type}"
        category     = "${var.firewall_threat_log_category}"
        resource_id  = local.nfw_forwarding_ip_ocid
        service      = "${var.firewall_threat_log_service}"
      }
      FIREWALL_TRAFFIC_LOG = {
        name         = var.deployment_type == "SINGLE" ? "${local.single_firewall_traffic_log_name}-${var.resource_label}" : "${var.firewall_traffic_log_name}-${var.resource_label}"
        log_group_id = "DEFAULT_LOG_GROUP"
        log_type     = "${var.firewall_traffic_log_type}"
        category     = "${var.firewall_traffic_log_category}"
        resource_id  = local.nfw_forwarding_ip_ocid
        service      = "${var.firewall_traffic_log_service}"
      }
    }
  }
  logging_configuration_no_nfw = {
    default_compartment_id = var.enable_logging_compartment && var.home_region_deployment ? module.scca_compartments[0].compartments["SCCA_CHILD_LOGGING_CMP"].id : var.multi_region_logging_compartment_ocid

    log_groups = {
      DEFAULT_LOG_GROUP = {
        name           = var.deployment_type == "SINGLE" ? "${local.single_default_log_group_name}-${var.resource_label}" : "${var.default_log_group_name}-${var.resource_label}"
        compartment_id = var.enable_logging_compartment && var.home_region_deployment ? module.scca_compartments[0].compartments["SCCA_CHILD_LOGGING_CMP"].id : var.multi_region_logging_compartment_ocid
        description    = "${var.default_log_group_desc}-${var.resource_label}"
      }
    }
    service_logs = {
      LB_ACCESS_LOG = {
        name         = var.deployment_type == "SINGLE" ? "${local.single_lb_access_log_name}-${var.resource_label}" : "${var.lb_access_log_name}-${var.resource_label}"
        log_group_id = "DEFAULT_LOG_GROUP"
        log_type     = "${var.lb_access_log_type}"
        category     = "${var.lb_access_log_category}"
        resource_id  = module.scca_networking_lb.provisioned_networking_resources.l7_load_balancers.l7_load_balancers["CHILD-VDMS-LB"].id
        service      = "${var.lb_access_log_service}"
      }
      LB_ERROR_LOG = {
        name         = var.deployment_type == "SINGLE" ? "${local.single_lb_error_log_name}-${var.resource_label}" : "${var.lb_error_log_name}-${var.resource_label}"
        log_group_id = "DEFAULT_LOG_GROUP"
        log_type     = "${var.lb_error_log_type}"
        category     = "${var.lb_error_log_category}"
        resource_id  = module.scca_networking_lb.provisioned_networking_resources.l7_load_balancers.l7_load_balancers["CHILD-VDMS-LB"].id
        service      = "${var.lb_error_log_service}"
      }
      OS_WRITE_LOG = {
        name         = var.deployment_type == "SINGLE" ? "${local.single_os_write_log_name}-${var.resource_label}" : "${var.os_write_log_name}-${var.resource_label}"
        log_group_id = "DEFAULT_LOG_GROUP"
        log_type     = "${var.os_write_log_type}"
        category     = "${var.os_write_log_category}"
        resource_id  = local.service_event_log_bucket.name
        service      = "${var.os_write_log_service}"
      }
      OS_READ_LOG = {
        name         = var.deployment_type == "SINGLE" ? "${local.single_os_read_log_name}-${var.resource_label}" : "${var.os_read_log_name}-${var.resource_label}"
        log_group_id = "DEFAULT_LOG_GROUP"
        log_type     = "${var.os_read_log_type}"
        category     = "${var.os_read_log_category}"
        resource_id  = local.service_event_log_bucket.name
        service      = "${var.os_read_log_service}"
      }
      VSS_LOG = {
        name         = var.deployment_type == "SINGLE" ? "${local.single_vss_log_name}-${var.resource_label}" : "${var.vss_log_name}-${var.resource_label}"
        log_group_id = "DEFAULT_LOG_GROUP"
        log_type     = "${var.vss_log_type}"
        category     = "${var.vss_log_category}"
        resource_id  = module.scca_networking.provisioned_networking_resources.subnets["CHILD-VDMS-SUBNET"].id
        service      = "${var.vss_log_service}"
      }
      EVENT_LOG = {
        name         = var.deployment_type == "SINGLE" ? "${local.single_event_log_name}-${var.resource_label}" : "${var.event_log_name}-${var.resource_label}"
        log_group_id = "DEFAULT_LOG_GROUP"
        log_type     = "${var.event_log_type}"
        category     = "${var.event_log_category}"
        resource_id  = module.service_events.events["SERVICE-EVENT-RULE"].id
        service      = "${var.event_log_service}"
      }
    }
  }
  vcn_flow_logging_configuration = {
    default_compartment_id = var.enable_logging_compartment && var.home_region_deployment ? module.scca_compartments[0].compartments["SCCA_CHILD_LOGGING_CMP"].id : var.multi_region_logging_compartment_ocid

    log_groups = {
      VCN-FLOW-LOG-GROUP = {
        name = var.deployment_type == "SINGLE" ? "vcn-flow-log-group" : "vcn-flow-child-log-group"
      }
    }
    flow_logs = {
      VCN-FLOW-LOGS = {
        log_group_id           = "VCN-FLOW-LOG-GROUP"
        target_compartment_ids = [module.scca_compartments[0].compartments["SCCA_CHILD_VDMS_CMP"].id]
        target_resource_type   = "vcn"
      }
    }
  }

  vcn_flow_log_service_connectors_configuration = {
    default_compartment_id = "SCCA_CHILD_VDMS_CMP"

    service_connectors = {
      VNC-FLOW-LOG-SERVICE-CONNECTOR = {
        display_name   = "schVCNFlowLog_archive"
        compartment_id = "SCCA_CHILD_VDMS_CMP"
        activate       = var.activate_service_connectors

        source = {
          kind = "logging"
          non_audit_logs = [{
            cmp_id       = "SCCA_CHILD_LOGGING_CMP",
            log_group_id = "VCN-FLOW-LOG-GROUP"
          }]
        }
        target = {
          kind                      = "objectstorage"
          bucket_name               = local.default_log_bucket.name
          bucket_object_name_prefix = "sch"
        }
        policy = {
          name           = "OCI-SCCA-LZ-Service-Connector-Policy-VCN-flow-log"
          description    = "OCI SCCA Landing Zone Service Connector VCN flow log Policy"
          compartment_id = "SCCA_CHILD_HOME_CMP"
        }
      }
    }
    buckets = {}
  }

  backup_bucket = {
    name                                = var.deployment_type == "SINGLE" ? "${local.single_backup_bucket_name}-${var.resource_label}" : "${var.backup_bucket_name}-${var.resource_label}"
    description                         = "Backup bucket"
    retention_rule_display_name         = "backup bucket retention rule"
    retention_policy_duration_amount    = var.retention_policy_duration_amount
    retention_policy_duration_time_unit = var.retention_policy_duration_time_unit
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

  svc_conn_policy_std_statements = [
    "Allow any-user to read log-content in compartment id ${var.home_region_deployment ? module.scca_compartments[0].compartments["SCCA_CHILD_HOME_CMP"].id : var.multi_region_home_compartment_ocid} where all {request.principal.type='serviceconnector'}",
    "Allow any-user to read log-groups in compartment id ${var.home_region_deployment ? module.scca_compartments[0].compartments["SCCA_CHILD_HOME_CMP"].id : var.multi_region_home_compartment_ocid} where all {request.principal.type='serviceconnector'}",
    "Allow any-user to {STREAM_READ, STREAM_CONSUME} in compartment id ${var.home_region_deployment ? module.scca_compartments[0].compartments["SCCA_CHILD_VDMS_CMP"].id : var.multi_region_vdms_compartment_ocid} where all {request.principal.type='serviceconnector', target.stream.id='${module.service_streams.streams["SERVICE-EVENT-STREAM"].id}', request.principal.compartment.id='${var.home_region_deployment ? module.scca_compartments[0].compartments["SCCA_CHILD_VDMS_CMP"].id : var.multi_region_vdms_compartment_ocid}'}",
  ]

  svc_conn_policy_log_comp_statements = var.enable_logging_compartment ? [
    "Allow any-user to manage objects in compartment id ${var.home_region_deployment ? module.scca_compartments[0].compartments["SCCA_CHILD_LOGGING_CMP"].id : var.multi_region_logging_compartment_ocid} where all {request.principal.type='serviceconnector', target.bucket.name='*_archive', request.principal.compartment.id='${var.home_region_deployment ? module.scca_compartments[0].compartments["SCCA_CHILD_VDMS_CMP"].id : var.multi_region_vdms_compartment_ocid}'}",
    "Allow any-user to manage objects in compartment id ${var.home_region_deployment ? module.scca_compartments[0].compartments["SCCA_CHILD_LOGGING_CMP"].id : var.multi_region_logging_compartment_ocid} where all {request.principal.type='serviceconnector', any{target.bucket.name='${local.audit_log_bucket.name}', target.bucket.name='${local.default_log_bucket.name}', target.bucket.name='${local.service_event_log_bucket.name}'}, request.principal.compartment.id='${var.home_region_deployment ? module.scca_compartments[0].compartments["SCCA_CHILD_VDMS_CMP"].id : var.multi_region_vdms_compartment_ocid}'}",
  ] : []

  service_connector_policy = {
    name        = "OCI-SCCA-LZ-Service-Connector-Policy"
    description = "OCI SCCA Landing Zone Service Connector Policy"
    statements  = concat(local.svc_conn_policy_std_statements, local.svc_conn_policy_log_comp_statements)
  }

  baseline_service_connectors = {
    DEFAULT-LOG-SERVICE-CONNECTOR = {
      display_name   = "schDefaultLog_archive"
      compartment_id = "SCCA_CHILD_VDMS_CMP"
      activate       = var.activate_service_connectors

      source = {
        kind = "logging"
        non_audit_logs = [{
          cmp_id       = "SCCA_CHILD_LOGGING_CMP",
          log_group_id = "DEFAULT_LOG_GROUP"
        }]
      }
      target = {
        kind                      = "objectstorage"
        bucket_name               = "DEFAULT-LOG-BUCKET"
        bucket_object_name_prefix = "sch"
      }
      policy = {
        name           = "OCI-SCCA-LZ-Service-Connector-Policy-default-log"
        description    = "OCI SCCA Landing Zone Service Connector Policy"
        compartment_id = "SCCA_CHILD_HOME_CMP"
      }
    }

    AUDIT-LOG-SERVICE-CONNECTOR = {
      display_name   = "schAuditLog_archive"
      compartment_id = "SCCA_CHILD_VDMS_CMP"
      activate       = var.activate_service_connectors

      source = {
        kind       = "logging"
        audit_logs = [{ cmp_id = "ALL" }]
      }
      target = {
        kind                      = "objectstorage"
        bucket_name               = "AUDIT-BUCKET"
        bucket_object_name_prefix = "sch"
      }
      policy = {
        name           = "OCI-SCCA-LZ-Service-Connector-Policy-audit-log"
        description    = "OCI SCCA Landing Zone Service Connector Policy"
        compartment_id = "SCCA_CHILD_HOME_CMP"
      }
    }

    SERVICE-EVENTS-SERVICE-CONNECTOR = {
      display_name   = "schServiceEvents_archive"
      compartment_id = "SCCA_CHILD_VDMS_CMP"
      activate       = var.activate_service_connectors

      source = {
        kind        = "streaming"
        cursor_kind = "TRIM_HORIZON"
        stream_id   = "SERVICE-EVENT-STREAM"
        non_audit_logs = [{
          cmp_id       = "SCCA_CHILD_LOGGING_CMP",
          log_group_id = "DEFAULT_LOG_GROUP"
        }]
      }
      target = {
        kind                      = "objectstorage"
        bucket_name               = "SERVICE-EVENT-BUCKET"
        bucket_object_name_prefix = "sch",
      }
      policy = {
        name           = "OCI-SCCA-LZ-Service-Connector-Policy-service-events"
        description    = "OCI SCCA Landing Zone Service Connector Policy"
        compartment_id = "SCCA_CHILD_HOME_CMP"
      }
    }
  }

  cross_tenancy_service_connector = var.enable_service_deployment && var.home_region_deployment && var.enable_logging_compartment ? {
    CROSS-TENANCY-DEFAULT-LOG-SERVICE-CONNECTOR = {
      display_name   = "schLoggingRemoteBucket"
      compartment_id = "SCCA_CHILD_VDMS_CMP"
      activate       = var.activate_service_connectors
      source = {
        kind = "logging"
        non_audit_logs = [{
          cmp_id       = "SCCA_CHILD_LOGGING_CMP",
          log_group_id = "DEFAULT_LOG_GROUP"
        }]
      }
      target = {
        kind                      = "objectstorage"
        bucket_name               = "defaultLogs_archive-${var.parent_resource_label}"
        bucket_namespace          = var.parent_namespace
        compartment_id            = var.scca_parent_logging_compartment_ocid
        bucket_object_name_prefix = "sch_${var.resource_label}"
      }
    }
    CROSS-TENANCY-VNC-FLOW-LOG-SERVICE-CONNECTOR = {
      display_name   = "schVCNFlowLog_RemoteBucket"
      compartment_id = "SCCA_CHILD_VDMS_CMP"
      activate       = var.activate_service_connectors

      source = {
        kind = "logging"
        non_audit_logs = [{
          cmp_id       = "SCCA_CHILD_LOGGING_CMP",
          log_group_id = module.scca_vcn_flow_log[0].log_groups["VCN-FLOW-LOG-GROUP"].id
        }]
      }
      target = {
        kind                      = "objectstorage"
        bucket_name               = "defaultLogs_archive-${var.parent_resource_label}"
        bucket_namespace          = var.parent_namespace
        compartment_id            = var.scca_parent_logging_compartment_ocid
        bucket_object_name_prefix = "sch_${var.resource_label}"
      }
    }
  } : {}
  service_connectors_configuration = {
    default_compartment_id = "SCCA_CHILD_VDMS_CMP"

    service_connectors = merge(local.baseline_service_connectors, local.cross_tenancy_service_connector)
    buckets = {
      DEFAULT-LOG-BUCKET = {
        name               = local.default_log_bucket.name
        description        = local.default_log_bucket.description
        compartment_id     = "SCCA_CHILD_LOGGING_CMP"
        enable_replication = var.enable_bucket_replication
        replica_region     = var.secondary_region
        kms_key_id         = "MASTER-ENCRYPTION_KEY"

        storage_tier = var.bucket_storage_tier
        retention_rules = {
          RULE1 = {
            display_name = local.default_log_bucket.retention_rule_display_name
            time_amount  = local.default_log_bucket.retention_policy_duration_amount
            time_unit    = local.default_log_bucket.retention_policy_duration_time_unit
          }
        }
      }

      AUDIT-BUCKET = {
        name               = local.audit_log_bucket.name
        description        = local.audit_log_bucket.description
        compartment_id     = "SCCA_CHILD_LOGGING_CMP"
        enable_replication = var.enable_bucket_replication
        replica_region     = var.secondary_region

        kms_key_id = "MASTER-ENCRYPTION_KEY" # The ocid of an existing KMS key. Required if cis_level = "2".

        storage_tier = var.bucket_storage_tier
        retention_rules = {
          RULE1 = {
            display_name = local.audit_log_bucket.retention_rule_display_name
            time_amount  = local.audit_log_bucket.retention_policy_duration_amount
            time_unit    = local.audit_log_bucket.retention_policy_duration_time_unit
          }
        }
      }
      SERVICE-EVENT-BUCKET = {
        name               = local.service_event_log_bucket.name
        description        = local.service_event_log_bucket.description
        compartment_id     = "SCCA_CHILD_LOGGING_CMP"
        enable_replication = var.enable_bucket_replication
        replica_region     = var.secondary_region

        kms_key_id = "MASTER-ENCRYPTION_KEY" # The ocid of an existing KMS key. Required if cis_level = "2".

        storage_tier = var.bucket_storage_tier
        retention_rules = {
          RULE1 = {
            display_name = local.service_event_log_bucket.retention_rule_display_name
            time_amount  = local.service_event_log_bucket.retention_policy_duration_amount
            time_unit    = local.service_event_log_bucket.retention_policy_duration_time_unit
          }
        }
      }
      BACKUP-BUCKET = {
        name           = local.backup_bucket.name
        description    = "Backup bucket"
        compartment_id = "SCCA_CHILD_BACKUP_CMP"

        kms_key_id = "MASTER-ENCRYPTION_KEY" # The ocid of an existing KMS key. Required if cis_level = "2".

        storage_tier = var.bucket_storage_tier
        retention_rules = {
          RULE1 = {
            display_name = local.backup_bucket.retention_rule_display_name
            time_amount  = local.backup_bucket.retention_policy_duration_amount
            time_unit    = local.backup_bucket.retention_policy_duration_time_unit
          }
        }
      }
    }
  }
  streams_configuration = {
    default_compartment_id = "SCCA_CHILD_VDMS_CMP"
    streams : {
      SERVICE-EVENT-STREAM = {
        name           = "serviceEvents"
        stream_pool_id = "SERVICE-EVENT-STREAM-POOL"
        num_partitions = 1
      }
    }
    stream_pools = {
      SERVICE-EVENT-STREAM-POOL = {
        name           = "services-events-pool"
        compartment_id = "SCCA_CHILD_VDMS_CMP"
        kms_key_id     = "MASTER-ENCRYPTION_KEY"
      }
    }
  }
  service_events_configuration = {
    default_compartment_id = "SCCA_CHILD_VDMS_CMP"
    event_rules = {
      SERVICE-EVENT-RULE = {
        is_enabled             = true
        event_display_name     = var.deployment_type == "SINGLE" ? "All events in ${local.single_tenancy_vdms_name}-${local.region_key[0]}-${var.resource_label}" : "All events in ${var.vdms_compartment_name}-${local.region_key[0]}-${var.resource_label}"
        supplied_events        = ["{}"]
        destination_stream_ids = ["SERVICE-EVENT-STREAM"]
      }
    }
  }
  service_connector_policies_configuration = {
    supplied_policies : {
      "SERVICE-CONNECTOR-POLICY" : {
        name : "${local.service_connector_policy.name}"
        description : "${local.service_connector_policy.description}"
        compartment_id : "SCCA_CHILD_HOME_CMP"
        statements : local.service_connector_policy.statements
      }
    }
  }
}

module "scca_logging" {
  count                 = var.enable_logging_compartment ? 1 : 0
  source                = "github.com/oci-landing-zones/terraform-oci-modules-observability//logging?ref=v0.1.8"
  logging_configuration = var.enable_network_firewall ? local.logging_configuration_nfw : local.logging_configuration_no_nfw

  compartments_dependency = module.scca_compartments[0].compartments
  tenancy_ocid            = var.tenancy_ocid
  depends_on = [module.service_connectors.service_connector_buckets,
  module.scca_networking_firewall[0].provisioned_networking_resources]
}


module "scca_vcn_flow_log" {
  count                   = var.enable_vcn_flow_logs && var.enable_logging_compartment ? 1 : 0
  source                  = "github.com/oci-landing-zones/terraform-oci-modules-observability//logging?ref=v0.1.8"
  
  logging_configuration   = local.vcn_flow_logging_configuration
  compartments_dependency = module.scca_compartments[0].compartments
  tenancy_ocid            = var.tenancy_ocid
}

module "scca_vcn_flow_log_service_connectors" {
  count                            = var.enable_vcn_flow_logs && var.enable_logging_compartment ? 1 : 0
  source                           = "github.com/oci-landing-zones/terraform-oci-modules-observability//service-connectors?ref=v0.1.8"

  tenancy_ocid                     = var.tenancy_ocid
  service_connectors_configuration = local.vcn_flow_log_service_connectors_configuration
  compartments_dependency          = module.scca_compartments[0].compartments
  logs_dependency                  = module.scca_vcn_flow_log[0].log_groups
  kms_dependency                   = module.central_vault_and_key.keys
  providers = {
    oci                  = oci
    oci.home             = oci.home_region
    oci.secondary_region = oci.secondary_region
  }
}

module "service_connector_policies" {
  source                  = "github.com/oci-landing-zones/terraform-oci-modules-iam//policies?ref=v0.2.3"

  tenancy_ocid            = var.tenancy_ocid
  policies_configuration  = local.service_connector_policies_configuration
  compartments_dependency = module.scca_compartments[0].compartments
}

module "service_streams" {
  source                  = "github.com/oci-landing-zones/terraform-oci-modules-observability//streams?ref=v0.1.8"

  streams_configuration   = local.streams_configuration
  compartments_dependency = module.scca_compartments[0].compartments
  kms_dependency          = module.central_vault_and_key.keys
}

module "service_events" {
  source                  = "github.com/oci-landing-zones/terraform-oci-modules-observability//events?ref=v0.1.8"

  events_configuration    = local.service_events_configuration
  compartments_dependency = module.scca_compartments[0].compartments
  streams_dependency      = module.service_streams.streams
  tenancy_ocid            = var.tenancy_ocid
}

module "service_connectors" {
  count                            = var.enable_logging_compartment ? 1 : 0
  source                           = "github.com/oci-landing-zones/terraform-oci-modules-observability//service-connectors?ref=v0.1.8"

  tenancy_ocid                     = var.tenancy_ocid
  service_connectors_configuration = local.service_connectors_configuration
  compartments_dependency          = module.scca_compartments[0].compartments
  streams_dependency               = module.service_streams.streams
  logs_dependency                  = module.scca_logging[0].log_groups
  kms_dependency                   = module.central_vault_and_key.keys
  providers = {
    oci                  = oci
    oci.home             = oci.home_region
    oci.secondary_region = oci.secondary_region
  }
}
