locals {
  vdms_critical_topic = {
    topic_name            = "VDMS-Critical-${var.resource_label}"
    topic_description     = "Critical notification for VDMS"
    subscription_protocol = "EMAIL"
    event_rules = {
      lzCgCritical = {
        rule_condition    = <<EOT
            {
              "eventType":[
                "com.oraclecloud.cloudguard.problemdetected"
              ]
            }
        EOT
        rule_display_name = "lzCgCritical"
        rule_is_enabled   = true
        rule_description  = "Cloud Guard Problem Critical"
      }
    }
  }

  vdms_warning_topic = {
    topic_name            = "VDMS-Warning-${var.resource_label}"
    topic_description     = "Warning notification for VDMS"
    subscription_protocol = "EMAIL"
    event_rules = {
      lzCgWarning = {
        rule_condition    = <<EOT
              {
                "eventType":[
                  "com.oraclecloud.cloudguard.problemthresholdreached",
                  "com.oraclecloud.cloudguard.announcements",
                  "com.oraclecloud.cloudguard.status",
                  "com.oraclecloud.cloudguard.problemdismissed",
                  "com.oraclecloud.cloudguard.problemremediated" 
                ]
              }
        EOT
        rule_display_name = "lzCgWarning"
        rule_is_enabled   = true
        rule_description  = "Cloud Guard Problem Warning"
      }
    }
  }

  # @TODO move announcements into the notification module
  vdms_announcement_subscription = {
    subscription_display_name = "SCCA-LZ-Critical"
    filter_group_name         = "SCCA-LZ-Critical-Filter"
    compartment_id            = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid
    topic_id                  = module.vdms_critical_topic.topic_id
    filter_groups = {
      "compartment_filter" = {
        filters_type  = "COMPARTMENT_ID"
        filters_value = [var.home_region_deployment ? module.home_compartment[0].compartment_id : var.secondary_home_compartment_ocid]
      }
      "type_filter" = {
        filters_type  = "ANNOUNCEMENT_TYPE"
        filters_value = ["ACTION_REQUIRED", "EMERGENCY_MAINTENANCE", "EMERGENCY_CHANGE", "PRODUCTION_EVENT_NOTIFICATION"]
      }
    }
  }
}

module "vdms_critical_topic" {
  source = "./modules/notification-topic"

  compartment_id        = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid
  topic_name            = local.vdms_critical_topic.topic_name
  topic_description     = local.vdms_critical_topic.topic_description
  subscription_endpoint = var.vdms_critical_topic_endpoints
  subscription_protocol = local.vdms_critical_topic.subscription_protocol
  event_rules           = local.vdms_critical_topic.event_rules
}

module "vdms_warning_topic" {
  source = "./modules/notification-topic"

  compartment_id        = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid
  topic_name            = local.vdms_warning_topic.topic_name
  topic_description     = local.vdms_warning_topic.topic_description
  subscription_endpoint = var.vdms_warning_topic_endpoints
  subscription_protocol = local.vdms_warning_topic.subscription_protocol
  event_rules           = local.vdms_warning_topic.event_rules
}

module "vdms_announcement_subscription" {
  source                    = "./modules/announcement-subscription"
  compartment_id            = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid
  notification_topic_id     = module.vdms_critical_topic.topic_id
  subscription_display_name = local.vdms_announcement_subscription.subscription_display_name
  filter_groups             = local.vdms_announcement_subscription.filter_groups
}

locals {
  vdss_critical_topic = {
    topic_name            = "VDSS-Critical-${var.resource_label}"
    topic_description     = "Critical notification for VDSS"
    subscription_protocol = "EMAIL"
  }

  vdss_warning_topic = {
    topic_name            = "VDSS-Warning-${var.resource_label}"
    topic_description     = "Warning notification for VDSS"
    subscription_protocol = "EMAIL"
  }
}

module "vdss_critical_topic" {
  source = "./modules/notification-topic"

  compartment_id        = var.home_region_deployment ? module.vdss_compartment[0].compartment_id : var.secondary_vdss_compartment_ocid
  topic_name            = local.vdss_critical_topic.topic_name
  topic_description     = local.vdss_critical_topic.topic_description
  subscription_endpoint = var.vdss_critical_topic_endpoints
  subscription_protocol = local.vdss_critical_topic.subscription_protocol
}

module "vdss_warning_topic" {
  source = "./modules/notification-topic"

  compartment_id        = var.home_region_deployment ? module.vdss_compartment[0].compartment_id : var.secondary_vdss_compartment_ocid
  topic_name            = local.vdss_warning_topic.topic_name
  topic_description     = local.vdss_warning_topic.topic_description
  subscription_endpoint = var.vdss_warning_topic_endpoints
  subscription_protocol = local.vdss_warning_topic.subscription_protocol
}

# -----------------------------------------------------------------------------
# Log Analytics
# -----------------------------------------------------------------------------
locals {
  logging_analytics = {
    is_onboarded = true // if namespace module runs and set to true onboards else offboards
  }

  logging_analytics_default_group = {
    namespace    = data.oci_log_analytics_namespaces.logging_analytics_namespaces.namespace_collection[0].items[0].namespace
    display_name = "Default_Group_${var.resource_label}"
    description  = "Logging Analytics Log Group created by Landing Zone for Default_Group"
  }

  logging_analytics_audit_group = {
    namespace    = data.oci_log_analytics_namespaces.logging_analytics_namespaces.namespace_collection[0].items[0].namespace
    display_name = "AuditLog_${var.resource_label}"
    description  = "Logging Analytics Log Group created by Landing Zone for AuditLog"
  }

  default_logging_analytics_policy = {
    name        = "OCI-SCCA-LZ-Default-Logging-Analytics-Policy-${var.resource_label}"
    description = "OCI SCCA Landing Zone Default Logging Analytics Policy"

    statements = [
      <<EOT
      allow any-user to {LOG_ANALYTICS_LOG_GROUP_UPLOAD_LOGS} in compartment id ${var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid} where all
      {
        request.principal.type='serviceconnector',
        target.loganalytics-log-group.id='${module.logging_analytics_default_group.log_group_ocid}',
        request.principal.compartment.id='${var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid}'
      }
      EOT
    ]
  }

  audit_logging_analytics_policy = {
    name        = "OCI-SCCA-LZ-Audit-Logging-Analytics-Policy-${var.resource_label}"
    description = "OCI SCCA Landing Zone Audit Logging Analytics Policy"

    statements = [
      <<EOT
      allow any-user to {LOG_ANALYTICS_LOG_GROUP_UPLOAD_LOGS} in compartment id ${var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid} where all
      {
        request.principal.type='serviceconnector',
        target.loganalytics-log-group.id='${module.logging_analytics_audit_group.log_group_ocid}',
        request.principal.compartment.id='${var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid}'
      }
      EOT
    ]
  }

  default_logging_analytics_service_connector = {
    display_name = "schDefaultLog_LA"
    source_kind  = "logging"
    target_kind  = "loggingAnalytics"
  }

  audit_logging_analytics_service_connector = {
    display_name = "schAuditLog_LA"
    source_kind  = "logging"
    target_kind  = "loggingAnalytics"
    log_group_id = "_Audit"
  }
}

module "logging_analytics_namespace" {
  count                  = var.onboard_log_analytics ? 1 : 0
  source                 = "./modules/log-analytics-namespace"
  compartment_id         = var.tenancy_ocid
  is_onboarded           = local.logging_analytics.is_onboarded
  tenancy_ocid           = var.tenancy_ocid
  resource_label         = var.resource_label
  home_region_deployment = var.home_region_deployment
}

module "logging_analytics_default_group" {
  source         = "./modules/logging-analytics-log-group"
  compartment_id = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid
  tenancy_ocid   = var.tenancy_ocid
  namespace      = local.logging_analytics_default_group.namespace
  display_name   = local.logging_analytics_default_group.display_name
  description    = local.logging_analytics_default_group.description
  depends_on = [
    module.logging_analytics_namespace
  ]
}

module "logging_analytics_audit_group" {
  source         = "./modules/logging-analytics-log-group"
  compartment_id = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid
  tenancy_ocid   = var.tenancy_ocid
  namespace      = local.logging_analytics_audit_group.namespace
  display_name   = local.logging_analytics_audit_group.display_name
  description    = local.logging_analytics_audit_group.description
  depends_on = [
    module.logging_analytics_namespace
  ]
}

module "default_logging_analytics_policy" {
  source           = "./modules/policies"
  count            = var.home_region_deployment ? 1 : 0
  compartment_ocid = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid
  policy_name      = local.default_logging_analytics_policy.name
  description      = local.default_logging_analytics_policy.description
  statements       = local.default_logging_analytics_policy.statements
}

module "audit_logging_analytics_policy" {
  source           = "./modules/policies"
  count            = var.home_region_deployment ? 1 : 0
  compartment_ocid = var.home_region_deployment ? module.home_compartment[0].compartment_id : var.secondary_home_compartment_ocid
  policy_name      = local.audit_logging_analytics_policy.name
  description      = local.audit_logging_analytics_policy.description
  statements       = local.audit_logging_analytics_policy.statements
}

module "default_logging_analytics_service_connector" {
  source              = "./modules/service-connector-logging-analytics"
  compartment_id      = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid
  display_name        = local.default_logging_analytics_service_connector.display_name
  source_kind         = local.default_logging_analytics_service_connector.source_kind
  source_log_group_id = module.default_log_group.log_group_id
  target_log_group_id = module.logging_analytics_default_group.log_group_ocid
  target_kind         = local.default_logging_analytics_service_connector.target_kind
  # Service connector needs at least one log on the log group, or it errors. 
  # Also it takes time for it to recognize this. 
  depends_on = [
    time_sleep.first_log_delay
  ]
}

module "audit_logging_analytics_service_connector" {
  source              = "./modules/service-connector-logging-analytics"
  compartment_id      = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid
  display_name        = local.audit_logging_analytics_service_connector.display_name
  source_kind         = local.audit_logging_analytics_service_connector.source_kind
  source_log_group_id = local.audit_logging_analytics_service_connector.log_group_id
  target_log_group_id = module.logging_analytics_audit_group.log_group_ocid
  target_kind         = local.audit_logging_analytics_service_connector.target_kind
}

# -----------------------------------------------------------------------------
# Alarms
# -----------------------------------------------------------------------------

locals {
  alarm_map_log = var.enable_logging_compartment ? {
    objectstorage_UncommittedParts_alarm = {
      display_name          = "objectstorage_UncommittedParts_alarm"
      metric_compartment_id = var.home_region_deployment ? module.logging_compartment[0].compartment_id : var.secondary_logging_compartment_ocid
      namespace             = "oci_objectstorage"
      query                 = "UncommittedParts[1m].count() > 0"
      severity              = "WARNING"
    }
    objectstorage_ClientErrors_alarm = {
      display_name          = "objectstorage_ClientErrors_alarm"
      metric_compartment_id = var.home_region_deployment ? module.logging_compartment[0].compartment_id : var.secondary_logging_compartment_ocid
      namespace             = "oci_objectstorage"
      query                 = "ClientErrors[1m].sum() > 0"
      severity              = "WARNING"
    }
  } : {}

  alarm_map_std = {
    bastion_activesession_alarm = {
      display_name          = "bastion_activesession_alarm"
      metric_compartment_id = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid
      namespace             = "oci_bastion"
      query                 = "activeSessions[1m].sum() > 0"
      severity              = "WARNING"
    }
    network_lbPeakBandwidth_alarm = {
      display_name          = "network_lbPeakBandwidth_alarm"
      metric_compartment_id = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid
      namespace             = "oci_lbaas"
      query                 = "PeakBandwidth[1m].mean() < 8"
      severity              = "WARNING"
    }
    network_vcnVnicConntrackUtilPercent_alarm = {
      display_name          = "network_vcnVnicConntrackUtilPercent_alarm"
      metric_compartment_id = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid
      namespace             = "oci_vcn"
      query                 = "VnicConntrackUtilPercent[1m].mean() > 80"
      severity              = "WARNING"
    }
    network_vcnVnicEgressDropThrottle_alarm = {
      display_name          = "network_vcnVnicEgressDropThrottle_alarm"
      metric_compartment_id = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid
      namespace             = "oci_vcn"
      query                 = "VnicEgressDropThrottle[1m].mean() > 0"
      severity              = "WARNING"
    }
    network_vcnVnicIngressDropThrottle_alarm = {
      display_name          = "network_vcnVnicIngressDropThrottle_alarm"
      metric_compartment_id = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid
      namespace             = "oci_vcn"
      query                 = "VnicIngressDropThrottle[1m].mean() > 0"
      severity              = "WARNING"
    }
  }

  vdms_warning_alarms = {
    metric_compartment_id_in_subtree = false
    is_enabled                       = var.enable_vdms_warning_alarm
    message_format                   = "ONS_OPTIMIZED"
    pending_duration                 = "PT5M"
    alarm_map                        = merge(local.alarm_map_std, local.alarm_map_log)
  }

  vdms_critical_alarms = {
    metric_compartment_id_in_subtree = false
    is_enabled                       = var.enable_vdms_critical_alarm
    message_format                   = "ONS_OPTIMIZED"
    pending_duration                 = "PT5M"

    alarm_map = {
      sch_error_alarm = {
        display_name          = "sch_error_alarm"
        metric_compartment_id = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid
        namespace             = "oci_service_connector_hub"
        query                 = "ServiceConnectorHubErrors[1m].sum() > 0"
        severity              = "CRITICAL"
      }
      stream_putfault_alarm = {
        display_name          = "stream_putfault_alarm"
        metric_compartment_id = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid
        namespace             = "oci_streaming"
        query                 = "PutMessagesFault.Count[1m].sum() > 0"
        severity              = "CRITICAL"
      }
      stream_getfault_alarm = {
        display_name          = "stream_getfault_alarm"
        metric_compartment_id = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid
        namespace             = "oci_streaming"
        query                 = "GetMessagesFault.Count[1m].sum() > 0"
        severity              = "CRITICAL"
      }
      vss_SecurityVulnerability_alarm = {
        display_name          = "vss_SecurityVulnerability_alarm"
        metric_compartment_id = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid
        namespace             = "oci_vss"
        query                 = "SecurityVulnerability[1m].sum() > 0"
        severity              = "CRITICAL"
      }
      network_lbUnHealthyBackendServers_alarm = {
        display_name          = "network_lbUnHealthyBackendServers_alarm"
        metric_compartment_id = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid
        namespace             = "oci_lbaas"
        query                 = "UnHealthyBackendServers[1m].mean() > 0"
        severity              = "CRITICAL"
      }
      network_lbFailedSSLClientCertVerify_alarm = {
        display_name          = "network_lbFailedSSLClientCertVerify_alarm"
        metric_compartment_id = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid
        namespace             = "oci_lbaas"
        query                 = "FailedSSLClientCertVerify[1m].mean() > 0"
        severity              = "CRITICAL"
      }
      network_lbFailedSSLHandshake_alarm = {
        display_name          = "network_lbFailedSSLHandshake_alarm"
        metric_compartment_id = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid
        namespace             = "oci_lbaas"
        query                 = "FailedSSLHandshake[1m].mean() > 0"
        severity              = "CRITICAL"
      }
      network_vcnVnicConntrackIsFull_alarm = {
        display_name          = "network_vcnVnicConntrackIsFull_alarm"
        metric_compartment_id = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid
        namespace             = "oci_vcn"
        query                 = "VnicConntrackIsFull[1m].mean() > 0"
        severity              = "CRITICAL"
      }
    }
  }

  vdss_critical_alarms = {
    metric_compartment_id_in_subtree = false
    is_enabled                       = var.enable_vdss_critical_alarm
    message_format                   = "ONS_OPTIMIZED"
    pending_duration                 = "PT5M"
    alarm_map = {
      network_sgwDropsToService_alarm = {
        display_name          = "network_sgwDropsToService_alarm"
        metric_compartment_id = var.home_region_deployment ? module.vdss_compartment[0].compartment_id : var.secondary_vdss_compartment_ocid
        namespace             = "oci_service_gateway"
        query                 = "sgwDropsToService[1m].mean() > 0"
        severity              = "CRITICAL"
      }
      network_sgwDropsFromService_alarm = {
        display_name          = "network_sgwDropsFromService_alarm"
        metric_compartment_id = var.home_region_deployment ? module.vdss_compartment[0].compartment_id : var.secondary_vdss_compartment_ocid
        namespace             = "oci_service_gateway"
        query                 = "sgwDropsFromService[1m].mean() > 0"
        severity              = "CRITICAL"
      }
      network_fwLandAttacksCount_alarm = {
        display_name          = "network_sgwDropsFromService_alarm"
        metric_compartment_id = var.home_region_deployment ? module.vdss_compartment[0].compartment_id : var.secondary_vdss_compartment_ocid
        namespace             = "oci_network_firewall"
        query                 = "LandAttacksCount[1m].mean() > 0"
        severity              = "CRITICAL"
      }
      network_fwIPSpoofCount_alarm = {
        display_name          = "network_fwIPSpoofCount_alarm"
        metric_compartment_id = var.home_region_deployment ? module.vdss_compartment[0].compartment_id : var.secondary_vdss_compartment_ocid
        namespace             = "oci_network_firewall"
        query                 = "IPSpoofCount[1m].mean() > 0"
        severity              = "CRITICAL"
      }
      network_fwPingOfDeathAttacksCount_alarm = {
        display_name          = "network_fwPingOfDeathAttacksCount_alarm"
        metric_compartment_id = var.home_region_deployment ? module.vdss_compartment[0].compartment_id : var.secondary_vdss_compartment_ocid
        namespace             = "oci_network_firewall"
        query                 = "PingOfDeathAttacksCount[1m].mean() > 0"
        severity              = "CRITICAL"
      }
      network_fwTeardropAttacksCount_alarm = {
        display_name          = "network_fwTeardropAttacksCount_alarm"
        metric_compartment_id = var.home_region_deployment ? module.vdss_compartment[0].compartment_id : var.secondary_vdss_compartment_ocid
        namespace             = "oci_network_firewall"
        query                 = "PingOfDeathAttacksCount[1m].mean() > 0"
        severity              = "CRITICAL"
      }
      network_lbUnHealthyBackendServers_alarm = {
        display_name          = "network_lbUnHealthyBackendServers_alarm"
        metric_compartment_id = var.home_region_deployment ? module.vdss_compartment[0].compartment_id : var.secondary_vdss_compartment_ocid
        namespace             = "oci_lbaas"
        query                 = "UnHealthyBackendServers[1m].mean() > 0"
        severity              = "CRITICAL"
      }
      network_lbFailedSSLClientCertVerify_alarm = {
        display_name          = "network_lbFailedSSLClientCertVerify_alarm"
        metric_compartment_id = var.home_region_deployment ? module.vdss_compartment[0].compartment_id : var.secondary_vdss_compartment_ocid
        namespace             = "oci_lbaas"
        query                 = "FailedSSLClientCertVerify[1m].mean() > 0"
        severity              = "CRITICAL"
      }
      network_lbFailedSSLHandshake_alarm = {
        display_name          = "network_lbFailedSSLHandshake_alarm"
        metric_compartment_id = var.home_region_deployment ? module.vdss_compartment[0].compartment_id : var.secondary_vdss_compartment_ocid
        namespace             = "oci_lbaas"
        query                 = "FailedSSLHandshake[1m].mean() > 0"
        severity              = "CRITICAL"
      }
      network_vcnVnicConntrackIsFull_alarm = {
        display_name          = "network_vcnVnicConntrackIsFull_alarm"
        metric_compartment_id = var.home_region_deployment ? module.vdss_compartment[0].compartment_id : var.secondary_vdss_compartment_ocid
        namespace             = "oci_vcn"
        query                 = "VnicConntrackIsFull[1m].mean() > 0"
        severity              = "CRITICAL"
      }
      network_oci_nat_gateway_alarm = {
        display_name          = "network_oci_nat_gateway_alarm"
        metric_compartment_id = var.home_region_deployment ? module.vdss_compartment[0].compartment_id : var.secondary_vdss_compartment_ocid
        namespace             = "oci_nat_gateway"
        query                 = "DropsToNATgw[1m].mean() > 0"
        severity              = "CRITICAL"
      }
      network_fast_connect_status_alarm = {
        display_name          = "network_fast_connect_status_alarm"
        metric_compartment_id = var.home_region_deployment ? module.vdss_compartment[0].compartment_id : var.secondary_vdss_compartment_ocid
        namespace             = "oci_fastconnect"
        query                 = "ConnectionState[1m].mean() == 0"
        severity              = "CRITICAL"
      }
    }
  }

  vdss_warning_alarms = {
    metric_compartment_id_in_subtree = false
    is_enabled                       = var.enable_vdss_warning_alarm
    message_format                   = "ONS_OPTIMIZED"
    pending_duration                 = "PT5M"

    alarm_map = {
      network_lbPeakBandwidth_alarm = {
        display_name          = "network_lbPeakBandwidth_alarm"
        metric_compartment_id = var.home_region_deployment ? module.vdss_compartment[0].compartment_id : var.secondary_vdss_compartment_ocid
        namespace             = "oci_lbaas"
        query                 = "PeakBandwidth[1m].mean() < 8"
        severity              = "WARNING"
      }
      network_vcnVnicConntrackUtilPercent_alarm = {
        display_name          = "network_vcnVnicConntrackUtilPercent_alarm"
        metric_compartment_id = var.home_region_deployment ? module.vdss_compartment[0].compartment_id : var.secondary_vdss_compartment_ocid
        namespace             = "oci_vcn"
        query                 = "VnicConntrackUtilPercent[1m].mean() > 80"
        severity              = "WARNING"
      }
      network_vcnVnicEgressDropThrottle_alarm = {
        display_name          = "network_vcnVnicEgressDropThrottle_alarm"
        metric_compartment_id = var.home_region_deployment ? module.vdss_compartment[0].compartment_id : var.secondary_vdss_compartment_ocid
        namespace             = "oci_vcn"
        query                 = "VnicEgressDropThrottle[1m].mean() > 80"
        severity              = "WARNING"
      }
      network_vcnVnicIngressDropThrottle_alarm = {
        display_name          = "network_vcnVnicIngressDropThrottle_alarm"
        metric_compartment_id = var.home_region_deployment ? module.vdss_compartment[0].compartment_id : var.secondary_vdss_compartment_ocid
        namespace             = "oci_vcn"
        query                 = "VnicIngressDropThrottle[1m].mean() > 80"
        severity              = "WARNING"
      }
    }
  }

  alarm_policy = {
    name        = "OCI-SCCA-LZ-Alarm-Policy-${var.resource_label}"
    description = "OCI SCCA Landing Zone Alarm Policy"

    statements = [
      <<EOT
        Allow group OCI-SCCA-LZ-Domain-${local.region_key[0]}/VDSSAdmin  to read metrics in compartment id ${var.home_region_deployment ? module.home_compartment[0].compartment_id : var.secondary_home_compartment_ocid} where any {
          target.metrics.namespace='oci_vcn',
          target.metrics.namespace='oci_vpn',
          target.metrics.namespace='oci_fastconnect',
          target.metrics.namespace='oci_service_gateway',
          target.metrics.namespace='oci_nat_gateway',
          target.metrics.namespace='oci_internet_gateway',
          target.metrics.namespace='oci_lbaas',
          target.metrics.namespace='oci_network_firewall'
        }
      EOT
    ]
  }

}

module "vdms_critical_alarms" {
  source                           = "./modules/alarm"
  compartment_id                   = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid
  notification_topic_id            = module.vdms_critical_topic.topic_id
  is_enabled                       = local.vdms_critical_alarms.is_enabled
  message_format                   = local.vdms_critical_alarms.message_format
  pending_duration                 = local.vdms_critical_alarms.pending_duration
  metric_compartment_id_in_subtree = local.vdms_critical_alarms.metric_compartment_id_in_subtree

  alarm_map = local.vdms_critical_alarms.alarm_map
}

module "vdms_warning_alarms" {
  source                           = "./modules/alarm"
  compartment_id                   = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid
  notification_topic_id            = module.vdms_warning_topic.topic_id
  is_enabled                       = local.vdms_warning_alarms.is_enabled
  message_format                   = local.vdms_warning_alarms.message_format
  pending_duration                 = local.vdms_warning_alarms.pending_duration
  metric_compartment_id_in_subtree = local.vdms_warning_alarms.metric_compartment_id_in_subtree

  alarm_map = local.vdms_warning_alarms.alarm_map
}

module "vdss_critical_alarms" {
  source                           = "./modules/alarm"
  compartment_id                   = var.home_region_deployment ? module.vdss_compartment[0].compartment_id : var.secondary_vdss_compartment_ocid
  notification_topic_id            = module.vdss_critical_topic.topic_id
  is_enabled                       = local.vdss_critical_alarms.is_enabled
  message_format                   = local.vdss_critical_alarms.message_format
  pending_duration                 = local.vdss_critical_alarms.pending_duration
  metric_compartment_id_in_subtree = local.vdss_critical_alarms.metric_compartment_id_in_subtree

  alarm_map = local.vdss_critical_alarms.alarm_map
}

module "vdss_warning_alarms" {
  source                           = "./modules/alarm"
  compartment_id                   = var.home_region_deployment ? module.vdss_compartment[0].compartment_id : var.secondary_vdss_compartment_ocid
  notification_topic_id            = module.vdss_critical_topic.topic_id
  is_enabled                       = local.vdss_critical_alarms.is_enabled
  message_format                   = local.vdss_critical_alarms.message_format
  pending_duration                 = local.vdss_critical_alarms.pending_duration
  metric_compartment_id_in_subtree = local.vdss_critical_alarms.metric_compartment_id_in_subtree

  alarm_map = local.vdss_critical_alarms.alarm_map
}

module "alarm_policy" {
  source           = "./modules/policies"
  count            = var.home_region_deployment ? 1 : 0
  compartment_ocid = var.home_region_deployment ? module.home_compartment[0].compartment_id : var.secondary_home_compartment_ocid
  policy_name      = local.alarm_policy.name
  description      = local.alarm_policy.description
  statements       = local.alarm_policy.statements
}
