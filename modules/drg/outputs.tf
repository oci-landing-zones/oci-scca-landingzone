output "drg_id" {
  description = "id of drg if it is created"
  value       = oci_core_drg.drg.id
}

output "drg_attachment_all_attributes" {
  description = "all attributes related to drg attachment"
  value       = { for k, v in oci_core_drg_attachment.drg_vcn_attachment : k => v }
}