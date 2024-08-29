## Summary
Terraform module for OCI Load Balancer. 

## Requirements

* VCN

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_load_balancer_load_balancer.load_balancer](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/load_balancer_load_balancer) | resource |
| [oci_waa_web_app_acceleration.waa](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/waa_web_app_acceleration) | resource |
| [oci_waa_web_app_acceleration_policy.waa_policy](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/waa_web_app_acceleration_policy) | resource |
| [oci_waf_web_app_firewall.waf](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/waf_web_app_firewall) | resource |
| [oci_waf_web_app_firewall_policy.waf_policy](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/waf_web_app_firewall_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | Compartment id where to create lb resources | `string` | n/a | yes |
| <a name="input_lb_add_waa"></a> [lb\_add\_waa](#input\_lb\_add\_waa) | Add Web Application Accelerator to LB? | `bool` | `false` | no |
| <a name="input_lb_add_waf"></a> [lb\_add\_waf](#input\_lb\_add\_waf) | Add Web Application Firewall to LB? | `bool` | `false` | no |
| <a name="input_load_balancer_display_name"></a> [load\_balancer\_display\_name](#input\_load\_balancer\_display\_name) | (Updatable) Name of Load Balancer. Does not have to be unique. | `string` | n/a | yes |
| <a name="input_load_balancer_ip_mode"></a> [load\_balancer\_ip\_mode](#input\_load\_balancer\_ip\_mode) | IP mode (IPv4 or IPv6) for Load balancer | `string` | `"IPV4"` | no |
| <a name="input_load_balancer_is_private"></a> [load\_balancer\_is\_private](#input\_load\_balancer\_is\_private) | Is LB private? (true/false) | `bool` | `true` | no |
| <a name="input_load_balancer_max_bw_mbps"></a> [load\_balancer\_max\_bw\_mbps](#input\_load\_balancer\_max\_bw\_mbps) | Maximum bandwidth for flexible LB shape | `number` | `30` | no |
| <a name="input_load_balancer_min_bw_mbps"></a> [load\_balancer\_min\_bw\_mbps](#input\_load\_balancer\_min\_bw\_mbps) | Minimum bandwidth for flexible LB shape | `number` | `10` | no |
| <a name="input_load_balancer_shape"></a> [load\_balancer\_shape](#input\_load\_balancer\_shape) | Shape for Load Balancer | `string` | `"flexible"` | no |
| <a name="input_load_balancer_subnet_ids"></a> [load\_balancer\_subnet\_ids](#input\_load\_balancer\_subnet\_ids) | Subnet OCIDs for LB | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lb_id"></a> [lb\_id](#output\_lb\_id) | The OCID of the load balancer created |
| <a name="output_waf_id"></a> [waf\_id](#output\_waf\_id) | The OCID of the web app firewall |

## License

Copyright (c) 2023 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](../../LICENSE.txt) for more details.