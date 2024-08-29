# ###################################################################################################### #
# Copyright (c) 2024 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

variable "vault_replication_configuration" {
  type = object({
    vault_replica = optional(map(object({
      vault_id       = string
      replica_region = string
    })))
  })
}
