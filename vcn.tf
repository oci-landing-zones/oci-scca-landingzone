# -----------------------------------------------------------------------------
# Create DRG Resources
# -----------------------------------------------------------------------------
locals {
  drg = {
    drg_display_name = "OCI-SCCA-LZ-VDSS-DRG-HUB-${local.region_key[0]}"
    drg_vcn_attachments = {
      "VDSS-VCN-Attachment" = {
        display_name         = "VDSS-VCN-Attachment"
        vcn_id               = module.vdss_network.vcn_id
        route_table_id       = module.vdss_route_table_ingress.id
        drg_route_table_name = "RT-Hub"
      }
      "VDMS-VCN-Attachment" = {
        display_name         = "VDMS-VCN-Attachment"
        vcn_id               = module.vdms_network.vcn_id
        drg_route_table_name = "RT-Spoke"
      }
      "Workload-VCN-Attachment" = {
        display_name         = "Workload-VCN-Attachment"
        vcn_id               = module.workload_network.vcn_id
        drg_route_table_name = "RT-Spoke"
      }
      "Workload-DB-VCN-Attachment" = {
        display_name         = "Workload-DB-VCN-Attachment"
        vcn_id               = module.workload_db_network.vcn_id
        drg_route_table_name = "RT-Spoke"
      }
    }
    drg_route_table_map = {
      RT-Hub = {
        display_name            = "RT-Hub"
        route_distribution_name = "Import-Hub"
        rules = {
          "vdss" = {
            destination              = var.vdss_vcn_cidr_block
            destination_type         = "CIDR_BLOCK"
            next_hop_attachment_name = "VDSS-VCN-Attachment"
          }
        }
      }
      RT-Spoke = {
        display_name            = "RT-Spoke"
        route_distribution_name = null
        rules = {
          "vdss" = {
            destination              = "0.0.0.0/0"
            destination_type         = "CIDR_BLOCK"
            next_hop_attachment_name = "VDSS-VCN-Attachment"
          }
        }
      }
    }
    route_distribution_map = {
      Import-Hub = {
        distribution_display_name = "Import-Hub"
        distribution_type         = "IMPORT"
        statements = {
          "statement-1" = {
            action              = "ACCEPT"
            match_type          = "DRG_ATTACHMENT_ID" # DRG_ATTACHMENT_ID DRG_ATTACHMENT_TYPE MATCH_ALL 
            attachment_type     = "VCN"
            drg_attachment_name = "VDSS-VCN-Attachment"
            priority            = 1
          }
          "statement-2" = {
            action              = "ACCEPT"
            match_type          = "DRG_ATTACHMENT_ID" # DRG_ATTACHMENT_ID DRG_ATTACHMENT_TYPE MATCH_ALL 
            attachment_type     = "VCN"
            drg_attachment_name = "VDMS-VCN-Attachment"
            priority            = 2
          }
          "statement-3" = {
            action              = "ACCEPT"
            match_type          = "DRG_ATTACHMENT_ID" # DRG_ATTACHMENT_ID DRG_ATTACHMENT_TYPE MATCH_ALL 
            attachment_type     = "VCN"
            drg_attachment_name = "Workload-VCN-Attachment"
            priority            = 3
          }
          "statement-4" = {
            action              = "ACCEPT"
            match_type          = "DRG_ATTACHMENT_ID" # DRG_ATTACHMENT_ID DRG_ATTACHMENT_TYPE MATCH_ALL 
            attachment_type     = "VCN"
            drg_attachment_name = "Workload-DB-VCN-Attachment"
            priority            = 4
          }
        }

      }
    }
  }
}

module "drg" {
  source = "./modules/drg"

  compartment_id         = var.home_region_deployment ? module.vdss_compartment[0].compartment_id : var.secondary_vdss_compartment_ocid
  drg_display_name       = local.drg.drg_display_name
  drg_vcn_attachments    = local.drg.drg_vcn_attachments
  drg_route_table_map    = local.drg.drg_route_table_map
  route_distribution_map = local.drg.route_distribution_map
}

# -----------------------------------------------------------------------------
# Create VDSS Resources
# -----------------------------------------------------------------------------
locals {
  vdss_network = {
    name                     = "OCI-SCCA-LZ-VDSS-VCN-${local.region_key[0]}"
    vcn_dns_label            = "vdssvnc"
    lockdown_default_seclist = false
    subnet_map = {
      OCI-SCCA-LZ-VDSS-SUB1 = {
        name                       = "OCI-SCCA-LZ-VDSS-SUB1-${local.region_key[0]}"
        description                = "VDSS LB Subnet"
        dns_label                  = "lbsubnet"
        cidr_block                 = var.lb_subnet_cidr_block
        prohibit_public_ip_on_vnic = true
      }
      OCI-SCCA-LZ-VDSS-SUB2 = {
        name                       = "OCI-SCCA-LZ-VDSS-SUB2-${local.region_key[0]}"
        description                = "VDSS Firewall Subnet"
        dns_label                  = "firewallsubnet"
        cidr_block                 = var.firewall_subnet_cidr_block
        prohibit_public_ip_on_vnic = true
      }
    }
  }

  vdss_sgw = {
    sgw_display_name         = "OCI-SCCA-VDSS-VCN-${local.region_key[0]}-SGW"
    service_id               = data.oci_core_services.all_oci_services.services[0]["id"]
    route_table_display_name = "SGW-RT"
    route_rules = {
      "all-to-nfw" = {
        network_entity_id = module.network_firewall.firewall_ip_id
        destination       = "0.0.0.0/0"
        destination_type  = "CIDR_BLOCK"
      }
    }
  }

  network_firewall = {
    network_firewall_name                     = "network-firewall"
    network_firewall_policy_name              = "network-firewall-policy"
    network_firewall_policy_address_list_type = "IP"
    ip_address_lists = {
      "vcn-ips" = [var.vdss_vcn_cidr_block]
    }
    security_rules = {
      "reject-all-rule" = {
        security_rules_action                        = "REJECT"
        security_rules_condition_application         = []
        security_rules_condition_destination_address = []
        security_rules_condition_source_address      = []
        security_rules_condition_service             = []
        security_rules_condition_url                 = []
      }
    }
  }

  vdss_route_table_ingress = {
    route_table_display_name = "VDSS-VCN-Ingress"
    route_rules = {
      "all-to-nfw" = {
        network_entity_id = module.network_firewall.firewall_ip_id
        destination       = "0.0.0.0/0"
        destination_type  = "CIDR_BLOCK"
      }
      "local-to-nfw" = {
        network_entity_id = module.network_firewall.firewall_ip_id
        destination       = var.vdss_vcn_cidr_block
        destination_type  = "CIDR_BLOCK"
      }
      "all-service-to-nfw" = {
        network_entity_id = module.network_firewall.firewall_ip_id
        destination       = data.oci_core_services.all_oci_services.services[0]["cidr_block"]
        destination_type  = "SERVICE_CIDR_BLOCK"
      }
    }
  }

  vdss_route_table_default = {
    is_default               = true
    route_table_display_name = "VDSS-Default"
    route_rules = {
      "all-to-nfw" = {
        network_entity_id = module.network_firewall.firewall_ip_id
        destination       = "0.0.0.0/0"
        destination_type  = "CIDR_BLOCK"
      }
      "local-to-nfw" = {
        network_entity_id = module.network_firewall.firewall_ip_id
        destination       = var.vdss_vcn_cidr_block
        destination_type  = "CIDR_BLOCK"
      }
      "all-service-to-nfw" = {
        network_entity_id = module.network_firewall.firewall_ip_id
        destination       = data.oci_core_services.all_oci_services.services[0]["cidr_block"]
        destination_type  = "SERVICE_CIDR_BLOCK"
      }
    }
  }

  vdss_route_table_sub2 = {
    route_table_display_name = "OCI-SCCA-LZ-VDSS-SUB2-${local.region_key[0]}"
    subnet_id                = module.vdss_network.subnets[local.vdss_network.subnet_map["OCI-SCCA-LZ-VDSS-SUB2"].name]
    subnet_name              = "OCI-SCCA-LZ-VDSS-SUB2"
    route_rules = {
      "all-to-drg" = {
        network_entity_id = module.drg.drg_id
        destination       = "0.0.0.0/0"
        destination_type  = "CIDR_BLOCK"
      }
      "sgw-to-os" = {
        network_entity_id = module.vdss_sgw.sgw_id
        destination       = data.oci_core_services.all_oci_services.services[0]["cidr_block"]
        destination_type  = "SERVICE_CIDR_BLOCK"
      }
    }
  }

  vdss_route_table_sub1 = {
    route_table_display_name = "OCI-SCCA-LZ-VDSS-SUB1-${local.region_key[0]}"
    subnet_id                = module.vdss_network.subnets[local.vdss_network.subnet_map["OCI-SCCA-LZ-VDSS-SUB1"].name]
    subnet_name              = "OCI-SCCA-LZ-VDSS-SUB1"
    route_rules = {
      "all-to-nfw" = {
        network_entity_id = module.network_firewall.firewall_ip_id
        destination       = "0.0.0.0/0"
        destination_type  = "CIDR_BLOCK"
      }
    }
  }

  vdss_load_balancer = {
    lb_name   = "OCI-SCCA-LZ-VDSS-LB-${local.region_key[0]}"
    lb_subnet = module.vdss_network.subnets[local.vdss_network.subnet_map["OCI-SCCA-LZ-VDSS-SUB1"].name]
  }
}

module "vdss_network" {
  source = "./modules/vcn"

  vcn_cidr_block           = var.vdss_vcn_cidr_block
  compartment_id           = var.home_region_deployment ? module.vdss_compartment[0].compartment_id : var.secondary_vdss_compartment_ocid
  vcn_display_name         = local.vdss_network.name
  vcn_dns_label            = local.vdss_network.vcn_dns_label
  lockdown_default_seclist = local.vdss_network.lockdown_default_seclist
  subnet_map               = local.vdss_network.subnet_map
}

module "vdss_sgw" {
  source = "./modules/vcn-gateways"

  compartment_id           = var.home_region_deployment ? module.vdss_compartment[0].compartment_id : var.secondary_vdss_compartment_ocid
  service_id               = local.vdss_sgw.service_id
  sgw_display_name         = local.vdss_sgw.sgw_display_name
  route_table_display_name = local.vdss_sgw.route_table_display_name
  route_rules              = local.vdss_sgw.route_rules
  vcn_id                   = module.vdss_network.vcn_id
}

module "network_firewall" {
  source = "./modules/network-firewall"

  compartment_id                            = var.home_region_deployment ? module.vdss_compartment[0].compartment_id : var.secondary_vdss_compartment_ocid
  network_firewall_subnet_id                = module.vdss_network.subnets[local.vdss_network.subnet_map["OCI-SCCA-LZ-VDSS-SUB2"].name]
  network_firewall_name                     = local.network_firewall.network_firewall_name
  network_firewall_policy_name              = local.network_firewall.network_firewall_policy_name
  ip_address_lists                          = local.network_firewall.ip_address_lists
  network_firewall_policy_address_list_type = local.network_firewall.network_firewall_policy_address_list_type
  security_rules                            = local.network_firewall.security_rules
  network_firewall_policy_id                = module.network_firewall.firewall_policy_id
}

module "vdss_route_table_default" {
  source = "./modules/route-table"

  compartment_id           = var.home_region_deployment ? module.vdss_compartment[0].compartment_id : var.secondary_vdss_compartment_ocid
  route_table_display_name = local.vdss_route_table_default.route_table_display_name
  is_default               = local.vdss_route_table_default.is_default
  route_rules              = local.vdss_route_table_default.route_rules
  vcn_id                   = module.vdss_network.vcn_id
  default_route_table_id   = module.vdss_network.vcn.default_route_table_id
}

module "vdss_route_table_ingress" {
  source = "./modules/route-table"

  compartment_id           = var.home_region_deployment ? module.vdss_compartment[0].compartment_id : var.secondary_vdss_compartment_ocid
  route_table_display_name = local.vdss_route_table_ingress.route_table_display_name
  route_rules              = local.vdss_route_table_ingress.route_rules
  vcn_id                   = module.vdss_network.vcn_id

}

module "vdss_route_table_sub1" {
  source = "./modules/route-table"

  compartment_id           = var.home_region_deployment ? module.vdss_compartment[0].compartment_id : var.secondary_vdss_compartment_ocid
  route_table_display_name = local.vdss_route_table_sub1.route_table_display_name
  route_rules              = local.vdss_route_table_sub1.route_rules
  vcn_id                   = module.vdss_network.vcn_id
  subnet_id                = local.vdss_route_table_sub1.subnet_id
  subnet_name              = local.vdss_route_table_sub1.subnet_name
}

module "vdss_route_table_sub2" {
  source = "./modules/route-table"

  compartment_id           = var.home_region_deployment ? module.vdss_compartment[0].compartment_id : var.secondary_vdss_compartment_ocid
  route_table_display_name = local.vdss_route_table_sub2.route_table_display_name
  route_rules              = local.vdss_route_table_sub2.route_rules
  vcn_id                   = module.vdss_network.vcn_id
  subnet_id                = local.vdss_route_table_sub2.subnet_id
  subnet_name              = local.vdss_route_table_sub2.subnet_name
}


module "vdss_load_balancer" {
  source = "./modules/load-balancer"

  compartment_id             = var.home_region_deployment ? module.vdss_compartment[0].compartment_id : var.secondary_vdss_compartment_ocid
  load_balancer_display_name = local.vdss_load_balancer.lb_name
  load_balancer_subnet_ids   = [local.vdss_load_balancer.lb_subnet]
  load_balancer_is_private   = true
  lb_add_waf                 = true
  lb_add_waa                 = true
}

# -----------------------------------------------------------------------------
# Create VDMS Resources
# -----------------------------------------------------------------------------
locals {
  vdms_network = {
    name                     = "OCI-SCCA-LZ-VDMS-VCN-${local.region_key[0]}"
    vcn_dns_label            = "vdmsvnc"
    lockdown_default_seclist = false
    subnet_map = {
      OCI-SCCA-LZ-VDMS-SUB1 = {
        name                       = "OCI-SCCA-LZ-VDMS-SUB-${local.region_key[0]}"
        description                = "VDMS Subnet"
        dns_label                  = "vdmssubnet"
        cidr_block                 = var.vdms_subnet_cidr_block
        prohibit_public_ip_on_vnic = true
      }
    }
  }

  vdms_route_table_egress = {
    route_table_display_name = "VDMS-VCN-Egress"
    subnet_id                = module.vdms_network.subnets[local.vdms_network.subnet_map["OCI-SCCA-LZ-VDMS-SUB1"].name]
    subnet_name              = "OCI-SCCA-LZ-VDMS-SUB1"
    route_rules = {
      "vdss" = {
        network_entity_id = module.drg.drg_id
        destination       = var.vdss_vcn_cidr_block
        destination_type  = "CIDR_BLOCK"
      }
      "workload" = {
        network_entity_id = module.drg.drg_id
        destination       = var.workload_vcn_cidr_block
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

  vdms_load_balancer = {
    lb_name   = "OCI-SCCA-LZ-VDMS-LB-${local.region_key[0]}"
    lb_subnet = module.vdms_network.subnets[local.vdms_network.subnet_map["OCI-SCCA-LZ-VDMS-SUB1"].name]
  }

  vdms_vtap = {
    vtap_display_name           = "OCI-SCCA-LZ-VDMS-VTAP-${local.region_key[0]}"
    vtap_source_type            = "LOAD_BALANCER"
    capture_filter_display_name = "VDMS-VTAP-Capture-Filter"
    vtap_capture_filter_rules = {
      "allow-all" = {
        traffic_direction = "INGRESS"
        rule_action       = "INCLUDE"
        # protocol          = "6" # 1 = ICMP, 6 = TCP, 17 = UDP 
        # source_cidr       = "0.0.0.0/0"
        # destination_cidr  = "0.0.0.0/0"
        # tcp_options = {
        #   "option-1" = {
        #     tcp_options_destination_port_range_max = "81"
        #     tcp_options_destination_port_range_min = "81"
        #     tcp_options_source_port_range_max      = "82"
        #     tcp_options_source_port_range_min      = "82"
        #   }
        # }
      }
    }
    nlb_display_name     = "VDMS-VTAP-NLB"
    nlb_listener_name    = "VDMS-VTAP-NLB-LISTENER"
    nlb_backend_set_name = "VDMS-VTAP-NLB-BACKEND-SET"
  }
}

module "vdms_network" {
  source = "./modules/vcn"

  vcn_cidr_block           = var.vdms_vcn_cidr_block
  compartment_id           = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid
  vcn_display_name         = local.vdms_network.name
  vcn_dns_label            = local.vdms_network.vcn_dns_label
  lockdown_default_seclist = local.vdms_network.lockdown_default_seclist
  subnet_map               = local.vdms_network.subnet_map
}

module "vdms_route_table_egress" {
  source = "./modules/route-table"

  compartment_id           = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid
  route_table_display_name = local.vdms_route_table_egress.route_table_display_name
  route_rules              = local.vdms_route_table_egress.route_rules
  vcn_id                   = module.vdms_network.vcn_id
  subnet_id                = local.vdms_route_table_egress.subnet_id
  subnet_name              = local.vdms_route_table_egress.subnet_name
}

module "vdms_load_balancer" {
  source = "./modules/load-balancer"

  compartment_id             = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid
  load_balancer_display_name = local.vdms_load_balancer.lb_name
  load_balancer_subnet_ids   = [local.vdms_load_balancer.lb_subnet]
  load_balancer_is_private   = true
  lb_add_waf                 = true
  lb_add_waa                 = false
}

module "vdms_vtap" {
  count  = var.is_vtap_enabled ? 1 : 0
  source = "./modules/vtap"

  compartment_id              = var.home_region_deployment ? module.vdms_compartment[0].compartment_id : var.secondary_vdms_compartment_ocid
  vtap_source_type            = local.vdms_vtap.vtap_source_type
  vtap_source_id              = module.vdms_load_balancer.lb_id
  vcn_id                      = module.vdms_network.vcn_id
  vtap_display_name           = local.vdms_vtap.vtap_display_name
  vtap_capture_filter_rules   = local.vdms_vtap.vtap_capture_filter_rules
  is_vtap_enabled             = var.is_vdms_vtap_enabled
  capture_filter_display_name = local.vdms_vtap.capture_filter_display_name
  nlb_display_name            = local.vdms_vtap.nlb_display_name
  nlb_subnet_id               = module.vdms_network.subnets[local.vdms_network.subnet_map["OCI-SCCA-LZ-VDMS-SUB1"].name]
  nlb_listener_name           = local.vdms_vtap.nlb_listener_name
  nlb_backend_set_name        = local.vdms_vtap.nlb_backend_set_name
}
