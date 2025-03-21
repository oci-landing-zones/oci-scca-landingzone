# Network_2
# Scenario: 2 workloads - Duplicated workload and workload_db resources into workload_2
# Updated drg attachments and distributions
# Changed compartment to tenancy

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
      "Workload-2-VCN-Attachment" = {
        display_name         = "Workload-2-VCN-Attachment"
        vcn_id               = module.workload_2_network.vcn_id
        drg_route_table_name = "RT-Spoke"
      }
      "Workload-2-DB-VCN-Attachment" = {
        display_name         = "Workload-2-DB-VCN-Attachment"
        vcn_id               = module.workload_2_db_network.vcn_id
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
          "statement-5" = {
            action              = "ACCEPT"
            match_type          = "DRG_ATTACHMENT_ID" # DRG_ATTACHMENT_ID DRG_ATTACHMENT_TYPE MATCH_ALL 
            attachment_type     = "VCN"
            drg_attachment_name = "Workload-2-DB-VCN-Attachment"
            priority            = 5
          }
        }

      }
    }
  }
}

module "drg" {
  source = "../../../modules/drg"

  compartment_id         = var.compartment_id
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
    name             = "OCI-SCCA-LZ-VDSS-VCN-${local.region_key[0]}"
    vcn_dns_label    = "vdssvnc"
    sgw_display_name = "OCI-SCCA-VDSS-VCN-${local.region_key[0]}-SGW"
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

  network_firewall = {
    network_firewall_policy_action = "REJECT"
    network_firewall_name          = "network-firewall"
    ip_address_list                = [var.vdss_vcn_cidr_block]
  }

  vdss_route_table = {
    VDSS-VCN-Ingress = {
      route_table_display_name = "VDSS-VCN-Ingress"
      subnet_name              = ""
      subnet_id                = ""
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
    OCI-SCCA-LZ-VDSS-SUB2 = {
      route_table_display_name = "OCI-SCCA-LZ-VDSS-SUB2-${local.region_key[0]}"
      subnet_name              = "OCI-SCCA-LZ-VDSS-SUB2"
      subnet_id                = module.vdss_network.subnets[local.vdss_network.subnet_map["OCI-SCCA-LZ-VDSS-SUB2"].name]
      route_rules = {
        "all-to-drg" = {
          network_entity_id = module.drg.drg_id
          destination       = "0.0.0.0/0"
          destination_type  = "CIDR_BLOCK"
        }
        "sgw-to-os" = {
          network_entity_id = module.vdss_network.sgw_id
          destination       = data.oci_core_services.all_oci_services.services[0]["cidr_block"]
          destination_type  = "SERVICE_CIDR_BLOCK"
        }
      }
    }
    OCI-SCCA-LZ-VDSS-SUB1 = {
      route_table_display_name = "OCI-SCCA-LZ-VDSS-SUB1-${local.region_key[0]}"
      subnet_name              = "OCI-SCCA-LZ-VDSS-SUB1"
      subnet_id                = module.vdss_network.subnets[local.vdss_network.subnet_map["OCI-SCCA-LZ-VDSS-SUB1"].name]
      route_rules = {
        "all-to-nfw" = {
          network_entity_id = module.network_firewall.firewall_ip_id
          destination       = "0.0.0.0/0"
          destination_type  = "CIDR_BLOCK"
        }
      }
    }
    SGW-RT = {
      route_table_display_name = "SGW-RT"
      subnet_name              = ""
      subnet_id                = ""
      route_rules = {
        "all-to-nfw" = {
          network_entity_id = module.network_firewall.firewall_ip_id
          destination       = "0.0.0.0/0"
          destination_type  = "CIDR_BLOCK"
        }
      }
    }
  }

  vdss_load_balancer = {
    lb_name   = "OCI-SCCA-LZ-VDSS-LB-${local.region_key[0]}"
    lb_subnet = module.vdss_network.subnets[local.vdss_network.subnet_map["OCI-SCCA-LZ-VDSS-SUB1"].name]
  }
}

module "vdss_network" {
  source = "../../../modules/vcn"

  vcn_cidr_block   = var.vdss_vcn_cidr_block
  compartment_id   = var.compartment_id
  vcn_display_name = local.vdss_network.name
  vcn_dns_label    = local.vdss_network.vcn_dns_label
  sgw_display_name = local.vdss_network.sgw_display_name
  subnet_map       = local.vdss_network.subnet_map
}

module "network_firewall" {
  source = "../../../modules/network-firewall"

  compartment_id                 = var.compartment_id
  network_firewall_policy_action = local.network_firewall.network_firewall_policy_action
  network_firewall_name          = local.network_firewall.network_firewall_name
  network_firewall_subnet_id     = module.vdss_network.subnets[local.vdss_network.subnet_map["OCI-SCCA-LZ-VDSS-SUB2"].name]
  ip_address_list                = local.network_firewall.ip_address_list
}

module "vdss_route_table" {
  source = "../../../modules/route-table"

  for_each                 = local.vdss_route_table
  compartment_id           = var.compartment_id
  route_table_display_name = each.value.route_table_display_name
  route_rules              = each.value.route_rules
  vcn_id                   = module.vdss_network.vcn_id
  subnet_name              = each.value.subnet_name
  subnet_id                = each.value.subnet_id
}

module "vdss_load_balancer" {
  source = "../../../modules/load-balancer"

  compartment_id             = var.compartment_id
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
    name             = "OCI-SCCA-LZ-VDMS-VCN-${local.region_key[0]}"
    vcn_dns_label    = "vdmsvnc"
    sgw_display_name = "OCI-SCCA-VDMS-VCN-${local.region_key[0]}-SGW"
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

  vdms_route_table = {
    VDMS-VCN-Egress = {
      route_table_display_name = "VDMS-VCN-Egress"
      subnet_name              = "OCI-SCCA-LZ-VDMS-SUB1"
      subnet_id                = module.vdms_network.subnets[local.vdms_network.subnet_map["OCI-SCCA-LZ-VDMS-SUB1"].name]
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
  }

  vdms_load_balancer = {
    lb_name   = "OCI-SCCA-LZ-VDMS-LB-${local.region_key[0]}"
    lb_subnet = module.vdms_network.subnets[local.vdms_network.subnet_map["OCI-SCCA-LZ-VDMS-SUB1"].name]
  }

}

module "vdms_network" {
  source = "../../../modules/vcn"

  vcn_cidr_block   = var.vdms_vcn_cidr_block
  compartment_id   = var.compartment_id
  vcn_display_name = local.vdms_network.name
  vcn_dns_label    = local.vdms_network.vcn_dns_label
  sgw_display_name = local.vdms_network.sgw_display_name
  subnet_map       = local.vdms_network.subnet_map
}

module "vdms_route_table" {
  source = "../../../modules/route-table"

  for_each                 = local.vdms_route_table
  compartment_id           = var.compartment_id
  route_table_display_name = each.value.route_table_display_name
  route_rules              = each.value.route_rules
  vcn_id                   = module.vdms_network.vcn_id
  subnet_name              = each.value.subnet_name
  subnet_id                = each.value.subnet_id
}

module "vdms_load_balancer" {
  source = "../../../modules/load-balancer"

  compartment_id             = var.compartment_id
  load_balancer_display_name = local.vdms_load_balancer.lb_name
  load_balancer_subnet_ids   = [local.vdms_load_balancer.lb_subnet]
  load_balancer_is_private   = true
  lb_add_waf                 = true
  lb_add_waa                 = false
}

locals {
  workload_compartment = {
    name        = "OCI-SCCA-LZ-${var.workload_name}-${var.mission_owner_key}"
    description = "Workload Compartment"
  }

  workload_network = {
    name             = "OCI-SCCA-LZ-Workload-VCN-${var.workload_name}-${local.region_key[0]}"
    vcn_dns_label    = "workloadvcn"
    sgw_display_name = "OCI-SCCA-LZ-Workload-VCN-${var.workload_name}-${local.region_key[0]}-SGW"
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
    name             = "OCI-SCCA-LZ-Workload-DB-VCN-${var.workload_name}-${local.region_key[0]}"
    vcn_dns_label    = "workloaddbvcn"
    sgw_display_name = "OCI-SCCA-LZ-Workload-DB-VCN-${var.workload_name}-${local.region_key[0]}-SGW"
    subnet_map = {
      OCI-SCCA-LZ-Workload-DB-SUB = {
        name        = "OCI-SCCA-LZ-Workload-DB-SUB-${var.workload_name}-${local.region_key[0]}"
        description = "Workload ${var.workload_name} Subnet"
        # workloaddbsubnet is too long (not 15 chars)
        dns_label                  = "dbsubnet"
        cidr_block                 = var.workload_db_subnet_cidr_block
        prohibit_public_ip_on_vnic = true
      }
    }
  }

  workload_route_table = {
    Workload-VCN-Egress = {
      route_table_display_name = "Workload-${var.workload_name}-VCN-Egress"
      subnet_name              = "OCI-SCCA-LZ-Workload-SUB"
      subnet_id                = module.workload_network.subnets[local.workload_network.subnet_map["OCI-SCCA-LZ-Workload-SUB"].name]
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
      subnet_name              = "OCI-SCCA-LZ-Workload-DB-SUB"
      subnet_id                = module.workload_db_network.subnets[local.workload_db_network.subnet_map["OCI-SCCA-LZ-Workload-DB-SUB"].name]
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

}

# -----------------------------------------------------------------------------
# Create workload compartment, for top level organization
# -----------------------------------------------------------------------------

module "workload_network" {
  source = "../../../modules/vcn"

  vcn_cidr_block   = var.workload_vcn_cidr_block
  compartment_id   = var.compartment_id
  vcn_display_name = local.workload_network.name
  vcn_dns_label    = local.workload_network.vcn_dns_label
  sgw_display_name = local.workload_network.sgw_display_name
  subnet_map       = local.workload_network.subnet_map
}

module "workload_db_network" {
  source = "../../../modules/vcn"

  vcn_cidr_block   = var.workload_db_vcn_cidr_block
  compartment_id   = var.compartment_id
  vcn_display_name = local.workload_db_network.name
  vcn_dns_label    = local.workload_db_network.vcn_dns_label
  sgw_display_name = local.workload_db_network.sgw_display_name
  subnet_map       = local.workload_db_network.subnet_map
}

module "workload_route_table" {
  source = "../../../modules/route-table"

  for_each                 = local.workload_route_table
  compartment_id           = var.compartment_id
  route_table_display_name = each.value.route_table_display_name
  route_rules              = each.value.route_rules
  vcn_id                   = module.workload_network.vcn_id
  subnet_name              = each.value.subnet_name
  subnet_id                = each.value.subnet_id
}

module "workload_db_route_table" {
  source = "../../../modules/route-table"

  for_each                 = local.workload_db_route_table
  compartment_id           = var.compartment_id
  route_table_display_name = each.value.route_table_display_name
  route_rules              = each.value.route_rules
  vcn_id                   = module.workload_db_network.vcn_id
  subnet_name              = each.value.subnet_name
  subnet_id                = each.value.subnet_id
}

module "workload_load_balancer" {
  source = "../../../modules/load-balancer"

  compartment_id             = var.compartment_id
  load_balancer_display_name = local.workload_load_balancer.lb_name
  load_balancer_subnet_ids   = [local.workload_load_balancer.lb_subnet]
  load_balancer_is_private   = true
  lb_add_waf                 = true
  lb_add_waa                 = true
}


locals {
  workload_2_compartment = {
    name        = "OCI-SCCA-LZ-${var.workload_2_name}-${var.mission_owner_key}"
    description = "Workload Compartment"
  }

  workload_2_network = {
    name             = "OCI-SCCA-LZ-Workload-2-VCN-${var.workload_2_name}-${local.region_key[0]}"
    vcn_dns_label    = "workloadvcn"
    sgw_display_name = "OCI-SCCA-LZ-Workload-2-VCN-${var.workload_2_name}-${local.region_key[0]}-SGW"
    subnet_map = {
      OCI-SCCA-LZ-Workload-2-SUB = {
        name                       = "OCI-SCCA-LZ-Workload-2-SUB-${var.workload_2_name}-${local.region_key[0]}"
        description                = "Workload ${var.workload_2_name} Subnet"
        dns_label                  = "workloadsubnet"
        cidr_block                 = var.workload_2_subnet_cidr_block
        prohibit_public_ip_on_vnic = true
      }
    }
  }

  workload_2_db_network = {
    name             = "OCI-SCCA-LZ-Workload-2-DB-VCN-${var.workload_2_name}-${local.region_key[0]}"
    vcn_dns_label    = "workloaddbvcn"
    sgw_display_name = "OCI-SCCA-LZ-Workload-2-DB-VCN-${var.workload_2_name}-${local.region_key[0]}-SGW"
    subnet_map = {
      OCI-SCCA-LZ-Workload-2-DB-SUB = {
        name                       = "OCI-SCCA-LZ-Workload-2-DB-SUB-${var.workload_2_name}-${local.region_key[0]}"
        description                = "Workload ${var.workload_2_name} Subnet"
        dns_label                  = "dbsubnet" # workloaddbsubnet is too long (not 15 chars)
        cidr_block                 = var.workload_2_db_subnet_cidr_block
        prohibit_public_ip_on_vnic = true
      }
    }
  }

  workload_2_route_table = {
    Workload-2-VCN-Egress = {
      route_table_display_name = "Workload-2-${var.workload_2_name}-VCN-Egress"
      subnet_name              = "OCI-SCCA-LZ-Workload-2-SUB"
      subnet_id                = module.workload_2_network.subnets[local.workload_2_network.subnet_map["OCI-SCCA-LZ-Workload-2-SUB"].name]
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
        "workload_2_db" = {
          network_entity_id = module.drg.drg_id
          destination       = var.workload_2_db_vcn_cidr_block
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

  workload_2_db_route_table = {
    Workload-2-DB-VCN-Egress = {
      route_table_display_name = "Workload-2-${var.workload_2_name}-DB-VCN-Egress"
      subnet_name              = "OCI-SCCA-LZ-Workload-2-DB-SUB"
      subnet_id                = module.workload_2_db_network.subnets[local.workload_2_db_network.subnet_map["OCI-SCCA-LZ-Workload-2-DB-SUB"].name]
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
          destination       = var.workload_2_vcn_cidr_block
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

  workload_2_load_balancer = {
    lb_name   = "OCI-SCCA-LZ-Workload-2-LB-${var.workload_2_name}-${local.region_key[0]}"
    lb_subnet = module.workload_2_network.subnets[local.workload_2_network.subnet_map["OCI-SCCA-LZ-Workload-2-SUB"].name]
  }

}

# -----------------------------------------------------------------------------
# Create workload compartment, for top level organization
# -----------------------------------------------------------------------------

module "workload_2_network" {
  source = "../../../modules/vcn"

  vcn_cidr_block   = var.workload_2_vcn_cidr_block
  compartment_id   = var.compartment_id
  vcn_display_name = local.workload_2_network.name
  vcn_dns_label    = local.workload_2_network.vcn_dns_label
  sgw_display_name = local.workload_2_network.sgw_display_name
  subnet_map       = local.workload_2_network.subnet_map
}

module "workload_2_db_network" {
  source = "../../../modules/vcn"

  vcn_cidr_block   = var.workload_2_db_vcn_cidr_block
  compartment_id   = var.compartment_id
  vcn_display_name = local.workload_2_db_network.name
  vcn_dns_label    = local.workload_2_db_network.vcn_dns_label
  sgw_display_name = local.workload_2_db_network.sgw_display_name
  subnet_map       = local.workload_2_db_network.subnet_map
}

module "workload_2_route_table" {
  source = "../../../modules/route-table"

  for_each                 = local.workload_2_route_table
  compartment_id           = var.compartment_id
  route_table_display_name = each.value.route_table_display_name
  route_rules              = each.value.route_rules
  vcn_id                   = module.workload_2_network.vcn_id
  subnet_name              = each.value.subnet_name
  subnet_id                = each.value.subnet_id
}

module "workload_2_db_route_table" {
  source = "../../../modules/route-table"

  for_each                 = local.workload_2_db_route_table
  compartment_id           = var.compartment_id
  route_table_display_name = each.value.route_table_display_name
  route_rules              = each.value.route_rules
  vcn_id                   = module.workload_2_db_network.vcn_id
  subnet_name              = each.value.subnet_name
  subnet_id                = each.value.subnet_id
}

module "workload_2_load_balancer" {
  source = "../../../modules/load-balancer"

  compartment_id             = var.compartment_id
  load_balancer_display_name = local.workload_2_load_balancer.lb_name
  load_balancer_subnet_ids   = [local.workload_2_load_balancer.lb_subnet]
  load_balancer_is_private   = true
  lb_add_waf                 = true
  lb_add_waa                 = true
}
