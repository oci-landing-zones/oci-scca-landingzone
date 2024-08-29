# ###################################################################################################### #
# Copyright (c) 2024 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

locals {
  ##############################################################################################
  ####################          SERVICE GATEWAY VARIABLES         ##############################
  ##############################################################################################

  wrk_service_gateways = {
    WRK-SGW = {
      compartment_id           = "WKL-CMP"
      display_name             = "OCI-SCCA-WRK-VCN-${local.region_key[0]}-${var.resource_label}-SGW"
      services                 = "all-services"
      route_table_display_name = "WRK-ROUTE-TABLE-SGW"
    }
  }
  ##############################################################################################
  ####################            ROUTE TABLE VARIABLES           ##############################
  ##############################################################################################
  workload_route_rules = {
    default_route_rules = {
      ALL-TO-DRG = {
        network_entity_id = var.child_drg_id
        destination       = var.lb_subnet_cidr_block_child
        destination_type  = "CIDR_BLOCK"
      }
      LOCAL-TO-DRG = {
        network_entity_id = var.child_drg_id
        destination       = var.fw_subnet_cidr_block_child
        destination_type  = "CIDR_BLOCK"
      }
      ALL-SERVICE-TO-DRG = {
        network_entity_id = var.child_drg_id
        destination       = var.wrk_vcn_cidr_block
        destination_type  = "CIDR_BLOCK"
      }
      SGW-TO-OS = {
        network_entity_key = "WRK-SGW"
        destination        = "all-services"
        destination_type   = "SERVICE_CIDR_BLOCK"
      }
    }
    wrk_route_rules_sgw = {
      ALL-TO-DRG = {
        network_entity_id = var.child_drg_id
        destination       = "0.0.0.0/0"
        destination_type  = "CIDR_BLOCK"
      }
    }
  }
  WRK-ROUTE-TABLE-SGW = {
    compartment_id = "WKL-CMP"
    display_name   = "WRK-ROUTE-TABLE-SGW"
    route_rules    = local.workload_route_rules.wrk_route_rules_sgw
  }
  ##############################################################################################
  ####################            SUBNET VARIABLES                ##############################
  ##############################################################################################
  workload_subnets = {
    WRK-WEB-SUBNET = {
      compartment_id = "WKL-CMP"
      display_name   = "WRK-Web-${var.web_subnet_name}-${local.region_key[0]}-${var.resource_label}"
      description    = "Web Subnet"
      dns_label      = var.web_subnet_dns_label
      cidr_block     = var.web_subnet_cidr_block
      #route_table_key            = "PARENT-VDSS-ROUTE-TABLE-LB"
      prohibit_public_ip_on_vnic = true
    }
    WRK-APP-SUBNET = {
      compartment_id = "WKL-CMP"
      display_name   = "WRK-App-${var.app_subnet_name}-${local.region_key[0]}-${var.resource_label}"
      description    = "App Subnet"
      dns_label      = var.app_subnet_dns_label
      cidr_block     = var.app_subnet_cidr_block
      #route_table_key            = "PARENT-VDSS-ROUTE-TABLE-FW"
      prohibit_public_ip_on_vnic = true
    }
    WRK-DB-SUBNET = {
      compartment_id = "WKL-CMP"
      display_name   = "WRK-Db-${var.db_subnet_name}-${local.region_key[0]}-${var.resource_label}"
      description    = "Db Subnet"
      dns_label      = var.db_subnet_dns_label
      cidr_block     = var.db_subnet_cidr_block
      #route_table_key            = "PARENT-VDSS-ROUTE-TABLE-FW"
      prohibit_public_ip_on_vnic = true
    }
  }

  ##############################################################################################
  ####################            VCN INPUT VARIABLES             ##############################
  ##############################################################################################
  vcns = {
    WORKLOAD-VCN = {
      compartment_id = "WKL-CMP"
      display_name   = "OCI-SCCA-LZ-WRK-VCN-${local.region_key[0]}-${var.resource_label}"
      dns_label      = "wrkvnc"
      cidr_blocks    = [var.wrk_vcn_cidr_block]

      subnets             = local.workload_subnets
      default_route_table = local.default_route_table
      vcn_specific_gateways = {
        service_gateways = local.wrk_service_gateways
      }
    }
  }
  ##############################################################################################
  ####################               ROUTE TABLE VARIABLES                ######################
  ##############################################################################################
  default_route_table = {
    compartment_id = module.workload_compartment.compartments["WKL-CMP"].id
    display_name   = "WRK-RT-DEFAULT"
    route_rules    = local.workload_route_rules.default_route_rules
  }

  network_configuration = {
    default_enable_cis_checks = false
    default_compartment_id    = module.workload_compartment.compartments["WKL-CMP"].id
    network_configuration_categories = {
      wrk = {
        vcns = local.vcns
        non_vcn_specific_gateways = {
          inject_into_existing_drgs = {
            DRG-WRK-KEY = {
              drg_id = var.child_drg_id
              drg_attachments = {
                DRG-WRK-VCN-ATTACH-KEY = {
                  display_name = "DRG-WRK-VCN-ATTACH-${local.region_key[0]}-${var.resource_label}"
                  network_details = {
                    attached_resource_key = "WORKLOAD-VCN"
                    type                  = "VCN"
                    vcn_route_type        = "VCN-CIDR"
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  ##############################################################################################
  ####################               Network Firewall                     ######################
  ##############################################################################################  
  network_firewalls_configuration = {
    network_firewalls = {
      WRK-NFW-KEY = {
        network_firewall_policy_key = "WRK-NFW-POLICY-KEY"
        compartment_id              = "WKL-CMP"
        subnet_id                   = module.scca_networking.provisioned_networking_resources.subnets["WRK-WEB-SUBNET"].id
        display_name                = "WRK-NETWORK-FIREWALL-${local.region_key[0]}-${var.resource_label}"
      }
    }
    network_firewall_policies = {
      WRK-NFW-POLICY-KEY = {
        display_name   = "WRK-NFW-POLICY-${local.region_key[0]}-${var.resource_label}"
        compartment_id = "WKL-CMP"
        ip_address_lists = {
          hubnfw_ip_list = {
            ip_address_list_name  = "vcn-ips"
            ip_address_list_value = [var.wrk_vcn_cidr_block]
          }
        }
        security_rules = {
          WRK-NFW-SECURITY_RULES-1 = {
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
  network_firewall_network_configuration = {
    default_enable_cis_checks = false

    network_configuration_categories = {
      wrk = {
        non_vcn_specific_gateways = {
          network_firewalls_configuration = {
            network_firewalls         = local.network_firewalls_configuration.network_firewalls
            network_firewall_policies = local.network_firewalls_configuration.network_firewall_policies
          }
        }
      }
    }
  }
  ##############################################################################################
  ####################           Load Balancer Configuration              ######################
  ############################################################################################## 

  networking_load_balancer_configuration = {
    default_enable_cis_checks = false

    network_configuration_categories = {
      wrk = {
        non_vcn_specific_gateways = {
          l7_load_balancers = {
            WRK-VDSS-LB = {
              compartment_id = "WKL-CMP"
              display_name   = "OCI-SCCA-LZ-WRK-LB-${local.region_key[0]}-${var.resource_label}"
              shape          = "flexible"
              subnet_ids     = [module.scca_networking.provisioned_networking_resources.subnets["WRK-WEB-SUBNET"].id]
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
  ##############################################################################################
  ####################                 Bastion Configuration              ######################
  ############################################################################################## 
  bastions_configuration = {
    bastions = {
      BASTION-WRK = {
        compartment_id        = module.workload_compartment.compartments["WKL-CMP"].id
        subnet_id             = "WRK-WEB-SUBNET"
        cidr_block_allow_list = var.bastion_client_cidr_block_allow_list
        name                  = "${var.bastion_display_name}-${var.resource_label}"
      }
    }
  }
}

module "scca_networking" {
  source                  = "github.com/oci-landing-zones/terraform-oci-modules-networking?ref=v0.6.7"
  network_configuration   = local.network_configuration
  compartments_dependency = module.workload_compartment.compartments
}

module "scca_networking_firewall" {
  count  = var.enable_workload_network_firewall ? 1 : 0
  source = "github.com/oci-landing-zones/terraform-oci-modules-networking?ref=v0.6.7"

  network_configuration   = local.network_firewall_network_configuration
  compartments_dependency = module.workload_compartment.compartments
}

module "scca_networking_lb" {
  source                  = "github.com/oci-landing-zones/terraform-oci-modules-networking?ref=v0.6.7"
  network_configuration   = local.networking_load_balancer_configuration
  compartments_dependency = module.workload_compartment.compartments
}

module "bastion" {
  count                   = var.enable_bastion_wrk ? 1 : 0
  source                  = "github.com/oci-landing-zones/terraform-oci-modules-security//bastion?ref=release-0.1.5-rms"
  bastions_configuration  = local.bastions_configuration
  enable_output           = true
  compartments_dependency = module.workload_compartment.compartments
  network_dependency      = module.scca_networking.provisioned_networking_resources
}
   