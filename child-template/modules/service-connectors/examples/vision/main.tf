# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "vision_connector" {
  source         = "../.."
  providers = {
    oci = oci
    oci.home = oci.home
  }
  tenancy_ocid     = var.tenancy_ocid
  service_connectors_configuration = var.service_connectors_configuration
}
