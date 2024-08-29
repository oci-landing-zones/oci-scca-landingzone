# ###################################################################################################### #
# Copyright (c) 2024 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

locals {
  #--------------------------------------------------------------------------------------------#
  # DRG input variables
  #--------------------------------------------------------------------------------------------#
  drg_attachments = {
    VDSS-VCN-Attachment = {
      compartment_id      = "SCCA_CHILD_VDSS_CMP"
      display_name        = var.deployment_type == "SINGLE" ? "VDSS-VCN-Attachment" : "CHILD-VDSS-VCN-Attachment"
      drg_route_table_key = "RT-Hub"
      network_details = {
        type                  = "VCN"
        attached_resource_key = "CHILD-VDSS-VCN"
        route_table_name      = "VDSS-INGRESS"
      }
    }
    VDMS-VCN-Attachment = {
      compartment_id      = "SCCA_CHILD_VDSS_CMP"
      display_name        = var.deployment_type == "SINGLE" ? "VDMS-VCN-Attachment" : "CHILD-VDMS-VCN-Attachment"
      drg_route_table_key = "RT-Spoke"
      network_details = {
        type                  = "VCN"
        attached_resource_key = "CHILD-VDMS-VCN"
      }
    }
  }

  drg_route_tables = {
    RT-Hub = {
      compartment_id                    = "SCCA_CHILD_VDSS_CMP"
      display_name                      = var.deployment_type == "SINGLE" ? "RT-Hub" : "CHILD-RT-Hub"
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
      compartment_id = "SCCA_CHILD_VDSS_CMP"
      display_name   = var.deployment_type == "SINGLE" ? "RT-Spoke" : "CHILD-RT-Spoke"
      route_rules = {
        VDSS-SPOKE = {
          destination                 = "0.0.0.0/0"
          destination_type            = "CIDR_BLOCK"
          next_hop_drg_attachment_key = "VDSS-VCN-Attachment"
        }
      }
    }
  }

  drg_distribution = {
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

  drgs = {
    DRG-HUB = {
      compartment_id          = "SCCA_CHILD_VDSS_CMP"
      display_name            = var.deployment_type == "SINGLE" ? "OCI-SCCA-LZ-VDSS-DRG-HUB-${local.region_key[0]}" : "OCI-SCCA-LZ-CHILD-VDSS-DRG-HUB-${local.region_key[0]}"
      drg_attachments         = local.drg_attachments
      drg_route_tables        = local.drg_route_tables
      drg_route_distributions = local.drg_distribution
    }
  }
  #--------------------------------------------------------------------------------------------#
  # Service gateway input variables
  #--------------------------------------------------------------------------------------------#
  service_gateways = {
    VDSS-SGW = {
      compartment_id           = "SCCA_CHILD_VDSS_CMP"
      display_name             = var.deployment_type == "SINGLE" ? "OCI-SCCA-VDSS-VCN-${local.region_key[0]}-SGW" : "OCI-SCCA-CHILD-VDSS-VCN-${local.region_key[0]}-SGW"
      services                 = "all-services"
      route_table_display_name = "CHILD-VDSS-ROUTE-TABLE-SGW"
    }
  }
  #--------------------------------------------------------------------------------------------#
  # Route rules input variables
  #--------------------------------------------------------------------------------------------#
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
        network_entity_id = var.nfw_ip_ocid
        destination       = var.vdms_vcn_cidr_block
        destination_type  = "CIDR_BLOCK"
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

  #--------------------------------------------------------------------------------------------#
  # Route table input variables
  #--------------------------------------------------------------------------------------------#
  default_route_table = {
    compartment_id = module.scca_compartments[0].compartments["SCCA_CHILD_VDSS_CMP"].id
    display_name   = var.deployment_type == "SINGLE" ? "VDSS-DEFAULT-RT" : "CHILD-VDSS-DEFAULT-RT"
    route_rules    = merge(local.vdss_route_rules.default_route_rules, local.vdss_route_rules.workload_route_rules)
  }

  vdss_route_tables = {
    CHILD-VDSS-ROUTE-TABLE-INGRESS = {
      compartment_id = "SCCA_CHILD_VDSS_CMP"
      display_name   = var.deployment_type == "SINGLE" ? "VDSS-INGRESS-RT" : "CHILD-VDSS-INGRESS-RT"
      route_rules    = merge(local.vdss_route_rules.default_route_rules, local.vdss_route_rules.workload_route_rules)
    }
    CHILD-VDSS-ROUTE-TABLE-LB = {
      compartment_id = "SCCA_CHILD_VDSS_CMP"
      display_name   = var.deployment_type == "SINGLE" ? "VDSS-ROUTE-TABLE-LB-${local.region_key[0]}" : "CHILD-VDSS-ROUTE-TABLE-LB-${local.region_key[0]}"
      route_rules    = local.vdss_route_rules.vdss_route_rules_lb
    }
    CHILD-VDSS-ROUTE-TABLE-FW = {
      compartment_id = "SCCA_CHILD_VDSS_CMP"
      display_name   = var.deployment_type == "SINGLE" ? "VDSS-ROUTE-TABLE-FW-${local.region_key[0]}" : "CHILD-VDSS-ROUTE-TABLE-FW-${local.region_key[0]}"
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

  CHILD-VDSS-ROUTE-TABLE-SGW = {
    compartment_id = "SCCA_CHILD_VDSS_CMP"
    display_name   = var.deployment_type == "SINGLE" ? "VDSS-ROUTE-TABLE-SGW" : "CHILD-VDSS-ROUTE-TABLE-SGW"
    route_rules    = local.vdss_route_rules.vdss_route_rules_sgw
  }

  vdms_route_tables = {
    CHILD-VDMS-ROUTE-TABLE-EGRESS = {
      compartment_id = "SCCA_CHILD_VDMS_CMP"
      display_name   = var.deployment_type == "SINGLE" ? "VDMS-ROUTE-TABLE-EGRESS" : "CHILD-VDMS-ROUTE-TABLE-EGRESS"
      route_rules    = merge(local.route_table_egress_vdms, local.workload_route_rules_vdms)
    }
  }
  single_lb_subnet_name       = "OCI-SCCA-LZ-VDSS-LB-SUBNET"
  single_firewall_subnet_name = "OCI-SCCA-LZ-VDSS-FW-SUBNET"
  single_vdms_subnet_name     = "OCI-SCCA-LZ-VDMS-LB-SUBNET"

  #--------------------------------------------------------------------------------------------#
  # Subnet input variables
  #--------------------------------------------------------------------------------------------#
  vdss_subnets = {
    CHILD-VDSS-LB-SUBNET = {
      compartment_id             = "SCCA_CHILD_VDSS_CMP"
      display_name               = var.deployment_type == "SINGLE" ? "${local.single_lb_subnet_name}-${local.region_key[0]}" : "${var.lb_subnet_name}-${local.region_key[0]}"
      description                = "VDSS LB Subnet"
      dns_label                  = var.lb_dns_label
      cidr_block                 = var.lb_subnet_cidr_block
      route_table_key            = "CHILD-VDSS-ROUTE-TABLE-LB"
      prohibit_public_ip_on_vnic = true
    }
    CHILD-VDSS-FW-SUBNET = {
      compartment_id             = "SCCA_CHILD_VDSS_CMP"
      display_name               = var.deployment_type == "SINGLE" ? "${local.single_firewall_subnet_name}-${local.region_key[0]}" : "${var.firewall_subnet_name}-${local.region_key[0]}"
      description                = "VDSS Firewall Subnet"
      dns_label                  = var.firewall_dns_label
      cidr_block                 = var.firewall_subnet_cidr_block
      route_table_key            = "CHILD-VDSS-ROUTE-TABLE-FW"
      prohibit_public_ip_on_vnic = true
    }
  }

  vdms_subnets = {
    CHILD-VDMS-SUBNET = {
      compartment_id             = "SCCA_CHILD_VDMS_CMP"
      display_name               = var.deployment_type == "SINGLE" ? "${local.single_vdms_subnet_name}-${local.region_key[0]}" : "${var.vdms_subnet_name}-${local.region_key[0]}"
      description                = "VDMS Subnet"
      dns_label                  = var.vdms_dns_label
      cidr_block                 = var.vdms_subnet_cidr_block
      route_table_key            = "CHILD-VDMS-ROUTE-TABLE-EGRESS"
      prohibit_public_ip_on_vnic = true
    }
  }
  #--------------------------------------------------------------------------------------------#
  # VCN input variables
  #--------------------------------------------------------------------------------------------#
  vcns = {
    CHILD-VDSS-VCN = {
      compartment_id = "SCCA_CHILD_VDSS_CMP"
      display_name   = var.deployment_type == "SINGLE" ? "OCI-SCCA-LZ-VDSS-VCN-${local.region_key[0]}" : "OCI-SCCA-LZ-CHILD-VDSS-VCN-${local.region_key[0]}"
      dns_label      = "vdssvnc"
      cidr_blocks    = [var.vdss_vcn_cidr_block]

      subnets             = local.vdss_subnets
      default_route_table = local.default_route_table
      route_tables        = local.vdss_route_tables
      vcn_specific_gateways = {
        service_gateways = local.service_gateways
      }
    }
    CHILD-VDMS-VCN = {
      compartment_id = "SCCA_CHILD_VDMS_CMP"
      display_name   = var.deployment_type == "SINGLE" ? "OCI-SCCA-LZ-VDMS-VCN-${local.region_key[0]}" : "OCI-SCCA-LZ-CHILD-VDMS-VCN-${local.region_key[0]}"
      dns_label      = "vdmsvcn"
      cidr_blocks    = [var.vdms_vcn_cidr_block]

      subnets      = local.vdms_subnets
      route_tables = local.vdms_route_tables
    }
  }
  #--------------------------------------------------------------------------------------------#
  # WAF configurations
  #--------------------------------------------------------------------------------------------#
  waf_configuration = {
    waf = {
      CHILD-VDSS-WAF = {
        display_name            = var.deployment_type == "SINGLE" ? "VDSS-webappfirewall" : "CHILD-VDSS-webappfirewall"
        backend_type            = "LOAD_BALANCER"
        compartment_id          = "SCCA_CHILD_VDSS_CMP"
        load_balancer_id        = module.scca_networking_lb.provisioned_networking_resources.l7_load_balancers.l7_load_balancers["CHILD-VDSS-LB"].id
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
      CHILD-VDMS-WAF = {
        display_name            = var.deployment_type == "SINGLE" ? "VDMS-webappfirewall" : "CHILD-VDMS-webappfirewall"
        backend_type            = "LOAD_BALANCER"
        compartment_id          = "SCCA_CHILD_VDMS_CMP"
        load_balancer_id        = module.scca_networking_lb.provisioned_networking_resources.l7_load_balancers.l7_load_balancers["CHILD-VDMS-LB"].id
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
  #--------------------------------------------------------------------------------------------#
  # WAA configurations
  #--------------------------------------------------------------------------------------------#
  waa_configuration = {
    web_app_accelerations = {
      CHILD-VDSS-WAA = {
        compartment_id                           = "SCCA_CHILD_VDSS_CMP"
        display_name                             = var.deployment_type == "SINGLE" ? "VDSS-WAA" : "CHILD-VDSS-WAA"
        backend_type                             = "LOAD_BALANCER"
        load_balancer_id                         = module.scca_networking_lb.provisioned_networking_resources.l7_load_balancers.l7_load_balancers["CHILD-VDSS-LB"].id
        is_response_header_based_caching_enabled = true
        gzip_compression_is_enabled              = true
      }
    }
  }
  #--------------------------------------------------------------------------------------------#
  # Network firewall configurations
  #--------------------------------------------------------------------------------------------#
  network_firewalls_configuration = {
    network_firewalls = {
      CHILD-NFW-KEY = {
        network_firewall_policy_key = "CHILD-NFW-POLICY-KEY"
        compartment_id              = "SCCA_CHILD_VDSS_CMP"
        subnet_id                   = module.scca_networking.provisioned_networking_resources.subnets["CHILD-VDSS-FW-SUBNET"].id
        display_name                = var.deployment_type == "SINGLE" ? "NETWORK-FIREWALL" : "CHILD-NETWORK-FIREWALL"
      }
    }
    network_firewall_policies = {
      CHILD-NFW-POLICY-KEY = {
        display_name   = "CHILD-NFW_POLICY"
        compartment_id = "SCCA_CHILD_VDSS_CMP"
        ip_address_lists = {
          hubnfw_ip_list = {
            ip_address_list_name  = "vcn-ips"
            ip_address_list_value = [var.vdss_vcn_cidr_block]
          }
        }
        security_rules = {
          CHILD-NFW-SECURITY_RULES-1 = {
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

  #--------------------------------------------------------------------------------------------#
  # VTAP configurations
  #--------------------------------------------------------------------------------------------#
  vtap_configuration = {
    default_compartment_id = module.scca_compartments[0].compartments["SCCA_CHILD_VDMS_CMP"].id

    capture_filters = {
      CHILD-DEFAULT-CAPTURE-FILTER = {
        filter_type  = "VTAP"
        display_name = var.deployment_type == "SINGLE" ? "VDMS-VTAP-Capture-Filter" : "CHILD-VDMS-VTAP-Capture-Filter"
        vtap_capture_filter_rules = {
          "allow-all" = {
            traffic_direction = "INGRESS"
            rule_action       = "INCLUDE"
          }
        }
      }
    }

    network_load_balancers = {
      CHILD-DEFAULT-NLB = {
        display_name = var.deployment_type == "SINGLE" ? "VDMS-VTAP-NLB" : "CHILD-VDMS-VTAP-NLB"
        subnet_id    = module.scca_networking.provisioned_networking_resources.subnets["CHILD-VDMS-SUBNET"].id
      }
    }

    vtaps = {
      CHILD-DEFAULT-VTAP = {
        source_type       = "LOAD_BALANCER"
        source_id         = module.scca_networking_lb.provisioned_networking_resources.l7_load_balancers.l7_load_balancers["CHILD-VDMS-LB"].id
        vcn_id            = module.scca_networking.provisioned_networking_resources.vcns["CHILD-VDMS-VCN"].id
        display_name      = var.deployment_type == "SINGLE" ? "OCI-SCCA-LZ-VDMS-VTAP-${local.region_key[0]}" : "OCI-SCCA-LZ-CHILD-VDMS-VTAP-${local.region_key[0]}"
        enable_vtap       = false
        target_type       = "NETWORK_LOAD_BALANCER"
        target_id         = "CHILD-DEFAULT-NLB"
        capture_filter_id = "CHILD-DEFAULT-CAPTURE-FILTER"
      }
    }

    network_load_balancer_backend_sets = {
      CHILD-DEFAULT-LB-BACKEND-SET = {
        name                     = var.deployment_type == "SINGLE" ? "VDMS-VTAP-NLB-BACKEND-SET" : "CHILD-VDMS-VTAP-NLB-BACKEND-SET"
        network_load_balancer_id = "CHILD-DEFAULT-NLB" # key of network load balancer
        policy                   = "FIVE_TUPLE"
        protocol                 = "TCP"
      }
    }

    network_load_balancer_listeners = {
      CHILD-DEFAULT-NLB-LISTENER = {
        default_backend_set_name = "CHILD-DEFAULT-LB-BACKEND-SET" # key of network load balancer backend set
        listener_name            = var.deployment_type == "SINGLE" ? "VDMS-VTAP-NLB-LISTENER" : "CHILD-VDMS-VTAP-NLB-LISTENER"
        network_load_balancer_id = "CHILD-DEFAULT-NLB" # key of network load balancer
        port                     = "4789"
        protocol                 = "UDP"
      }
    }
  }
  #--------------------------------------------------------------------------------------------#
  # Load balancer configurations
  #--------------------------------------------------------------------------------------------#
  networking_load_balancer_configuration = {
    default_enable_cis_checks = false

    network_configuration_categories = {
      child = {
        non_vcn_specific_gateways = {
          l7_load_balancers = {
            CHILD-VDSS-LB = {
              compartment_id = "SCCA_CHILD_VDSS_CMP"
              display_name   = var.deployment_type == "SINGLE" ? "OCI-SCCA-LZ-VDSS-LB" : "OCI-SCCA-LZ-CHILD-VDSS-LB"
              shape          = "flexible"
              subnet_ids     = [module.scca_networking.provisioned_networking_resources.subnets["CHILD-VDSS-LB-SUBNET"].id]
              subnet_keys    = null
              ip_mode        = "IPV4"
              is_private     = true
              shape_details = {
                maximum_bandwidth_in_mbps = 30
                minimum_bandwidth_in_mbps = 10
              }
            }
            CHILD-VDMS-LB = {
              compartment_id = "SCCA_CHILD_VDMS_CMP"
              display_name   = var.deployment_type == "SINGLE" ? "OCI-SCCA-LZ-VDMS-LB-${local.region_key[0]}" : "OCI-SCCA-LZ-CHILD-VDMS-LB-${local.region_key[0]}"
              shape          = "flexible"
              subnet_ids     = [module.scca_networking.provisioned_networking_resources.subnets["CHILD-VDMS-SUBNET"].id]
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
  #--------------------------------------------------------------------------------------------#
  # Networking key maps
  #--------------------------------------------------------------------------------------------#
  network_configuration = {
    default_enable_cis_checks = false

    network_configuration_categories = {
      child = {
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
      child = {
        non_vcn_specific_gateways = {
          network_firewalls_configuration = {
            network_firewalls         = local.network_firewalls_configuration.network_firewalls
            network_firewall_policies = local.network_firewalls_configuration.network_firewall_policies
          }
        }
      }
    }
  }

  workload_route_rules_rpc = var.workload_additionalsubnets_cidr_blocks != [] ? {
    for index, route in var.workload_additionalsubnets_cidr_blocks != [] ? var.workload_additionalsubnets_cidr_blocks : [] : "WORKLOAD-RULE-${index}" => {
      destination                = route
      destination_type           = "CIDR_BLOCK"
      next_hop_drg_attachment_id = module.scca_networking.provisioned_networking_resources.drg_attachments["VDSS-VCN-Attachment"].id
    }
  } : {}

  rpc_route_rules = {
    RPC-DRG-VDSS = {
      destination                = var.vdss_vcn_cidr_block
      destination_type           = "CIDR_BLOCK"
      next_hop_drg_attachment_id = module.scca_networking.provisioned_networking_resources.drg_attachments["VDSS-VCN-Attachment"].id
    }
    RPC-DRG-VDMS = {
      destination                = var.vdms_vcn_cidr_block
      destination_type           = "CIDR_BLOCK"
      next_hop_drg_attachment_id = module.scca_networking.provisioned_networking_resources.drg_attachments["VDSS-VCN-Attachment"].id
    }
    RPC-DRG-PARENT-VDSS = {
      destination                 = var.parent_vdss_vcn_cidr
      destination_type            = "CIDR_BLOCK"
      next_hop_drg_attachment_key = "REQUESTOR-RPC"
    }
    RPC-DRG-PARENT-VDMS = {
      destination                 = var.parent_vdms_vcn_cidr
      destination_type            = "CIDR_BLOCK"
      next_hop_drg_attachment_key = "REQUESTOR-RPC"
    }
  }
  network_configuration_rpc = {
    default_compartment_id = "SCCA_CHILD_VDSS_CMP"
    network_configuration_categories = {
      production = {
        non_vcn_specific_gateways = {
          inject_into_existing_drgs = {
            RPC-REQUESTOR = {
              drg_id = "DRG-HUB"
              remote_peering_connections = {
                REQUESTOR-RPC = {
                  display_name     = "REQUESTOR-RPC"
                  peer_id          = var.rpc_acceptor_ocid
                  peer_key         = "acceptor-rpc"
                  peer_region_name = var.parent_region_name
                }
              }
              drg_route_tables = {
                RT-RPC = {
                  compartment_id = "SCCA_CHILD_VDSS_CMP"
                  display_name   = "CHILD-RT-RPC"
                  route_rules    = merge(local.rpc_route_rules, local.workload_route_rules_rpc)
                }
              }
              drg_route_distributions = {
                STATEMENT-3 = {
                  distribution_type = "IMPORT"
                  action            = "ACCEPT"
                  match_criteria = {
                    match_type         = "DRG_ATTACHMENT_ID"
                    attachment_type    = "RPC"
                    drg_attachment_key = "REQUESTOR-RPC"
                  }
                  priority = 3
                }
              }
            }
          }
        }
      }
    }
  }
}
#--------------------------------------------------------------------------------------------#
# Networking configurations
#--------------------------------------------------------------------------------------------#

// use 0.6.7 to
module "scca_networking" {
  source = "github.com/oci-landing-zones/terraform-oci-modules-networking?ref=v0.6.7" 
                                    // the newest release (0.6.8) doesn't seem to work

  network_configuration   = local.network_configuration
  compartments_dependency = module.scca_compartments[0].compartments
}

module "scca_networking_rpc" {
  count  = var.enable_service_deployment ? 1 : 0
  source = "github.com/oci-landing-zones/terraform-oci-modules-networking?ref=v0.6.7"

  network_configuration   = local.network_configuration_rpc
  compartments_dependency = module.scca_compartments[0].compartments
  network_dependency      = module.scca_networking.provisioned_networking_resources
}

module "scca_networking_firewall" {
  count  = var.enable_network_firewall ? 1 : 0
  source = "github.com/oci-landing-zones/terraform-oci-modules-networking?ref=v0.6.7"

  network_configuration   = local.network_firewall_network_configuration
  compartments_dependency = module.scca_compartments[0].compartments
}

module "scca_networking_lb" {
  source                  = "github.com/oci-landing-zones/terraform-oci-modules-networking?ref=v0.6.7"
  network_configuration   = local.networking_load_balancer_configuration
  compartments_dependency = module.scca_compartments[0].compartments
}

module "scca_networking_vtap" {
  count              = var.enable_vtap ? 1 : 0
    # source                  = "github.com/oci-landing-zones/terraform-oci-modules-networking/modules/vtap"
  source             = "./modules/vtap"

  vtap_configuration = local.vtap_configuration
}


module "scca_networking_waa" {
  count = var.enable_waf ? 1 : 0
  source                  = "github.com/oci-landing-zones/terraform-oci-modules-networking?ref=v0.6.7/modules/waa"

  waa_configuration       = local.waa_configuration
  compartments_dependency = module.scca_compartments[0].compartments
}

module "scca_networking_waf" {
  count = var.enable_waf ? 1 : 0
  source                  = "github.com/oci-landing-zones/terraform-oci-modules-networking?ref=v0.6.7/modules/waf"

  waf_configuration       = local.waf_configuration
  compartments_dependency = module.scca_compartments[0].compartments
}
