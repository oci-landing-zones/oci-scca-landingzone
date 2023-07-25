output "bucket_id" {
  value       = oci_objectstorage_bucket.bucket.id
  description = "The OCID of the bucket created"
}
