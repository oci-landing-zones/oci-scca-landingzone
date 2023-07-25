output "bastion_ocid" {
  value = module.bastion.bastion_ocid
}

output "policy_to_add" {
  value = <<EOT
  The remote buckets should be created in the same region as SCCA LZ created.
  Please also add below policy to the root level of the remote tenancy:
  define tenancy SCCA-LZ-Tenancy as ${var.remote_tenancy_ocid},
  admit any-user of tenancy SCCA-LZ-Tenancy to manage object-family in tenancy
  EOT
}