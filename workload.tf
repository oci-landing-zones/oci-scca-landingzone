locals {
  workload_compartment = {
    name        = "OCI-SCCA-LZ-${var.workload_name}-${var.mission_owner_key}"
    description = "Workload Compartment"
  }

  workload_network = {
    name                     = "OCI-SCCA-LZ-Workload-VCN-${var.workload_name}-${local.region_key[0]}"
    vcn_dns_label            = "workloadvcn"
    lockdown_default_seclist = false
    subnet_map = {
      OCI-SCCA-LZ-Workload-SUB = {
        name                       = "OCI-SCCA-LZ-Workload-SUB-${var.workload_name}-${local.region_key[0]}"
        description                = "Workload ${var.workload_name} Subnet"
        dns_label                  = "workloadsubnet"
        cidr_block                 = var.workload_subnet_cidr_block
        prohibit_public_ip_on_vnic = true
      }
    }
  }

  workload_db_network = {
    name                     = "OCI-SCCA-LZ-Workload-DB-VCN-${var.workload_name}-${local.region_key[0]}"
    vcn_dns_label            = "workloaddbvcn"
    lockdown_default_seclist = false
    subnet_map = {
      OCI-SCCA-LZ-Workload-DB-SUB = {
        name                       = "OCI-SCCA-LZ-Workload-DB-SUB-${var.workload_name}-${local.region_key[0]}"
        description                = "Workload ${var.workload_name} Subnet"
        dns_label                  = "dbsubnet" # workloaddbsubnet is too long (not 15 chars)
        cidr_block                 = var.workload_db_subnet_cidr_block
        prohibit_public_ip_on_vnic = true
      }
    }
  }

  workload_route_table = {
    Workload-VCN-Egress = {
      route_table_display_name = "Workload-${var.workload_name}-VCN-Egress"
      subnet_id                = module.workload_network.subnets[local.workload_network.subnet_map["OCI-SCCA-LZ-Workload-SUB"].name]
      subnet_name              = "OCI-SCCA-LZ-Workload-SUB"
      route_rules = {
        "vdss" = {
          network_entity_id = module.drg.drg_id
          destination       = var.vdss_vcn_cidr_block
          destination_type  = "CIDR_BLOCK"
        }
        "vdms" = {
          network_entity_id = module.drg.drg_id
          destination       = var.vdms_vcn_cidr_block
          destination_type  = "CIDR_BLOCK"
        }
        "workload_db" = {
          network_entity_id = module.drg.drg_id
          destination       = var.workload_db_vcn_cidr_block
          destination_type  = "CIDR_BLOCK"
        }
        "all_service" = {
          network_entity_id = module.drg.drg_id
          destination       = data.oci_core_services.all_oci_services.services[0]["cidr_block"]
          destination_type  = "SERVICE_CIDR_BLOCK"
        }
      }
    }
  }

  workload_db_route_table = {
    Workload-DB-VCN-Egress = {
      route_table_display_name = "Workload-${var.workload_name}-DB-VCN-Egress"
      subnet_id                = module.workload_db_network.subnets[local.workload_db_network.subnet_map["OCI-SCCA-LZ-Workload-DB-SUB"].name]
      subnet_name              = "OCI-SCCA-LZ-Workload-DB-SUB"
      route_rules = {
        "vdss" = {
          network_entity_id = module.drg.drg_id
          destination       = var.vdss_vcn_cidr_block
          destination_type  = "CIDR_BLOCK"
        }
        "vdms" = {
          network_entity_id = module.drg.drg_id
          destination       = var.vdms_vcn_cidr_block
          destination_type  = "CIDR_BLOCK"
        }
        "workload" = {
          network_entity_id = module.drg.drg_id
          destination       = var.workload_vcn_cidr_block
          destination_type  = "CIDR_BLOCK"
        }
        "all_service" = {
          network_entity_id = module.drg.drg_id
          destination       = data.oci_core_services.all_oci_services.services[0]["cidr_block"]
          destination_type  = "SERVICE_CIDR_BLOCK"
        }
      }
    }
  }

  workload_load_balancer = {
    lb_name   = "OCI-SCCA-LZ-Workload-LB-${var.workload_name}-${local.region_key[0]}"
    lb_subnet = module.workload_network.subnets[local.workload_network.subnet_map["OCI-SCCA-LZ-Workload-SUB"].name]
  }

  workload_vtap = {
    vtap_display_name           = "OCI-SCCA-LZ-WORKLOAD-VTAP-${local.region_key[0]}"
    vtap_source_type            = "LOAD_BALANCER"
    capture_filter_display_name = "WORKLOAD-VTAP-Capture-Filter"
    vtap_capture_filter_rules = {
      "allow-all" = {
        traffic_direction = "INGRESS"
        rule_action       = "INCLUDE"
      }
    }
    nlb_display_name     = "WORKLOAD-VTAP-NLB"
    nlb_listener_name    = "WORKLOAD-VTAP-NLB-LISTENER"
    nlb_backend_set_name = "WORKLOAD-VTAP-NLB-BACKEND-SET"
  }
}

# -----------------------------------------------------------------------------
# Create workload compartment, for top level organization
# -----------------------------------------------------------------------------
module "workload_compartment" {
  source = "./modules/compartment"

  compartment_parent_id     = module.home_compartment.compartment_id
  compartment_name          = local.workload_compartment.name
  compartment_description   = local.workload_compartment.description
  enable_compartment_delete = var.enable_compartment_delete

  providers = {
    oci = oci.home_region
  }
}

module "workload_network" {
  source = "./modules/vcn"

  vcn_cidr_block           = var.workload_vcn_cidr_block
  compartment_id           = module.workload_compartment.compartment_id
  vcn_display_name         = local.workload_network.name
  vcn_dns_label            = local.workload_network.vcn_dns_label
  lockdown_default_seclist = local.workload_network.lockdown_default_seclist
  subnet_map               = local.workload_network.subnet_map
}

module "workload_db_network" {
  source = "./modules/vcn"

  vcn_cidr_block           = var.workload_db_vcn_cidr_block
  compartment_id           = module.workload_compartment.compartment_id
  vcn_display_name         = local.workload_db_network.name
  vcn_dns_label            = local.workload_db_network.vcn_dns_label
  lockdown_default_seclist = local.workload_db_network.lockdown_default_seclist
  subnet_map               = local.workload_db_network.subnet_map
}

module "workload_route_table" {
  source = "./modules/route-table"

  for_each                 = local.workload_route_table
  compartment_id           = module.workload_compartment.compartment_id
  route_table_display_name = each.value.route_table_display_name
  route_rules              = each.value.route_rules
  vcn_id                   = module.workload_network.vcn_id
  subnet_id                = each.value.subnet_id
  subnet_name              = each.value.subnet_name
}

module "workload_db_route_table" {
  source = "./modules/route-table"

  for_each                 = local.workload_db_route_table
  compartment_id           = module.workload_compartment.compartment_id
  route_table_display_name = each.value.route_table_display_name
  route_rules              = each.value.route_rules
  vcn_id                   = module.workload_db_network.vcn_id
  subnet_id                = each.value.subnet_id
  subnet_name              = each.value.subnet_name
}

module "workload_load_balancer" {
  source = "./modules/load-balancer"

  compartment_id             = module.workload_compartment.compartment_id
  load_balancer_display_name = local.workload_load_balancer.lb_name
  load_balancer_subnet_ids   = [local.workload_load_balancer.lb_subnet]
  load_balancer_is_private   = true
  lb_add_waf                 = true
  lb_add_waa                 = true
}

module "workload_vtap" {
  count  = var.is_vtap_enabled ? 1 : 0
  source = "./modules/vtap"

  compartment_id              = module.vdms_compartment.compartment_id
  vtap_source_type            = local.workload_vtap.vtap_source_type
  vtap_source_id              = module.workload_load_balancer.lb_id
  vcn_id                      = module.workload_network.vcn_id
  vtap_display_name           = local.workload_vtap.vtap_display_name
  vtap_capture_filter_rules   = local.workload_vtap.vtap_capture_filter_rules
  is_vtap_enabled             = var.is_workload_vtap_enabled
  capture_filter_display_name = local.workload_vtap.capture_filter_display_name
  nlb_display_name            = local.workload_vtap.nlb_display_name
  nlb_subnet_id               = module.workload_network.subnets[local.workload_network.subnet_map["OCI-SCCA-LZ-Workload-SUB"].name]
  nlb_listener_name           = local.workload_vtap.nlb_listener_name
  nlb_backend_set_name        = local.workload_vtap.nlb_backend_set_name
}

locals {
  workload_critical_topic = {
    topic_name            = "Workload-Critical-${var.resource_label}"
    topic_description     = "Critical notification for Workload"
    subscription_protocol = "EMAIL"
  }
  workload_warning_topic = {
    topic_name            = "Workload-Warning-${var.resource_label}"
    topic_description     = "Warning notification for Workload"
    subscription_protocol = "EMAIL"
  }
}

module "workload_critical_topic" {
  source = "./modules/notification-topic"

  compartment_id        = module.workload_compartment.compartment_id
  topic_name            = local.workload_critical_topic.topic_name
  topic_description     = local.workload_critical_topic.topic_description
  subscription_endpoint = var.workload_critical_topic_endpoints
  subscription_protocol = local.workload_critical_topic.subscription_protocol
}

module "workload_warning_topic" {
  source = "./modules/notification-topic"

  compartment_id        = module.workload_compartment.compartment_id
  topic_name            = local.workload_warning_topic.topic_name
  topic_description     = local.workload_warning_topic.topic_description
  subscription_endpoint = var.workload_warning_topic_endpoints
  subscription_protocol = local.workload_warning_topic.subscription_protocol
}

# -----------------------------------------------------------------------------
# Alarms
# -----------------------------------------------------------------------------
locals {
  workload_critical_alarms = {
    metric_compartment_id_in_subtree = false
    is_enabled                       = var.enable_workload_critical_alarm
    message_format                   = "ONS_OPTIMIZED"
    pending_duration                 = "PT5M"

    alarm_map = {
      compute_instance_status_alarm = {
        display_name          = "compute_instance_status_alarm"
        metric_compartment_id = module.workload_compartment.compartment_id
        namespace             = "oci_compute_infrastructure_health"
        query                 = "instance_status[1m].sum() > 0"
        severity              = "CRITICAL"
      }
      compute_vm_instance_status_alarm = {
        display_name          = "compute_vm_instance_status_alarm"
        metric_compartment_id = module.workload_compartment.compartment_id
        namespace             = "oci_compute_infrastructure_health"
        query                 = "maintenance_status[1m].sum() > 0"
        severity              = "CRITICAL"
      }
      compute_bare_metal_unhealthy_alarm = {
        display_name          = "compute_bare_metal_unhealthy_alarm"
        metric_compartment_id = module.workload_compartment.compartment_id
        namespace             = "oci_compute_infrastructure_health"
        query                 = "health_status[1m].count() > 0"
        severity              = "CRITICAL"
      }
      compute_high_compute_alarm = {
        display_name          = "compute_high_compute_alarm"
        metric_compartment_id = module.workload_compartment.compartment_id
        namespace             = "oci_computeagent"
        query                 = "CpuUtilization[1m].mean() > 80"
        severity              = "CRITICAL"
      }
      compute_high_memory_alarm = {
        display_name          = "compute_high_memory_alarm"
        metric_compartment_id = module.workload_compartment.compartment_id
        namespace             = "oci_computeagent"
        query                 = "MemoryUtilization[1m].mean() > 80"
        severity              = "CRITICAL"
      }
      database_adb_cpu_alarm = {
        display_name          = "database_adb_cpu_alarm"
        metric_compartment_id = module.workload_compartment.compartment_id
        namespace             = "oci_autonomous_database"
        query                 = "CpuUtilization[1m].mean() > 80"
        severity              = "CRITICAL"
      }
      database_adb_storage_alarm = {
        display_name          = "database_adb_storage_alarm"
        metric_compartment_id = module.workload_compartment.compartment_id
        namespace             = "oci_autonomous_database"
        query                 = "StorageUtilization[1m].mean() > 80"
        severity              = "CRITICAL"
      }
      network_lbUnHealthyBackendServers_alarm = {
        display_name          = "network_lbUnHealthyBackendServers_alarm"
        metric_compartment_id = module.workload_compartment.compartment_id
        namespace             = "oci_lbaas"
        query                 = "UnHealthyBackendServers[1m].mean() > 0"
        severity              = "CRITICAL"
      }
      network_lbFailedSSLClientCertVerify_alarm = {
        display_name          = "network_lbFailedSSLClientCertVerify_alarm"
        metric_compartment_id = module.workload_compartment.compartment_id
        namespace             = "oci_lbaas"
        query                 = "FailedSSLClientCertVerify[1m].mean() > 0"
        severity              = "CRITICAL"
      }
      network_lbFailedSSLHandshake_alarm = {
        display_name          = "network_lbFailedSSLHandshake_alarm"
        metric_compartment_id = module.workload_compartment.compartment_id
        namespace             = "oci_lbaas"
        query                 = "FailedSSLHandshake[1m].mean() > 0"
        severity              = "CRITICAL"
      }
      network_vcnVnicConntrackIsFull_alarm = {
        display_name          = "network_vcnVnicConntrackIsFull_alarm"
        metric_compartment_id = module.workload_compartment.compartment_id
        namespace             = "oci_vcn"
        query                 = "VnicConntrackIsFull[1m].mean() > 0"
        severity              = "CRITICAL"
      }
    }
  }

  workload_warning_alarms = {
    metric_compartment_id_in_subtree = false
    is_enabled                       = var.enable_workload_warning_alarm
    message_format                   = "ONS_OPTIMIZED"
    pending_duration                 = "PT5M"

    alarm_map = {
      objectstorage_UncommittedParts_alarm = {
        display_name          = "objectstorage_UncommittedParts_alarm"
        metric_compartment_id = module.workload_compartment.compartment_id
        namespace             = "oci_objectstorage"
        query                 = "UncommittedParts[1m].count() > 0"
        severity              = "WARNING"
      }
      objectstorage_ClientErrors_alarm = {
        display_name          = "objectstorage_ClientErrors_alarm"
        metric_compartment_id = module.workload_compartment.compartment_id
        namespace             = "oci_objectstorage"
        query                 = "ClientErrors[1m].sum() > 0"
        severity              = "WARNING"
      }
      network_lbPeakBandwidth_alarm = {
        display_name          = "network_lbPeakBandwidth_alarm"
        metric_compartment_id = module.workload_compartment.compartment_id
        namespace             = "oci_lbaas"
        query                 = "PeakBandwidth[1m].mean() < 8"
        severity              = "WARNING"
      }
      network_vcnVnicConntrackUtilPercent_alarm = {
        display_name          = "network_vcnVnicConntrackUtilPercent_alarm"
        metric_compartment_id = module.workload_compartment.compartment_id
        namespace             = "oci_vcn"
        query                 = "VnicConntrackUtilPercent[1m].mean() > 80"
        severity              = "WARNING"
      }
      network_vcnVnicEgressDropThrottle_alarm = {
        display_name          = "network_vcnVnicEgressDropThrottle_alarm"
        metric_compartment_id = module.workload_compartment.compartment_id
        namespace             = "oci_vcn"
        query                 = "VnicEgressDropThrottle[1m].mean() > 0"
        severity              = "WARNING"
      }
      network_vcnVnicIngressDropThrottle_alarm = {
        display_name          = "network_vcnVnicIngressDropThrottle_alarm"
        metric_compartment_id = module.workload_compartment.compartment_id
        namespace             = "oci_vcn"
        query                 = "VnicIngressDropThrottle[1m].mean() > 0"
        severity              = "WARNING"
      }
    }
  }
}

module "workload_critical_alarms" {
  source = "./modules/alarm"

  compartment_id                   = module.workload_compartment.compartment_id
  notification_topic_id            = module.workload_critical_topic.topic_id
  is_enabled                       = local.workload_critical_alarms.is_enabled
  message_format                   = local.workload_critical_alarms.message_format
  pending_duration                 = local.workload_critical_alarms.pending_duration
  metric_compartment_id_in_subtree = local.workload_critical_alarms.metric_compartment_id_in_subtree
  alarm_map                        = local.workload_critical_alarms.alarm_map
}

module "workload_warning_alarms" {
  source = "./modules/alarm"

  compartment_id                   = module.workload_compartment.compartment_id
  notification_topic_id            = module.workload_warning_topic.topic_id
  is_enabled                       = local.workload_warning_alarms.is_enabled
  message_format                   = local.workload_warning_alarms.message_format
  pending_duration                 = local.workload_warning_alarms.pending_duration
  metric_compartment_id_in_subtree = local.workload_warning_alarms.metric_compartment_id_in_subtree
  alarm_map                        = local.workload_warning_alarms.alarm_map
}
