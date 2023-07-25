
module "home_compartment" {
  source = "../../../modules/compartment"

  compartment_parent_id     = var.tenancy_ocid
  compartment_name          = var.compartment_name
  compartment_description   = var.compartment_description
  enable_compartment_delete = var.enable_compartment_delete

  providers = {
    oci = oci.home_region
  }
}
