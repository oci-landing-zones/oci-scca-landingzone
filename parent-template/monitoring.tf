# ###################################################################################################### #
# Copyright (c) 2024 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

locals {
  #--------------------------------------------------------------------------------------------#
  # Topics input variables
  #--------------------------------------------------------------------------------------------#
  topics = {
    VDMS-CRITICAL-TOPIC : {
      compartment_id = "SCCA_PARENT_VDMS_CMP"
      name           = "PARENT-VDMS-Critical-${var.resource_label}"
      subscriptions = [
        {
          protocol = "EMAIL"
          values   = var.vdms_critical_topic_endpoints
        }
      ]
    }

    VDMS-WARNING-TOPIC : {
      compartment_id = "SCCA_PARENT_VDMS_CMP"
      name           = "PARENT-VDMS-Warning-${var.resource_label}"
      subscriptions = [
        {
          protocol = "EMAIL"
          values   = var.vdms_warning_topic_endpoints
        }
      ]
    }

    VDSS-CRITICAL-TOPIC : {
      compartment_id = "SCCA_PARENT_VDSS_CMP"
      name           = "PARENT-VDSS-Critical-${var.resource_label}"
      subscriptions = [
        {
          protocol = "EMAIL"
          values   = var.vdss_critical_topic_endpoints
        }
      ]
    }

    VDSS-WARNING-TOPIC : {
      compartment_id = "SCCA_PARENT_VDSS_CMP"
      name           = "PARENT-VDSS-Warning-${var.resource_label}"
      subscriptions = [
        {
          protocol = "EMAIL"
          values   = var.vdss_critical_topic_endpoints
        }
      ]
    }
  }

  event_rules = {
    CG-CRITICAL : {
      event_display_name = "lzCgCritical"
      supplied_events = [
        "com.oraclecloud.cloudguard.problemdetected"
      ]
      destination_topic_ids = ["VDMS-CRITICAL-TOPIC"]
    }

    CG-WARNING : {
      event_display_name = "lzCgWarning"
      supplied_events = [
        "com.oraclecloud.cloudguard.problemthresholdreached",
        "com.oraclecloud.cloudguard.announcements",
        "com.oraclecloud.cloudguard.status",
        "com.oraclecloud.cloudguard.problemdismissed",
        "com.oraclecloud.cloudguard.problemremediated"
      ]
      destination_topic_ids = ["VDMS-WARNING-TOPIC"]
    }
  }

  #--------------------------------------------------------------------------------------------#
  # Alarms input variables
  #--------------------------------------------------------------------------------------------#

  alarms = {
    VDSS-CRITICAL-ALARMS : var.enable_vdss_critical_alarm ? {
      network_sgwDropsToService_alarm : {
        display_name          = "network_sgwDropsToService_alarm"
        compartment_id        = "SCCA_PARENT_VDSS_CMP"
        destination_topic_ids = ["VDSS-CRITICAL-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_service_gateway"
          query            = "sgwDropsToService[1m].mean() > 0"
          severity         = "CRITICAL"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      network_sgwDropsFromService_alarm = {
        display_name          = "network_sgwDropsFromService_alarm"
        compartment_id        = "SCCA_PARENT_VDSS_CMP"
        destination_topic_ids = ["VDSS-CRITICAL-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_service_gateway"
          query            = "sgwDropsFromService[1m].mean() > 0"
          severity         = "CRITICAL"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      network_fwLandAttacksCount_alarm = {
        display_name          = "network_fwLandAttacksCount_alarm"
        compartment_id        = "SCCA_PARENT_VDSS_CMP"
        destination_topic_ids = ["VDSS-CRITICAL-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_network_firewall"
          query            = "LandAttacksCount[1m].mean() > 0"
          severity         = "CRITICAL"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      network_fwIPSpoofCount_alarm = {
        display_name          = "network_fwIPSpoofCount_alarm"
        compartment_id        = "SCCA_PARENT_VDSS_CMP"
        destination_topic_ids = ["VDSS-CRITICAL-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_network_firewall"
          query            = "IPSpoofCount[1m].mean() > 0"
          severity         = "CRITICAL"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      network_fwPingOfDeathAttacksCount_alarm = {
        display_name          = "network_fwPingOfDeathAttacksCount_alarm"
        compartment_id        = "SCCA_PARENT_VDSS_CMP"
        destination_topic_ids = ["VDSS-CRITICAL-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_network_firewall"
          query            = "PingOfDeathAttacksCount[1m].mean() > 0"
          severity         = "CRITICAL"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      network_fwTeardropAttacksCount_alarm = {
        display_name          = "network_fwTeardropAttacksCount_alarm"
        compartment_id        = "SCCA_PARENT_VDSS_CMP"
        destination_topic_ids = ["VDSS-CRITICAL-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_network_firewall"
          query            = "TeardropAttacksCount[1m].mean() > 0"
          severity         = "CRITICAL"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      network_lbUnHealthyBackendServers_alarm = {
        display_name          = "network_lbUnHealthyBackendServers_alarm"
        compartment_id        = "SCCA_PARENT_VDSS_CMP"
        destination_topic_ids = ["VDSS-CRITICAL-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_lbaas"
          query            = "UnHealthyBackendServers[1m].mean() > 0"
          severity         = "CRITICAL"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      network_lbFailedSSLClientCertVerify_alarm = {
        display_name          = "network_lbFailedSSLClientCertVerify_alarm"
        compartment_id        = "SCCA_PARENT_VDSS_CMP"
        destination_topic_ids = ["VDSS-CRITICAL-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_lbaas"
          query            = "FailedSSLClientCertVerify[1m].mean() > 0"
          severity         = "CRITICAL"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      network_lbFailedSSLHandshake_alarm = {
        display_name          = "network_lbFailedSSLHandshake_alarm"
        compartment_id        = "SCCA_PARENT_VDSS_CMP"
        destination_topic_ids = ["VDSS-CRITICAL-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_lbaas"
          query            = "FailedSSLHandshake[1m].mean() > 0"
          severity         = "CRITICAL"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      network_vcnVnicConntrackIsFull_alarm = {
        display_name          = "network_vcnVnicConntrackIsFull_alarm"
        compartment_id        = "SCCA_PARENT_VDSS_CMP"
        destination_topic_ids = ["VDSS-CRITICAL-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_vcn"
          query            = "VnicConntrackIsFull[1m].mean() > 0"
          severity         = "CRITICAL"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      network_oci_nat_gateway_alarm = {
        display_name          = "network_oci_nat_gateway_alarm"
        compartment_id        = "SCCA_PARENT_VDSS_CMP"
        destination_topic_ids = ["VDSS-CRITICAL-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_nat_gateway"
          query            = "DropsToNATgw[1m].mean() > 0"
          severity         = "CRITICAL"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      network_fast_connect_status_alarm = {
        display_name          = "network_fast_connect_status_alarm"
        compartment_id        = "SCCA_PARENT_VDSS_CMP"
        destination_topic_ids = ["VDSS-CRITICAL-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_fastconnect"
          query            = "ConnectionState[1m].mean() == 0"
          severity         = "CRITICAL"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
    } : {}

    VDSS-WARNING-ALARMS : var.enable_vdss_warning_alarm ? {
      network_lbPeakBandwidth_alarm : {
        display_name          = "network_lbPeakBandwidth_alarm"
        compartment_id        = "SCCA_PARENT_VDSS_CMP"
        destination_topic_ids = ["VDSS-WARNING-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_lbaas"
          query            = "PeakBandwidth[1m].mean() < 8"
          severity         = "WARNING"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      network_vcnVnicConntrackUtilPercent_alarm : {
        display_name          = "network_vcnVnicConntrackUtilPercent_alarm"
        compartment_id        = "SCCA_PARENT_VDSS_CMP"
        destination_topic_ids = ["VDSS-WARNING-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_vcn"
          query            = "VnicConntrackUtilPercent[1m].mean() > 80"
          severity         = "WARNING"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      network_vcnVnicEgressDropThrottle_alarm = {
        display_name          = "network_vcnVnicEgressDropThrottle_alarm"
        compartment_id        = "SCCA_PARENT_VDSS_CMP"
        destination_topic_ids = ["VDSS-WARNING-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_vcn"
          query            = "VnicEgressDropThrottle[1m].mean() > 80"
          severity         = "WARNING"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      network_vcnVnicIngressDropThrottle_alarm = {
        display_name          = "network_vcnVnicIngressDropThrottle_alarm"
        compartment_id        = "SCCA_PARENT_VDSS_CMP"
        destination_topic_ids = ["VDSS-WARNING-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_vcn"
          query            = "VnicIngressDropThrottle[1m].mean() > 80"
          severity         = "WARNING"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
    } : {}

    VDMS-CRITICAL-ALARMS : var.enable_vdms_critical_alarm ? {
      sch_error_alarm : {
        display_name          = "sch_error_alarm"
        compartment_id        = "SCCA_PARENT_VDMS_CMP"
        destination_topic_ids = ["VDMS-CRITICAL-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_service_connector_hub"
          query            = "ServiceConnectorHubErrors[1m].sum() > 0"
          severity         = "CRITICAL"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      stream_putfault_alarm : {
        display_name          = "stream_putfault_alarm"
        compartment_id        = "SCCA_PARENT_VDMS_CMP"
        destination_topic_ids = ["VDMS-CRITICAL-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_streaming"
          query            = "PutMessagesFault.Count[1m].sum() > 0"
          severity         = "CRITICAL"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      stream_getfault_alarm = {
        display_name          = "stream_getfault_alarm"
        compartment_id        = "SCCA_PARENT_VDMS_CMP"
        destination_topic_ids = ["VDMS-CRITICAL-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_streaming"
          query            = "GetMessagesFault.Count[1m].sum() > 0"
          severity         = "CRITICAL"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      vss_SecurityVulnerability_alarm = {
        display_name          = "vss_SecurityVulnerability_alarm"
        compartment_id        = "SCCA_PARENT_VDMS_CMP"
        destination_topic_ids = ["VDMS-CRITICAL-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_vss"
          query            = "SecurityVulnerability[1m].sum() > 0"
          severity         = "CRITICAL"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      network_lbUnHealthyBackendServers_alarm = {
        display_name          = "network_lbUnHealthyBackendServers_alarm"
        compartment_id        = "SCCA_PARENT_VDMS_CMP"
        destination_topic_ids = ["VDMS-CRITICAL-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_lbaas"
          query            = "UnHealthyBackendServers[1m].mean() > 0"
          severity         = "CRITICAL"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      network_lbFailedSSLClientCertVerify_alarm = {
        display_name          = "network_lbFailedSSLClientCertVerify_alarm"
        compartment_id        = "SCCA_PARENT_VDMS_CMP"
        destination_topic_ids = ["VDMS-CRITICAL-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_lbaas"
          query            = "FailedSSLClientCertVerify[1m].mean() > 0"
          severity         = "CRITICAL"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      network_lbFailedSSLHandshake_alarm = {
        display_name          = "network_lbFailedSSLHandshake_alarm"
        compartment_id        = "SCCA_PARENT_VDMS_CMP"
        destination_topic_ids = ["VDMS-CRITICAL-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_lbaas"
          query            = "FailedSSLHandshake[1m].mean() > 0"
          severity         = "CRITICAL"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      network_vcnVnicConntrackIsFull_alarm = {
        display_name          = "network_vcnVnicConntrackIsFull_alarm"
        compartment_id        = "SCCA_PARENT_VDMS_CMP"
        destination_topic_ids = ["VDMS-CRITICAL-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_vcn"
          query            = "VnicConntrackIsFull[1m].mean() > 0"
          severity         = "CRITICAL"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
    } : {}

    VDMS-WARNING-ALARMS : var.enable_vdms_warning_alarm ? {
      bastion_activesession_alarm = {
        display_name          = "bastion_activesession_alarm"
        compartment_id        = "SCCA_PARENT_VDMS_CMP"
        destination_topic_ids = ["VDMS-WARNING-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_bastion"
          query            = "activeSessions[1m].sum() > 0"
          severity         = "WARNING"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      network_lbPeakBandwidth_alarm = {
        display_name          = "network_lbPeakBandwidth_alarm"
        compartment_id        = "SCCA_PARENT_VDMS_CMP"
        destination_topic_ids = ["VDMS-WARNING-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_lbaas"
          query            = "PeakBandwidth[1m].mean() < 8"
          severity         = "WARNING"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      network_vcnVnicConntrackUtilPercent_alarm = {
        display_name          = "network_vcnVnicConntrackUtilPercent_alarm"
        compartment_id        = "SCCA_PARENT_VDMS_CMP"
        destination_topic_ids = ["VDMS-WARNING-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_vcn"
          query            = "VnicConntrackUtilPercent[1m].mean() > 80"
          severity         = "WARNING"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      network_vcnVnicEgressDropThrottle_alarm = {
        display_name          = "network_vcnVnicEgressDropThrottle_alarm"
        compartment_id        = "SCCA_PARENT_VDMS_CMP"
        destination_topic_ids = ["VDMS-WARNING-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_vcn"
          query            = "VnicEgressDropThrottle[1m].mean() > 0"
          severity         = "WARNING"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      network_vcnVnicIngressDropThrottle_alarm = {
        display_name          = "network_vcnVnicIngressDropThrottle_alarm"
        compartment_id        = "SCCA_PARENT_VDMS_CMP"
        destination_topic_ids = ["VDMS-WARNING-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_vcn"
          query            = "VnicIngressDropThrottle[1m].mean() > 0"
          severity         = "WARNING"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
    } : {}
    VDMS-WARNING-LOG-ALARMS : var.enable_vdms_warning_alarm && var.enable_logging_compartment ? {
      objectstorage_UncommittedParts_alarm = {
        display_name          = "objectstorage_UncommittedParts_alarm"
        is_enabled            = false
        compartment_id        = "SCCA_PARENT_VDMS_CMP"
        destination_topic_ids = ["VDMS-WARNING-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_objectstorage"
          query            = "UncommittedParts[1m].count() > 0"
          severity         = "WARNING"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      objectstorage_ClientErrors_alarm = {
        display_name          = "objectstorage_ClientErrors_alarm"
        is_enabled            = var.enable_logging_compartment ? true : false
        compartment_id        = "SCCA_PARENT_VDMS_CMP"
        destination_topic_ids = ["VDMS-WARNING-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_objectstorage"
          query            = "ClientErrors[1m].sum() > 0"
          severity         = "WARNING"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
    } : {}
  }

  alarms_map = merge(
    local.alarms.VDSS-WARNING-ALARMS,
    local.alarms.VDSS-CRITICAL-ALARMS,
    local.alarms.VDMS-WARNING-LOG-ALARMS,
    local.alarms.VDMS-WARNING-ALARMS,
    local.alarms.VDMS-CRITICAL-ALARMS
  )

  #--------------------------------------------------------------------------------------------#
  # Alarms input variables
  #--------------------------------------------------------------------------------------------#
  alarm_policy = {
    "ALARM-POLICY" : {
      name : "OCI-SCCA-LZ-PARENT-Alarm-Policy-${var.resource_label}"
      description : "OCI SCCA Landing Zone PARENT Alarm Policy"
      compartment_id : "SCCA_PARENT_HOME_CMP"
      statements : [
        <<EOT
        Allow group OCI-SCCA-PARENT-DOMAIN-${local.region_key[0]}-${var.resource_label}/NETWORK_ADMIN_PARENT to read metrics in compartment id ${module.scca_compartments[0].compartments["SCCA_PARENT_HOME_CMP"].id} where any {
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

  #--------------------------------------------------------------------------------------------#
  # Logging analytics input variables
  #--------------------------------------------------------------------------------------------#
  logging_analytics_configuration = {
    default_compartment_id    = null
    onboard_logging_analytics = var.onboard_log_analytics,

    log_groups = {
      DEFAULT-LOG-ANALYTICS-LOG-GROUP = {
        type           = "logging_analytics"
        compartment_id = "SCCA_PARENT_VDMS_CMP"
        name           = "PARENT_Default_Group_${var.resource_label}"
        description    = "Logging Analytics Log Group for Default_Group"
      }
      AUDIT-LOG-ANALYTICS-LOG-GROUP = {
        type           = "logging_analytics"
        compartment_id = "SCCA_PARENT_VDMS_CMP"
        name           = "PARENT_Audit_Group_${var.resource_label}"
        description    = "Logging Analytics Log Group for Audit_Group"
      }
    }
  }
  enable_logging_logging_analytics_service_connector = var.enable_logging_compartment ? {
    DEFAULT-LOGGING-ANALYTICS-SERVICE-CONNECTOR = {
      display_name = "schDefaultLog_LA"
      activate       = var.activate_service_connectors
      source       = {
        kind           = "logging"
        non_audit_logs = [{
            cmp_id       = "SCCA_PARENT_LOGGING_CMP"
            log_group_id = module.scca_logging[0].log_groups["DEFAULT_LOG_GROUP"].id
        }]
      }
      target = {
        kind         = "logginganalytics"
        log_group_id = module.logging_analytics.logging_analytics_log_groups["DEFAULT-LOG-ANALYTICS-LOG-GROUP"].id
      }
      policy = {
        name           = "OCI-SCCA-LZ-PARENT-Default-Logging-Analytics-Policy-${var.resource_label}"
        description    = "OCI SCCA Landing Zone Default Logging Analytics Policy"
        compartment-id = "SCCA_PARENT_VDMS_CMP"
      }
    }
  } : {}

  logging_analytics_service_connector = {
    AUDIT-LOGGING-ANALYTICS-SERVICE-CONNECTOR = {
      display_name = "schAuditLog_LA"
      activate       = var.activate_service_connectors
      source       = {
        kind       = "logging"
        audit_logs = [{
          cmp_id = module.scca_compartments[0].compartments["SCCA_PARENT_VDMS_CMP"].id
        }]
      }
      target = {
        kind         = "logginganalytics"
        log_group_id = module.logging_analytics.logging_analytics_log_groups["AUDIT-LOG-ANALYTICS-LOG-GROUP"].id
      }
      policy = {
        name           = "OCI-SCCA-LZ-PARENT-Audit-Logging-Analytics-Policy-${var.resource_label}"
        description    = "OCI SCCA Landing Zone PARENT Audit Logging Analytics Policy"
        compartment_id = "SCCA_PARENT_HOME_CMP"
      }
    }
  }
  logging_analytics_service_connectors_configuration = {
    default_compartment_id = "SCCA_PARENT_VDMS_CMP"
    service_connectors : merge(local.logging_analytics_service_connector, local.enable_logging_logging_analytics_service_connector)
  }


  #--------------------------------------------------------------------------------------------#
  # Monitoring key maps
  #--------------------------------------------------------------------------------------------#

  notifications_configuration = {
    default_compartment_id = null
    topics                 = local.topics
  }

  events_configuration = {
    default_compartment_id = "SCCA_PARENT_VDMS_CMP"
    event_rules            = local.event_rules
  }

  alarms_configuration = {
    default_compartment_id = null
    alarms                 = local.alarms_map
  }

  alarm_policies_configuration = {
    supplied_policies : local.alarm_policy
  }
}
#--------------------------------------------------------------------------------------------#
# Monitoring configurations
#--------------------------------------------------------------------------------------------#

resource "time_sleep" "first_log_delay" {
  depends_on      = [module.scca_logging.service_logs]
  create_duration = "90s"
}

module "notifications" {
  source                      = "github.com/oci-landing-zones/terraform-oci-modules-observability//notifications?ref=v0.1.8"
  notifications_configuration = local.notifications_configuration
  compartments_dependency     = module.scca_compartments[0].compartments
}

module "events" {
  source                  = "github.com/oci-landing-zones/terraform-oci-modules-observability//events?ref=v0.1.8"
  events_configuration    = local.events_configuration
  compartments_dependency = module.scca_compartments[0].compartments
  topics_dependency       = module.notifications.topics
}

module "alarms" {
  source                  = "github.com/oci-landing-zones/terraform-oci-modules-observability//alarms?ref=v0.1.8"
  count                   = length(local.alarms_map) > 0 ? 1 : 0
  alarms_configuration    = local.alarms_configuration
  tenancy_ocid            = var.tenancy_ocid
  compartments_dependency = module.scca_compartments[0].compartments
  topics_dependency       = module.notifications.topics
}

module "alarm_policies" {
  source = "github.com/oci-landing-zones/terraform-oci-modules-iam//policies?ref=v0.2.3"

  count                   = var.enable_vdss_critical_alarm || var.enable_vdss_warning_alarm ? 1 : 0
  tenancy_ocid            = var.tenancy_ocid
  policies_configuration  = local.alarm_policies_configuration
  compartments_dependency = module.scca_compartments[0].compartments
}

module "logging_analytics" {
  source = "github.com/oci-landing-zones/terraform-oci-modules-observability//logging?ref=v0.1.8"

  logging_configuration   = local.logging_analytics_configuration
  compartments_dependency = module.scca_compartments[0].compartments
  tenancy_ocid            = var.tenancy_ocid
}

module "logging_analytics_service_connectors" {
  source = "github.com/oci-landing-zones/terraform-oci-modules-observability//service-connectors?ref=v0.1.8"

  tenancy_ocid                     = var.tenancy_ocid
  service_connectors_configuration = local.logging_analytics_service_connectors_configuration
  compartments_dependency          = module.scca_compartments[0].compartments
  providers = {
    oci      = oci
    oci.home = oci
    oci.secondary_region = oci.secondary_region
  }
  depends_on = [
    time_sleep.first_log_delay
  ]
}
