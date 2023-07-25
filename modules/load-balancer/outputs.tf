output "lb_id" {
  value       = oci_load_balancer_load_balancer.load_balancer.id
  description = "The OCID of the load balancer created"
}

output "waf_id" {
  value       = oci_waf_web_app_firewall.waf[0].id
  description = "The OCID of the web app firewall"
}
