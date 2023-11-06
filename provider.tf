terraform {
  required_version = ">= 1.0.0"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "5.19.0" # August 2023 Release
    }
  }
}

# -----------------------------------------------------------------------------
# Support for multi-region deployments
# -----------------------------------------------------------------------------
data "oci_identity_region_subscriptions" "regions" {
  tenancy_id = var.tenancy_ocid
}

locals {
  region_subscriptions = data.oci_identity_region_subscriptions.regions.region_subscriptions
  home_region          = [for region in local.region_subscriptions : region.region_name if region.is_home_region == true]
  region_key           = [for region in local.region_subscriptions : region.region_key if region.region_name == var.region]
}

# -----------------------------------------------------------------------------
# Provider blocks for home region and alternate region(s)
# -----------------------------------------------------------------------------
provider "oci" {
  tenancy_ocid        = var.tenancy_ocid
  user_ocid           = var.current_user_ocid
  fingerprint         = var.api_fingerprint
  private_key_path    = var.api_private_key_path
  region              = var.region
  auth                = "SecurityToken"
  config_file_profile = "boat-login"
}

provider "oci" {
  alias               = "home_region"
  tenancy_ocid        = var.tenancy_ocid
  user_ocid           = var.current_user_ocid
  fingerprint         = var.api_fingerprint
  private_key_path    = var.api_private_key_path
  region              = local.home_region[0]
  auth                = "SecurityToken"
  config_file_profile = "boat-login"
}

provider "oci" {
  alias               = "secondary_region"
  tenancy_ocid        = var.tenancy_ocid
  user_ocid           = var.current_user_ocid
  fingerprint         = var.api_fingerprint
  private_key_path    = var.api_private_key_path
  region              = var.secondary_region
  auth                = "SecurityToken"
  config_file_profile = "boat-login"
}