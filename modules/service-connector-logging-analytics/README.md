## Summery
Terraform module for logging analytics service connector.
Service Connector Hub is a cloud message bus
platform that offers a single pane of glass for describing,
executing, and monitoring interactions when moving data between
Oracle Cloud Infrastructure services.

## Requirements

* logging-analytics-log-group
* logging-analytics

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_sch_service_connector.service_connector](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/sch_service_connector) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | The OCID of the comparment to create the service connector in. | `string` | n/a | yes |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | The display name of service connector | `string` | n/a | yes |
| <a name="input_source_kind"></a> [source\_kind](#input\_source\_kind) | The source type discriminator. | `string` | n/a | yes |
| <a name="input_source_log_group_id"></a> [source\_log\_group\_id](#input\_source\_log\_group\_id) | The OCID of source log group | `string` | n/a | yes |
| <a name="input_target_kind"></a> [target\_kind](#input\_target\_kind) | The target type discriminator. | `string` | n/a | yes |
| <a name="input_target_log_group_id"></a> [target\_log\_group\_id](#input\_target\_log\_group\_id) | The OCID of target log group | `string` | n/a | yes |

## Outputs

No outputs.

## License

Copyright (c) 2022,2023 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](../../LICENSE) for more details.