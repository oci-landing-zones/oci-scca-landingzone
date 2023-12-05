output "firewall_id" {
  value       = oci_network_firewall_network_firewall.network_firewall.id
  description = "The OCID of network firewall"
}

# Not sure why we are fetching the FW IP this way....  
output "firewall_ip_id" {
  value       = data.oci_core_private_ips.firewall_subnet_private_ip.private_ips[0].id
  description = "The OCID of network firewall ip"
}

output "firewall_policy_id" {
  value       = oci_network_firewall_network_firewall_policy.network_firewall_policy.id
  description = "The OCID of the network firewall policy"
}
