output "vtap_id" {
  value       = oci_core_vtap.vtap.id
  description = "The OCID of the vtap created"
}

output "nlb_id" {
  value       = oci_network_load_balancer_network_load_balancer.vtap_nlb.id
  description = "The OCID of the network load balancer"
}

output "nlb_backend_set_name" {
  value       = oci_network_load_balancer_backend_set.vtap_nlb_backend_set.name
  description = "The name of the network load balancer backend set"
}
