# ###################################################################################################### #
# Copyright (c) 2024 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #
# -----------------------------------------------------------------------------
# Create Vault Replication Resource
# -----------------------------------------------------------------------------
resource "oci_kms_vault_replication" "these" {
  for_each = var.vault_replication_configuration != null ? var.vault_replication_configuration.vault_replica : {}
    vault_id = each.value.vault_id
    replica_region = each.value.replica_region
}