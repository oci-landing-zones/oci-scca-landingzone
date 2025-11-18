# ###################################################################################################### #
# Copyright (c) 2023 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

#######################################################
######### List Cloud Guard Responder Recipes ##########
#######################################################

data "oci_cloud_guard_responder_recipes" "list_preloaded_responder_recipes" {
  compartment_id          = var.tenancy_ocid
  state                   = "ACTIVE"
  depends_on              = [oci_cloud_guard_cloud_guard_configuration.cloud_guard_configuration]
}


#######################################################
######### List Cloud Guard Detector Recipes ###########
#######################################################

data "oci_cloud_guard_detector_recipes" "list_preloaded_detector_recipes" {
  compartment_id          = var.tenancy_ocid
  state                   = "ACTIVE"
  depends_on              = [oci_cloud_guard_cloud_guard_configuration.cloud_guard_configuration]
}

