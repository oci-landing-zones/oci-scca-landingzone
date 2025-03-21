
module "home_compartment" {
  source = "../../../"
  # PSEDEV
  api_fingerprint      = var.api_fingerprint
  api_private_key_path = var.api_private_key_path
  region               = var.region
  tenancy_ocid         = var.tenancy_ocid
  current_user_ocid    = var.current_user_ocid
  secondary_region     = var.secondary_region

  # COMPARTMENT 
  resource_label            = var.resource_label
  enable_compartment_delete = var.enable_compartment_delete
  home_compartment_name     = var.home_compartment_name

  # BACKUP
  backup_compartment_name = var.backup_compartment_name
  backup_bucket_name      = var.backup_bucket_name

  # LOGGING
  enable_logging_compartment = var.enable_logging_compartment
  logging_compartment_name   = var.logging_compartment_name

  # VDMS
  vdms_compartment_name  = var.vdms_compartment_name
  vdms_vcn_cidr_block    = var.vdms_vcn_cidr_block
  vdms_subnet_cidr_block = var.vdms_subnet_cidr_block

  # VDSS
  vdss_compartment_name      = var.vdss_compartment_name
  vdss_vcn_cidr_block        = var.vdss_vcn_cidr_block
  firewall_subnet_cidr_block = var.firewall_subnet_cidr_block
  lb_subnet_cidr_block       = var.lb_subnet_cidr_block

  # WORKLOAD
  mission_owner_key             = var.lb_subnet_cidr_block
  workload_name                 = var.workload_name
  workload_vcn_cidr_block       = var.workload_name
  workload_subnet_cidr_block    = var.workload_subnet_cidr_block
  workload_db_vcn_cidr_block    = var.workload_db_vcn_cidr_block
  workload_db_subnet_cidr_block = var.workload_db_subnet_cidr_block

}
