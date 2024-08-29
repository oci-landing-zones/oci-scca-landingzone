## Summary
Terraform module for dynamic groups, that
allow you to group Oracle Cloud Infrastructure 
compute instances as "principal" actors (similar to user groups).

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
| [oci_identity_dynamic_group.dynamic_group](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_dynamic_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dynamic_group_description"></a> [dynamic\_group\_description](#input\_dynamic\_group\_description) | The description you assign to the Group. Does not have to be unique, and it's changeable. | `string` | n/a | yes |
| <a name="input_dynamic_group_name"></a> [dynamic\_group\_name](#input\_dynamic\_group\_name) | The name you assign to the group during creation. The name must be unique across all compartments in the tenancy. | `string` | n/a | yes |
| <a name="input_matching_rule"></a> [matching\_rule](#input\_matching\_rule) | Define a matching rule or a set of matching rules to define the group members. | `string` | n/a | yes |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | The OCID of the tenancy. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The OCID of dynamic group created |
| <a name="output_name"></a> [name](#output\_name) | The name of dynamic group created |

## License

Copyright (c) 2023 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](../../LICENSE.txt) for more details.