# ###################################################################################################### #
# Copyright (c) 2023 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

terraform {
  required_version = "< 1.3.0"
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}

resource "oci_logging_log_group" "log_group" {
  compartment_id = var.compartment_id
  display_name   = var.display_name
  description    = var.description
}
