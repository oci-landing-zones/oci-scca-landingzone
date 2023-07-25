
output "compartment_id" {
  value       = oci_identity_compartment.compartment.id
  description = "The OCID of the compartment created"
}

output "compartment_name" {
  value       = oci_identity_compartment.compartment.name
  description = "The name of the compartment created"
}
