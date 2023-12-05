## Summary
Terraform module for Logging Analytics Log Group.

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
| [oci_log_analytics_log_analytics_log_group.log_analytics_log_group](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/log_analytics_log_analytics_log_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | The OCID of compartment to create the log group | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | The description of log group | `string` | n/a | yes |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | The display name of log group | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The Logging Analytics namespace used for the request. | `string` | n/a | yes |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | The OCID of tenancy | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_log_group_ocid"></a> [log\_group\_ocid](#output\_log\_group\_ocid) | The OCID of log group created |

## License

Copyright (c) 2022,2023 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](../../LICENSE) for more details.