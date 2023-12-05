## Summary
Terraform module for Virtual Test Access Point. 
VTAP functionality is sometimes referred to as traffic mirroring. 
It copies traffic that traverses a specific point in the network and 
sends the mirrored traffic to a network packet collector or network analytics 
tool for further analysis. VTAP supports both IPv4 and IPv6 traffic mirroring.

## Requirements

* VCN
* Load Balancer

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_core_capture_filter.capture_filter](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_capture_filter) | resource |
| [oci_core_vtap.vtap](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_vtap) | resource |
| [oci_network_load_balancer_backend_set.vtap_nlb_backend_set](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/network_load_balancer_backend_set) | resource |
| [oci_network_load_balancer_listener.vtap_nlb_listener](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/network_load_balancer_listener) | resource |
| [oci_network_load_balancer_network_load_balancer.vtap_nlb](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/network_load_balancer_network_load_balancer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_capture_filter_display_name"></a> [capture\_filter\_display\_name](#input\_capture\_filter\_display\_name) | The display name of capture filter | `string` | n/a | yes |
| <a name="input_capture_filter_filter_type"></a> [capture\_filter\_filter\_type](#input\_capture\_filter\_filter\_type) | Indicates which service will use this capture filter | `string` | `"VTAP"` | no |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | The OCID of the compartment containing the Vtap resource. | `string` | n/a | yes |
| <a name="input_is_vtap_enabled"></a> [is\_vtap\_enabled](#input\_is\_vtap\_enabled) | Option to enbale vtap | `bool` | `false` | no |
| <a name="input_nlb_backend_set_health_checker_protocol"></a> [nlb\_backend\_set\_health\_checker\_protocol](#input\_nlb\_backend\_set\_health\_checker\_protocol) | The backend set health checker protocol of network load balancer | `string` | `"TCP"` | no |
| <a name="input_nlb_backend_set_name"></a> [nlb\_backend\_set\_name](#input\_nlb\_backend\_set\_name) | The name of network load balancer backend set | `string` | n/a | yes |
| <a name="input_nlb_backend_set_policy"></a> [nlb\_backend\_set\_policy](#input\_nlb\_backend\_set\_policy) | Supported values are: FIVE\_TUPLE,THREE\_TUPLE,TWO\_TUPLE | `string` | `"FIVE_TUPLE"` | no |
| <a name="input_nlb_display_name"></a> [nlb\_display\_name](#input\_nlb\_display\_name) | The display name of network load balancer | `string` | n/a | yes |
| <a name="input_nlb_listener_name"></a> [nlb\_listener\_name](#input\_nlb\_listener\_name) | The name of network load balancer listener | `string` | n/a | yes |
| <a name="input_nlb_listener_port"></a> [nlb\_listener\_port](#input\_nlb\_listener\_port) | The port of network load balancer | `string` | `"4789"` | no |
| <a name="input_nlb_listener_protocol"></a> [nlb\_listener\_protocol](#input\_nlb\_listener\_protocol) | The protocol of network load balancer listener | `string` | `"UDP"` | no |
| <a name="input_nlb_subnet_id"></a> [nlb\_subnet\_id](#input\_nlb\_subnet\_id) | The subnet OCID of network load balancer | `string` | n/a | yes |
| <a name="input_vcn_id"></a> [vcn\_id](#input\_vcn\_id) | The OCID of the VCN | `string` | n/a | yes |
| <a name="input_vtap_capture_filter_rules"></a> [vtap\_capture\_filter\_rules](#input\_vtap\_capture\_filter\_rules) | The rules of vtap capture filter | `map(any)` | n/a | yes |
| <a name="input_vtap_display_name"></a> [vtap\_display\_name](#input\_vtap\_display\_name) | The display name of the vtap | `string` | n/a | yes |
| <a name="input_vtap_source_id"></a> [vtap\_source\_id](#input\_vtap\_source\_id) | The OCID of the source point where packets are captured. | `string` | n/a | yes |
| <a name="input_vtap_source_type"></a> [vtap\_source\_type](#input\_vtap\_source\_type) | Supported values are: VNIC,SUBNET,LOAD\_BALANCER,DB\_SYSTEM,EXADATA\_VM\_CLUSTER,AUTONOMOUS\_DATA\_WAREHOUSE. | `string` | n/a | yes |
| <a name="input_vtap_target_type"></a> [vtap\_target\_type](#input\_vtap\_target\_type) | Supported values are: VNIC,NETWORK\_LOAD\_BALANCER,IP\_ADDRESS | `string` | `"NETWORK_LOAD_BALANCER"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nlb_backend_set_name"></a> [nlb\_backend\_set\_name](#output\_nlb\_backend\_set\_name) | The name of the network load balancer backend set |
| <a name="output_nlb_id"></a> [nlb\_id](#output\_nlb\_id) | The OCID of the network load balancer |
| <a name="output_vtap_id"></a> [vtap\_id](#output\_vtap\_id) | The OCID of the vtap created |

## License

Copyright (c) 2023 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](../../LICENSE) for more details.