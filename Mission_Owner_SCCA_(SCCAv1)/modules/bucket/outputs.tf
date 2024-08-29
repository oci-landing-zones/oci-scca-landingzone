# ###################################################################################################### #
# Copyright (c) 2023 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #

output "bucket_id" {
  value       = oci_objectstorage_bucket.bucket.id
  description = "The OCID of the bucket created"
}
