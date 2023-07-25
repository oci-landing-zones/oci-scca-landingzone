terraform {
  required_providers {
    oci = {
      source                = "oracle/oci"
      configuration_aliases = [oci, oci.secondary_region]
    }
  }
}

resource "oci_objectstorage_bucket" "bucket" {
  compartment_id = var.compartment_id
  name           = var.name
  namespace      = data.oci_objectstorage_namespace.ns.namespace
  access_type    = "NoPublicAccess"
  kms_key_id     = var.kms_key_id
  storage_tier   = var.storage_tier

  retention_rules {
    display_name = var.retention_rule_display_name

    duration {
      time_amount = var.retention_policy_duration_amount
      time_unit   = var.retention_policy_duration_time_unit
    }
  }
}

locals {
  replication_policy = {
    name = "scca-bucket-replication-policy"
  }
  bucket_replica = {
    name = "${var.name}-replica"
  }
}
resource "oci_objectstorage_replication_policy" "replication_policy" {
  count                   = var.enable_replication ? 1 : 0
  bucket                  = oci_objectstorage_bucket.bucket.name
  destination_bucket_name = oci_objectstorage_bucket.bucket_replica[0].name
  destination_region_name = var.replica_region
  name                    = local.replication_policy.name
  namespace               = data.oci_objectstorage_namespace.ns.namespace
}

resource "oci_objectstorage_bucket" "bucket_replica" {
  provider = oci.secondary_region

  count          = var.enable_replication ? 1 : 0
  compartment_id = var.compartment_id
  name           = local.bucket_replica.name
  namespace      = data.oci_objectstorage_namespace.ns.namespace
  access_type    = "NoPublicAccess"
  storage_tier   = var.storage_tier
}
