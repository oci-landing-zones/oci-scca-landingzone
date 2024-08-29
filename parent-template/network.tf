# ###################################################################################################### #
# Copyright (c) 2024 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

locals {
  ######################################################################################################
  #########################               DRG Related Variable               ###########################
  ######################################################################################################
  drg_attachments = {
    VDSS-VCN-Attachment = {
      compartment_id      = "SCCA_PARENT_VDSS_CMP"
      display_name        = "PARENT-VDSS-VCN-Attachment"
      drg_route_table_key = "RT-Hub"
      network_details = {
        type                  = "VCN"
        attached_resource_key = "PARENT-VDSS-VCN"
        route_table_name      = "VDSS-INGRESS"
      }
    }
    VDMS-VCN-Attachment = {
      compartment_id      = "SCCA_PARENT_VDSS_CMP"
      display_name        = "PARENT-VDMS-VCN-Attachment"
      drg_route_table_key = "RT-Spoke"
      network_details = {
        type                  = "VCN"
        attached_resource_key = "PARENT-VDMS-VCN"
      }
    }
  }

  drg_route_tables = {
    RT-Hub = {
      compartment_id                    = "SCCA_PARENT_VDSS_CMP"
      display_name                      = "PARENT-RT-Hub"
      import_drg_route_distribution_key = "Import-Hub"
      route_rules = {
        VDSS-HUB = {
          destination                 = var.vdss_vcn_cidr_block
          destination_type            = "CIDR_BLOCK"
          next_hop_drg_attachment_key = "VDSS-VCN-Attachment"
        }
      }
    }
    RT-Spoke = {
      compartment_id = "SCCA_PARENT_VDSS_CMP"
      display_name   = "PARENT-RT-Spoke"
      route_rules = {
        VDSS-SPOKE = {
          destination                 = "0.0.0.0/0"
          destination_type            = "CIDR_BLOCK"
          next_hop_drg_attachment_key = "VDSS-VCN-Attachment"
        }
      }
    }
    RT-RPC = {
      compartment_id = "SCCA_PARENT_VDSS_CMP"
      display_name   = "PARENT-RPC-RT"
      
      route_rules = var.enable_service_deployment ? {
        RPC-DRG-VDSS = {
          destination                 = var.vdss_vcn_cidr_block
          destination_type            = "CIDR_BLOCK"
          next_hop_drg_attachment_key = "VDSS-VCN-Attachment"
        }
        RPC-DRG-VDMS = {
          destination                 = var.vdms_vcn_cidr_block
          destination_type            = "CIDR_BLOCK"
          next_hop_drg_attachment_key = "VDSS-VCN-Attachment"
        }
        RPC-DRG-CHILD-VDSS = {
          destination                 = var.child_vdss_vcn_cidr
          destination_type            = "CIDR_BLOCK"
          next_hop_drg_attachment_key = "ACCEPTOR-RPC"
        }
        RPC-DRG-CHILD-VDSS = {
          destination                 = var.child_vdms_vcn_cidr
          destination_type            = "CIDR_BLOCK"
          next_hop_drg_attachment_key = "ACCEPTOR-RPC"
        }
      } : {
        RPC-DRG-VDSS = {
          destination                 = var.vdss_vcn_cidr_block
          destination_type            = "CIDR_BLOCK"
          next_hop_drg_attachment_key = "VDSS-VCN-Attachment"
        }
        RPC-DRG-VDMS = {
          destination                 = var.vdms_vcn_cidr_block
          destination_type            = "CIDR_BLOCK"
          next_hop_drg_attachment_key = "VDSS-VCN-Attachment"
        }
      }
    }
  }

  drg_distribution = var.enable_service_deployment ? {
    Import-Hub = {
      display_name      = "Import-Hub"
      distribution_type = "IMPORT"
      statements = {
        STATEMENT-1 = {
          action = "ACCEPT",
          match_criteria = {
            match_type         = "DRG_ATTACHMENT_ID"
            attachment_type    = "VCN"
            drg_attachment_key = "VDSS-VCN-Attachment"
          }
          priority = 1
        }
        STATEMENT-2 = {
          action = "ACCEPT"
          match_criteria = {
            match_type         = "DRG_ATTACHMENT_ID"
            attachment_type    = "VCN"
            drg_attachment_key = "VDMS-VCN-Attachment"
          }
          priority = 2
        }
        STATEMENT-3 = {
          action = "ACCEPT"
          match_criteria = {
            match_type         = "DRG_ATTACHMENT_ID"
            attachment_type    = "RPC"
            drg_attachment_key = "ACCEPTOR-RPC"
          }
          priority = 3
        }
      }
    }
  } : {
    Import-Hub = {
      display_name      = "Import-Hub"
      distribution_type = "IMPORT"
      statements = {
        STATEMENT-1 = {
          action = "ACCEPT",
          match_criteria = {
            match_type         = "DRG_ATTACHMENT_ID"
            attachment_type    = "VCN"
            drg_attachment_key = "VDSS-VCN-Attachment"
          }
          priority = 1
        }
        STATEMENT-2 = {
          action = "ACCEPT"
          match_criteria = {
            match_type         = "DRG_ATTACHMENT_ID"
            attachment_type    = "VCN"
            drg_attachment_key = "VDMS-VCN-Attachment"
          }
          priority = 2
        }
      }
    }
  }

  remote_peering_connections = var.enable_service_deployment ? {
    ACCEPTOR-RPC = {
      compartment_id = "SCCA_PARENT_VDSS_CMP"
      display_name   = "acceptor-rpc"
    }
  } : {}

  drgs = {
    DRG-HUB = {
      compartment_id             = "SCCA_PARENT_VDSS_CMP"
      display_name               = "OCI-SCCA-LZ-PARENT-VDSS-DRG-HUB-${local.region_key[0]}"
      drg_attachments            = local.drg_attachments
      drg_route_tables           = local.drg_route_tables
      drg_route_distributions    = local.drg_distribution
      remote_peering_connections = var.enable_service_deployment ? local.remote_peering_connections : {}
    }
  }
  ######################################################################################################
  ######################          Service Gateway Related Variable              ########################
  ######################################################################################################
  service_gateways = {
    VDSS-SGW = {
      compartment_id           = "SCCA_PARENT_VDSS_CMP"
      display_name             = "OCI-SCCA-PARENT-VDSS-VCN-${local.region_key[0]}-SGW"
      services                 = "all-services"
      route_table_display_name = "PARENT-VDSS-ROUTE-TABLE-SGW"
    }
  }

  ######################################################################################################
  ######################            Route Rules Related Variable                ########################
  ######################################################################################################

  vdss_route_rules = var.enable_service_deployment && var.enable_network_firewall ? {
    workload_route_rules = {
      for index, route in var.workload_additionalsubnets_cidr_blocks != [] ? var.workload_additionalsubnets_cidr_blocks : [] :
      "WORKLOAD-RULE-${index}" => {
        network_entity_id = var.nfw_ip_ocid
        destination       = route
        destination_type  = "CIDR_BLOCK"
      }
    }
    default_route_rules = {
      ALL-TO-NFW = {
        network_entity_id = var.nfw_ip_ocid
        destination       = "0.0.0.0/0"
        destination_type  = "CIDR_BLOCK"
      }
      LOCAL-TO-NFW = {
        network_entity_id = var.nfw_ip_ocid
        destination       = var.vdss_vcn_cidr_block
        destination_type  = "CIDR_BLOCK"
      }
      VDMS-TO-NFW = {
        network_entity_id  = var.nfw_ip_ocid
        destination        = var.vdms_vcn_cidr_block
        destination_type   = "CIDR_BLOCK"
      }
      ALL-SERVICE-TO-NFW = {
        network_entity_id = var.nfw_ip_ocid
        destination       = "all-services"
        destination_type  = "SERVICE_CIDR_BLOCK"
      }
    }
    vdss_route_rules_lb = {
      ALL-TO-NFW = {
        network_entity_id = var.nfw_ip_ocid
        destination       = "0.0.0.0/0"
        destination_type  = "CIDR_BLOCK"
      }
      SGW-TO-OS = {
        network_entity_key = "VDSS-SGW"
        destination        = "all-services"
        destination_type   = "SERVICE_CIDR_BLOCK"
      }
    }
    vdss_route_rules_sgw = {
      ALL-TO-NFW = {
        network_entity_id = var.nfw_ip_ocid
        destination       = "0.0.0.0/0"
        destination_type  = "CIDR_BLOCK"
      }
    }
    } : {
    workload_route_rules = {
      for index, route in var.workload_additionalsubnets_cidr_blocks != [] ? var.workload_additionalsubnets_cidr_blocks : [] :
      "WORKLOAD-RULE-${index}" => {
        network_entity_key = "DRG-HUB"
        destination        = route
        destination_type   = "CIDR_BLOCK"
      }
    }
    default_route_rules = {
      ALL-TO-DRG = {
        network_entity_key = "DRG-HUB"
        destination        = "0.0.0.0/0"
        destination_type   = "CIDR_BLOCK"
      }
      LOCAL-TO-DRG = {
        network_entity_key = "DRG-HUB"
        destination        = var.vdss_vcn_cidr_block
        destination_type   = "CIDR_BLOCK"
      }
      VDMS-TO-DRG = {
        network_entity_key = "DRG-HUB"
        destination        = var.vdms_vcn_cidr_block
        destination_type   = "CIDR_BLOCK"
      }
      ALL-SERVICE-TO-DRG = {
        network_entity_key = "DRG-HUB"
        destination        = "all-services"
        destination_type   = "SERVICE_CIDR_BLOCK"
      }
    }
    vdss_route_rules_lb = {
      ALL-TO-DRG = {
        network_entity_key = "DRG-HUB"
        destination        = "0.0.0.0/0"
        destination_type   = "CIDR_BLOCK"
      }
      SGW-TO-OS = {
        network_entity_key = "VDSS-SGW"
        destination        = "all-services"
        destination_type   = "SERVICE_CIDR_BLOCK"
      }
    }
    vdss_route_rules_sgw = {
      ALL-TO-DRG = {
        network_entity_key = "DRG-HUB"
        destination        = "0.0.0.0/0"
        destination_type   = "CIDR_BLOCK"
      }
    }
  }
  workload_route_rules_vdms = {
    for index, route in var.workload_additionalsubnets_cidr_blocks != [] ? var.workload_additionalsubnets_cidr_blocks : [] : "WORKLOAD-RULE-${index}" => {
      network_entity_key = "DRG-HUB"
      destination        = route
      destination_type   = "CIDR_BLOCK"
    }
  }
  route_table_egress_vdms = {
    VDSS = {
      network_entity_key = "DRG-HUB"
      destination        = var.vdss_vcn_cidr_block
      destination_type   = "CIDR_BLOCK"
    }
    ALL_SERVICES = {
      network_entity_key = "DRG-HUB"
      destination        = "all-services"
      destination_type   = "SERVICE_CIDR_BLOCK"
    }
  }

  ######################################################################################################
  ###################           Route Table Input Related Variable                ######################
  ######################################################################################################

  default_route_table = {
    compartment_id = module.scca_compartments[0].compartments["SCCA_PARENT_VDSS_CMP"].id
    display_name   = "PARENT-VDSS-DEFAULT"
    route_rules    = merge(local.vdss_route_rules.default_route_rules, local.vdss_route_rules.workload_route_rules)
  }

  vdss_route_tables = {
    PARENT-VDSS-ROUTE-TABLE-INGRESS = {
      compartment_id = "SCCA_PARENT_VDSS_CMP"
      display_name   = "PARENT-VDSS-INGRESS"
      route_rules    = merge(local.vdss_route_rules.default_route_rules, local.vdss_route_rules.workload_route_rules)
    }
    PARENT-VDSS-ROUTE-TABLE-LB = {
      compartment_id = "SCCA_PARENT_VDSS_CMP"
      display_name   = "PARENT-VDSS-ROUTE-TABLE-LB-${local.region_key[0]}"
      route_rules    = local.vdss_route_rules.vdss_route_rules_lb
    }
    PARENT-VDSS-ROUTE-TABLE-FW = {
      compartment_id = "SCCA_PARENT_VDSS_CMP"
      display_name   = "PARENT-VDSS-ROUTE-TABLE-FW-${local.region_key[0]}"
      route_rules = {
        ALL-TO-DRG = {
          network_entity_key = "DRG-HUB"
          destination        = "0.0.0.0/0"
          destination_type   = "CIDR_BLOCK"
        }
        SGW-TO-OS = {
          network_entity_key = "VDSS-SGW"
          destination        = "all-services"
          destination_type   = "SERVICE_CIDR_BLOCK"
        }
      }
    }
  }

  PARENT-VDSS-ROUTE-TABLE-SGW = {
    compartment_id = "SCCA_PARENT_VDSS_CMP"
    display_name   = "PARENT-VDSS-ROUTE-TABLE-SGW"
    route_rules    = local.vdss_route_rules.vdss_route_rules_sgw
  }

  vdms_route_tables = {
    PARENT-VDMS-ROUTE-TABLE-EGRESS = {
      compartment_id = "SCCA_PARENT_VDMS_CMP"
      display_name   = "PARENT-VDMS-ROUTE-TABLE-EGRESS"
      route_rules    = merge(local.route_table_egress_vdms, local.workload_route_rules_vdms)
    }
  }

  ######################################################################################################
  ###################                   Subnet Related Variable                   ######################
  ######################################################################################################

  vdss_subnets = {
    PARENT-VDSS-LB-SUBNET = {
      compartment_id             = "SCCA_PARENT_VDSS_CMP"
      display_name               = "PARENT-VDSS-${var.lb_subnet_name}-${local.region_key[0]}"
      description                = "VDSS LB Subnet"
      dns_label                  = var.lb_dns_label
      cidr_block                 = var.lb_subnet_cidr_block
      route_table_key            = "PARENT-VDSS-ROUTE-TABLE-LB"
      prohibit_public_ip_on_vnic = true
    }
    PARENT-VDSS-FW-SUBNET = {
      compartment_id             = "SCCA_PARENT_VDSS_CMP"
      display_name               = "PARENT-VDSS-${var.firewall_subnet_name}-${local.region_key[0]}"
      description                = "VDSS Firewall Subnet"
      dns_label                  = var.firewall_dns_label
      cidr_block                 = var.firewall_subnet_cidr_block
      route_table_key            = "PARENT-VDSS-ROUTE-TABLE-FW"
      prohibit_public_ip_on_vnic = true
    }
  }

  vdms_subnets = {
    PARENT-VDMS-SUBNET = {
      compartment_id             = "SCCA_PARENT_VDMS_CMP"
      display_name               = "PARENT-VDMS-${var.lb_subnet_name}-${local.region_key[0]}"
      description                = "VDMS Subnet"
      dns_label                  = var.vdms_dns_label
      cidr_block                 = var.vdms_subnet_cidr_block
      route_table_key            = "PARENT-VDMS-ROUTE-TABLE-EGRESS"
      prohibit_public_ip_on_vnic = true
    }
  }
  ######################################################################################################
  ###################                VCN Input Related Variable                   ######################
  ######################################################################################################

  vcns = {
    PARENT-VDSS-VCN = {
      compartment_id      = "SCCA_PARENT_VDSS_CMP"
      display_name        = "OCI-SCCA-LZ-PARENT-VDSS-VCN-${local.region_key[0]}"
      dns_label           = "vdssvnc"
      cidr_blocks         = [var.vdss_vcn_cidr_block]
      subnets             = local.vdss_subnets
      default_route_table = local.default_route_table
      route_tables        = local.vdss_route_tables
      vcn_specific_gateways = {
        service_gateways = local.service_gateways
      }
    }
    PARENT-VDMS-VCN = {
      compartment_id = "SCCA_PARENT_VDMS_CMP"
      display_name   = "OCI-SCCA-LZ-PARENT-VDMS-VCN-${local.region_key[0]}"
      dns_label      = "vdmsvcn"
      cidr_blocks    = [var.vdms_vcn_cidr_block]
      subnets        = local.vdms_subnets
      route_tables   = local.vdms_route_tables
    }
  }

  ######################################################################################################
  ###################                   WAF Related Variable                      ######################
  ######################################################################################################

  waf_configuration = {
    waf = {
      PARENT-VDSS-WAF = {
        display_name            = "PARENT-VDSS-webappfirewall"
        backend_type            = "LOAD_BALANCER"
        compartment_id          = "SCCA_PARENT_VDSS_CMP"
        load_balancer_id        = module.scca_networking_lb.provisioned_networking_resources.l7_load_balancers.l7_load_balancers["PARENT-VDSS-LB"].id
        waf_policy_display_name = "WAF_POLICY"
        actions = {
          ACTION-1 = {
            name = "Pre-configured Check Action"
            type = "CHECK"
          }
          ACTION-2 = {
            name = "Pre-configured Allow Action"
            type = "ALLOW"
          }
          ACTION-3 = {
            name = "Pre-configured 401 Response Code Action"
            type = "RETURN_HTTP_RESPONSE"
            body = {
              text = "{\"code\":\"401\",\"message\":\"Unauthorized\"}"
              type = "STATIC_TEXT"
            }
            code = "401"
            header = {
              name  = "Content-Type"
              value = "application/json"
            }
          }
        }
      }
      PARENT-VDMS-WAF = {
        display_name            = "PARENT-VDMS-webappfirewall"
        backend_type            = "LOAD_BALANCER"
        compartment_id          = "SCCA_PARENT_VDMS_CMP"
        load_balancer_id        = module.scca_networking_lb.provisioned_networking_resources.l7_load_balancers.l7_load_balancers["PARENT-VDMS-LB"].id
        waf_policy_display_name = "WAF_POLICY"
        actions = {
          ACTION-1 = {
            name = "Pre-configured Check Action"
            type = "CHECK"
          }
          ACTION-2 = {
            name = "Pre-configured Allow Action"
            type = "ALLOW"
          }
          ACTION-3 = {
            name = "Pre-configured 401 Response Code Action"
            type = "RETURN_HTTP_RESPONSE"
            body = {
              text = "{\"code\":\"401\",\"message\":\"Unauthorized\"}"
              type = "STATIC_TEXT"
            }
            code = "401"
            header = {
              name  = "Content-Type"
              value = "application/json"
            }
          }
        }
      }
    }
  }

  ######################################################################################################
  ###################                   WAA Related Variable                      ######################
  ######################################################################################################

  waa_configuration = {
    web_app_accelerations = {
      PARENT-VDSS-WAA = {
        compartment_id                           = "SCCA_PARENT_VDSS_CMP"
        display_name                             = "PARENT-VDSS-WAA"
        backend_type                             = "LOAD_BALANCER"
        load_balancer_id                         = module.scca_networking_lb.provisioned_networking_resources.l7_load_balancers.l7_load_balancers["PARENT-VDSS-LB"].id
        is_response_header_based_caching_enabled = true
        gzip_compression_is_enabled              = true
      }
    }
  }

  ######################################################################################################
  ###################            Network Firewall Related Variable                ######################
  ######################################################################################################

  network_firewalls_configuration = {
    network_firewalls = {
      PARENT-NFW-KEY = {
        network_firewall_policy_key = "PARENT-NFW-POLICY-KEY"
        compartment_id              = "SCCA_PARENT_VDSS_CMP"
        subnet_id                   = module.scca_networking.provisioned_networking_resources.subnets["PARENT-VDSS-FW-SUBNET"].id
        display_name                = "PARENT-NETWORK-FIREWALL"
      }
    }
    network_firewall_policies = {
      PARENT-NFW-POLICY-KEY = {
        display_name   = "PARENT-NFW_POLICY"
        compartment_id = "SCCA_PARENT_VDSS_CMP"
        ip_address_lists = {
          hubnfw_ip_list = {
            ip_address_list_name  = "vcn-ips"
            ip_address_list_value = [var.vdss_vcn_cidr_block]
          }
        }
        security_rules = {
          PARENT-NFW-SECURITY_RULES-1 = {
            action = "REJECT"
            name   = "reject-all-rule"
            conditions = {
              prd_cond1_A = {
                applications = []
                destinations = []
                sources      = []
                urls         = []
              }
            }
          }
        }
      }
    }
  }

  ######################################################################################################
  ###################                   VTAP Related Variable                     ######################
  ######################################################################################################

  vtap_configuration = {
    default_compartment_id = module.scca_compartments[0].compartments["SCCA_PARENT_VDMS_CMP"].id

    capture_filter = {
      PARENT-DEFAULT-CAPTURE-FILTER = {
        filter_type  = "VTAP"
        display_name = "PARENT-VDMS-VTAP-Capture-Filter"
        vtap_capture_filter_rules = {
          "allow-all" = {
            traffic_direction = "INGRESS"
            rule_action       = "INCLUDE"
          }
        }
      }
    }
    network_load_balancer = {
      PARENT-DEFAULT-NLB = {
        display_name = "PARENT-VDMS-VTAP-NLB"
        subnet_id    = module.scca_networking.provisioned_networking_resources.subnets["PARENT-VDMS-SUBNET"].id
      }
    }
    vtap = {
      PARENT-DEFAULT-VTAP = {
        source_type       = "LOAD_BALANCER"
        source_id         = module.scca_networking_lb.provisioned_networking_resources.l7_load_balancers.l7_load_balancers["PARENT-VDMS-LB"].id
        vcn_id            = module.scca_networking.provisioned_networking_resources.vcns["PARENT-VDMS-VCN"].id
        display_name      = "OCI-SCCA-LZ-PARENT-VDMS-VTAP-${local.region_key[0]}"
        is_vtap_enabled   = false
        target_type       = "NETWORK_LOAD_BALANCER"
        target_id         = "PARENT-DEFAULT-NLB"
        capture_filter_id = "PARENT-DEFAULT-CAPTURE-FILTER"
      }
    }
    network_load_balancer_backend_set = {
      PARENT-DEFAULT-LB-BACKEND-SET = {
        name                     = "PARENT-VDMS-VTAP-NLB-BACKEND-SET"
        network_load_balancer_id = "PARENT-DEFAULT-NLB" # key of network load balancer
        policy                   = "FIVE_TUPLE"
        protocol                 = "TCP"
      }
    }
    network_load_balancer_listener = {
      PARENT-DEFAULT-NLB-LISTENER = {
        default_backend_set_name = "PARENT-DEFAULT-LB-BACKEND-SET" # key of network load balancer backend set
        listener_name            = "PARENT-VDMS-VTAP-NLB-LISTENER"
        network_load_balancer_id = "PARENT-DEFAULT-NLB" # key of network load balancer
        port                     = "4789"
        protocol                 = "UDP"
      }
    }
  }

  ######################################################################################################
  ###################                  Load Balancer Variable                     ######################
  ######################################################################################################

  networking_load_balancer_configuration = {
    default_enable_cis_checks = false
    network_configuration_categories = {
      parent = {
        non_vcn_specific_gateways = {
          l7_load_balancers = {
            PARENT-VDSS-LB = {
              compartment_id = "SCCA_PARENT_VDSS_CMP"
              display_name   = "OCI-SCCA-LZ-PARENT-VDSS-LB"
              shape          = "flexible"
              subnet_ids     = [module.scca_networking.provisioned_networking_resources.subnets["PARENT-VDSS-LB-SUBNET"].id]
              subnet_keys    = null
              ip_mode        = "IPV4"
              is_private     = true
              shape_details = {
                maximum_bandwidth_in_mbps = 30
                minimum_bandwidth_in_mbps = 10
              }
            }
            PARENT-VDMS-LB = {
              compartment_id = "SCCA_PARENT_VDMS_CMP"
              display_name   = "OCI-SCCA-LZ-PARENT-VDMS-LB-${local.region_key[0]}"
              shape          = "flexible"
              subnet_ids     = [module.scca_networking.provisioned_networking_resources.subnets["PARENT-VDMS-SUBNET"].id]
              subnet_keys    = null
              ip_mode        = "IPV4"
              is_private     = true
              shape_details = {
                maximum_bandwidth_in_mbps = 30
                minimum_bandwidth_in_mbps = 10
              }
            }
          }
        }
      }
    }
  }

  ######################################################################################################
  ###################                      Networking Key Map                     ######################
  ######################################################################################################

  network_configuration = {
    default_enable_cis_checks = false
    network_configuration_categories = {
      parent = {
        vcns = local.vcns
        non_vcn_specific_gateways = {
          dynamic_routing_gateways = local.drgs
        }
      }
    }
  }

  network_firewall_network_configuration = {
    default_enable_cis_checks = false
    network_configuration_categories = {
      parent = {
        non_vcn_specific_gateways = {
          network_firewalls_configuration = {
            network_firewalls         = local.network_firewalls_configuration.network_firewalls
            network_firewall_policies = local.network_firewalls_configuration.network_firewall_policies
          }
        }
      }
    }
  }
}

######################################################################################################
###################                 Networking Module Creation                  ######################
######################################################################################################

module "scca_networking" {
  source                  = "github.com/oci-landing-zones/terraform-oci-modules-networking?ref=v0.6.7"
  network_configuration   = local.network_configuration
  compartments_dependency = module.scca_compartments[0].compartments
}

module "scca_networking_firewall" {
  count  = var.enable_network_firewall ? 1 : 0
  source = "github.com/oci-landing-zones/terraform-oci-modules-networking?ref=v0.6.7"

  network_configuration   = local.network_firewall_network_configuration
  compartments_dependency = module.scca_compartments[0].compartments
}

module "scca_networking_lb" {
  source                  = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-networking?ref=v0.6.7"
  network_configuration   = local.networking_load_balancer_configuration
  compartments_dependency = module.scca_compartments[0].compartments
}

module "scca_networking_vtap" {
  count              = var.enable_vtap ? 1 : 0
  source             = "./modules/vtap"
  vtap_configuration = local.vtap_configuration
}

module "scca_networking_waa" {
  count = var.enable_waf ? 1 : 0

  source                  = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-networking/modules/waa"
  waa_configuration       = local.waa_configuration
  compartments_dependency = module.scca_compartments[0].compartments
}

module "scca_networking_waf" {
  count = var.enable_waf ? 1 : 0

  source                  = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-networking/modules/waf"
  waf_configuration       = local.waf_configuration
  compartments_dependency = module.scca_compartments[0].compartments
}