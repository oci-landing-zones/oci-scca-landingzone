## Summary
Terraform module for Virtual Cloud Network, subnets, and default security list.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_core_default_security_list.lockdown](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_default_security_list) | resource |
| [oci_core_default_security_list.open](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_default_security_list) | resource |
| [oci_core_subnet.subnet](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | resource |
| [oci_core_vcn.vcn](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_vcn) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | The OCID of the compartment to contain the VCN. | `string` | n/a | yes |
| <a name="input_enable_ipv6"></a> [enable\_ipv6](#input\_enable\_ipv6) | Option to enable ipv6 | `bool` | `false` | no |
| <a name="input_lockdown_default_seclist"></a> [lockdown\_default\_seclist](#input\_lockdown\_default\_seclist) | Block all ingress and egress traffic on the default security list(attached to subnets that do not specify a security list) if enabled, else allow all traffic. | `bool` | `true` | no |
| <a name="input_subnet_map"></a> [subnet\_map](#input\_subnet\_map) | The map of subnets including subnet name, description, dns label, subnet cidr block. | <pre>map(object({<br>    name                       = string,<br>    description                = string,<br>    dns_label                  = string,<br>    cidr_block                 = string,<br>    prohibit_public_ip_on_vnic = bool<br>  }))</pre> | n/a | yes |
| <a name="input_vcn_cidr_block"></a> [vcn\_cidr\_block](#input\_vcn\_cidr\_block) | The CIDR block of VCN | `string` | n/a | yes |
| <a name="input_vcn_display_name"></a> [vcn\_display\_name](#input\_vcn\_display\_name) | The display name of VCN | `string` | n/a | yes |
| <a name="input_vcn_dns_label"></a> [vcn\_dns\_label](#input\_vcn\_dns\_label) | The DNS label of VCN | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnets"></a> [subnets](#output\_subnets) | The subnet OCID |
| <a name="output_vcn"></a> [vcn](#output\_vcn) | n/a |
| <a name="output_vcn_id"></a> [vcn\_id](#output\_vcn\_id) | The OCID of the VCN created |

## License

Copyright (c) 2022,2023 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](./LICENSE) for more details.