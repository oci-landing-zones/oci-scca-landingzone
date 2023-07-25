output "id" {
  value       = var.is_default == false ? oci_core_route_table.route_table[0].id : oci_core_default_route_table.defaultRouteTable[0].id
  description = "The OCID of the route table"
}
