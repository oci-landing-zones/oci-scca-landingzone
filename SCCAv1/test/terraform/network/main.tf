locals {
  vdss_network = {
    name             = "OCI-SCCA-LZ-VDSS-VCN-${local.region_key[0]}"
    vcn_dns_label    = "vdssvnc"
    sgw_display_name = "OCI-SCCA-VDSS-VCN-${local.region_key[0]}-SGW"
    subnet_map = {
      OCI-SCCA-LZ-VDSS-SUB1 = {
        name        = "OCI-SCCA-LZ-VDSS-SUB1-${local.region_key[0]}"
        description = "VDSS LB Subnet"
        dns_label   = "lbsubnet"
        cidr_block  = var.lb_subnet_cidr_block
      }
      OCI-SCCA-LZ-VDSS-SUB2 = {
        name        = "OCI-SCCA-LZ-VDSS-SUB2-${local.region_key[0]}"
        description = "VDSS Firewall Subnet"
        dns_label   = "firewallsubnet"
        cidr_block  = var.firewall_subnet_cidr_block
      }
    }
  }

  vdms_network = {
    name             = "OCI-SCCA-LZ-VDMS-VCN-${local.region_key[0]}"
    vcn_dns_label    = "vdmsvnc"
    sgw_display_name = "OCI-SCCA-VDMS-VCN-${local.region_key[0]}-SGW"
    subnet_map = {
      OCI-SCCA-LZ-VDMS-SUB1 = {
        name        = "OCI-SCCA-LZ-VDMS-SUB-${local.region_key[0]}"
        description = "VDMS Subnet"
        dns_label   = "vdmssubnet"
        cidr_block  = var.vdms_subnet_cidr_block
      }
    }
  }
}

module "vdss_network" {
  source = "../../../modules/vcn"

  vcn_cidr_block   = var.vdss_vcn_cidr_block
  compartment_id   = var.vdms_compartment_id
  vcn_display_name = local.vdss_network.name
  vcn_dns_label    = local.vdss_network.vcn_dns_label
  sgw_display_name = local.vdss_network.sgw_display_name
  subnet_map       = local.vdss_network.subnet_map
}

module "vdms_network" {
  source = "../../../modules/vcn"

  vcn_cidr_block   = var.vdms_vcn_cidr_block
  compartment_id   = var.vdms_compartment_id
  vcn_display_name = local.vdms_network.name
  vcn_dns_label    = local.vdms_network.vcn_dns_label
  sgw_display_name = local.vdms_network.sgw_display_name
  subnet_map       = local.vdms_network.subnet_map
}
