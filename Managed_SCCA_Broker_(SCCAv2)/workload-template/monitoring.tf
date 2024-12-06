# ###################################################################################################### #
# Copyright (c) 2024 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

locals {
  ##############################################################################################
  ####################             TOPICS INPUT VARIABLES           ############################
  ##############################################################################################
  topics = {
    WORKLOAD-CRITICAL-TOPIC : {
      compartment_id = "WKL-CMP"
      name           = "Workload-Critical-${var.resource_label}"
      subscriptions = [
        {
          protocol = "EMAIL"
          values   = var.workload_critical_topic_endpoints
        }
      ]
    }

    WORKLOAD-WARNING-TOPIC : {
      compartment_id = "WKL-CMP"
      name           = "Workload-Warning-${var.resource_label}"
      subscriptions = [
        {
          protocol = "EMAIL"
          values   = var.workload_warning_topic_endpoints
        }
      ]
    }
  }
  ##############################################################################################
  ####################            ALARMS INPUT VARIABLES          #############################
  ##############################################################################################
  alarms = {
    WKL-CRITICAL-ALARMS : var.enable_workload_critical_alarm ? {
      compute_instance_status_alarm : {
        display_name          = "compute_instance_status_alarm"
        compartment_id        = "WKL-CMP"
        destination_topic_ids = ["WORKLOAD-CRITICAL-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_compute_infrastructure_health"
          query            = "instance_status[1m].sum() > 0"
          severity         = "CRITICAL"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      compute_vm_instance_status_alarm : {
        display_name          = "compute_vm_instance_status_alarm"
        compartment_id        = "WKL-CMP"
        destination_topic_ids = ["WORKLOAD-CRITICAL-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_compute_infrastructure_health"
          query            = "maintenance_status[1m].sum() > 0"
          severity         = "CRITICAL"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      compute_bare_metal_unhealthy_alarm : {
        display_name          = "compute_bare_metal_unhealthy_alarm"
        compartment_id        = "WKL-CMP"
        destination_topic_ids = ["WORKLOAD-CRITICAL-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_compute_infrastructure_health"
          query            = "health_status[1m].count() > 0"
          severity         = "CRITICAL"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      compute_high_compute_alarm : {
        display_name          = "compute_high_compute_alarm"
        compartment_id        = "WKL-CMP"
        destination_topic_ids = ["WORKLOAD-CRITICAL-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_computeagent"
          query            = "CpuUtilization[1m].mean() > 80"
          severity         = "CRITICAL"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      compute_high_memory_alarm : {
        display_name          = "compute_high_memory_alarm"
        compartment_id        = "WKL-CMP"
        destination_topic_ids = ["WORKLOAD-CRITICAL-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_computeagent"
          query            = "MemoryUtilization[1m].mean() > 80"
          severity         = "CRITICAL"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      database_adb_cpu_alarm : {
        display_name          = "database_adb_cpu_alarm"
        compartment_id        = "WKL-CMP"
        destination_topic_ids = ["WORKLOAD-CRITICAL-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_autonomous_database"
          query            = "CpuUtilization[1m].mean() > 80"
          severity         = "CRITICAL"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      database_adb_storage_alarm : {
        display_name          = "database_adb_storage_alarm"
        compartment_id        = "WKL-CMP"
        destination_topic_ids = ["WORKLOAD-CRITICAL-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_autonomous_database"
          query            = "StorageUtilization[1m].mean() > 80"
          severity         = "CRITICAL"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      network_lbUnHealthyBackendServers_alarm : {
        display_name          = "network_lbUnHealthyBackendServers_alarm"
        compartment_id        = "WKL-CMP"
        destination_topic_ids = ["WORKLOAD-CRITICAL-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_lbaas"
          query            = "UnHealthyBackendServers[1m].mean() > 0"
          severity         = "CRITICAL"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      network_lbFailedSSLClientCertVerify_alarm : {
        display_name          = "network_lbFailedSSLClientCertVerify_alarm"
        compartment_id        = "WKL-CMP"
        destination_topic_ids = ["WORKLOAD-CRITICAL-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_lbaas"
          query            = "FailedSSLClientCertVerify[1m].mean() > 0"
          severity         = "CRITICAL"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      network_lbFailedSSLHandshake_alarm : {
        display_name          = "network_lbFailedSSLHandshake_alarm"
        compartment_id        = "WKL-CMP"
        destination_topic_ids = ["WORKLOAD-CRITICAL-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_lbaas"
          query            = "FailedSSLHandshake[1m].mean() > 0"
          severity         = "CRITICAL"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      network_vcnVnicConntrackIsFull_alarm : {
        display_name          = "network_vcnVnicConntrackIsFull_alarm"
        compartment_id        = "WKL-CMP"
        destination_topic_ids = ["WORKLOAD-CRITICAL-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_vcn"
          query            = "VnicConntrackIsFull[1m].mean() > 0"
          severity         = "CRITICAL"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
    } : {}
    WKL-WARNING-ALARMS : var.enable_workload_warning_alarm ? {
      objectstorage_UncommittedParts_alarm : {
        display_name          = "objectstorage_UncommittedParts_alarm"
        compartment_id        = "WKL-CMP"
        destination_topic_ids = ["WORKLOAD-WARNING-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_objectstorage"
          query            = "UncommittedParts[1m].count() > 0"
          severity         = "WARNING"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      objectstorage_ClientErrors_alarm : {
        display_name          = "objectstorage_ClientErrors_alarm"
        compartment_id        = "WKL-CMP"
        destination_topic_ids = ["WORKLOAD-WARNING-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_objectstorage"
          query            = "ClientErrors[1m].sum() > 0"
          severity         = "WARNING"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      network_lbPeakBandwidth_alarm : {
        display_name          = "network_lbPeakBandwidth_alarm"
        compartment_id        = "WKL-CMP"
        destination_topic_ids = ["WORKLOAD-WARNING-TOPIC"]
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
        compartment_id        = "WKL-CMP"
        destination_topic_ids = ["WORKLOAD-WARNING-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_vcn"
          query            = "VnicConntrackUtilPercent[1m].mean() > 80"
          severity         = "WARNING"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      network_vcnVnicEgressDropThrottle_alarm : {
        display_name          = "network_vcnVnicEgressDropThrottle_alarm"
        compartment_id        = "WKL-CMP"
        destination_topic_ids = ["WORKLOAD-WARNING-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_vcn"
          query            = "VnicEgressDropThrottle[1m].mean() > 0"
          severity         = "WARNING"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
      network_vcnVnicIngressDropThrottle_alarm : {
        display_name          = "network_vcnVnicIngressDropThrottle_alarm"
        compartment_id        = "WKL-CMP"
        destination_topic_ids = ["WORKLOAD-WARNING-TOPIC"]
        supplied_alarm = {
          namespace        = "oci_vcn"
          query            = "VnicIngressDropThrottle[1m].mean() > 0"
          severity         = "WARNING"
          pending_duration = "PT5M"
          message_format   = "ONS_OPTIMIZED"
        }
      }
    } : {}
  }

  alarms_map = merge(
    local.alarms.WKL-CRITICAL-ALARMS,
    local.alarms.WKL-WARNING-ALARMS
  )

  notifications_configuration = {
    default_compartment_id = null
    topics                 = local.topics
  }

  alarms_configuration = {
    default_compartment_id = null
    alarms                 = local.alarms_map
  }
}

##############################################################################################
###################          TERRAFORM MODULE CREATION           #############################
##############################################################################################
module "notifications" {
  source                      = "github.com/oci-landing-zones/terraform-oci-modules-observability//notifications?ref=v0.1.8"
  notifications_configuration = local.notifications_configuration
  compartments_dependency     = module.workload_compartment.compartments
}

module "alarms" {
  source                  = "github.com/oci-landing-zones/terraform-oci-modules-observability//alarms?ref=v0.1.8"
  count                   = length(local.alarms_map) > 0 ? 1 : 0
  alarms_configuration    = local.alarms_configuration
  tenancy_ocid            = var.tenancy_ocid
  compartments_dependency = module.workload_compartment.compartments
  topics_dependency       = module.notifications.topics
}