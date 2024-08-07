## Summary
Terraform module for OCI Policy creation.

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
| [oci_events_rule.event_rule](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/events_rule) | resource |
| [oci_ons_notification_topic.topic_service](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/ons_notification_topic) | resource |
| [oci_ons_subscription.subscription_service](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/ons_subscription) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | The OCID of the compartment to create the topic in. | `string` | n/a | yes |
| <a name="input_event_rules"></a> [event\_rules](#input\_event\_rules) | n/a | `map(any)` | `{}` | no |
| <a name="input_subscription_endpoint"></a> [subscription\_endpoint](#input\_subscription\_endpoint) | A locator that corresponds to the subscription protocol. | `list(string)` | n/a | yes |
| <a name="input_subscription_protocol"></a> [subscription\_protocol](#input\_subscription\_protocol) | Valid values: CUSTOM\_HTTPS, EMAIL, ORACLE\_FUNCTIONS, PAGERDUTY, SLACK, SMS | `string` | n/a | yes |
| <a name="input_topic_description"></a> [topic\_description](#input\_topic\_description) | The description of the topic being created | `string` | n/a | yes |
| <a name="input_topic_name"></a> [topic\_name](#input\_topic\_name) | The name of the topic being created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subscription_id"></a> [subscription\_id](#output\_subscription\_id) | The subscriptions, indexed by ID. |
| <a name="output_topic_id"></a> [topic\_id](#output\_topic\_id) | The OCID of the topic created |
✔ ~/workspace/orahub/scca-test/scca-landing-zone/modules/notification-topic [LANZ-650|✚ 6…6]
14:16 $ cd ..
✔ ~/workspace/orahub/scca-test/scca-landing-zone/modules [LANZ-650|✚ 6…7]
14:17 $ cd policies/
✔ ~/workspace/orahub/scca-test/scca-landing-zone/modules/policies [LANZ-650|✚ 6…7]
14:17 $ terraform-docs markdown table .
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_identity_policy.policies](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_policy) | resource |
| [time_sleep.policy_propagation_delay](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_ocid"></a> [compartment\_ocid](#input\_compartment\_ocid) | The OCID of the compartment containing the policy. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | The description of policy | `string` | n/a | yes |
| <a name="input_policy_name"></a> [policy\_name](#input\_policy\_name) | The name of policy. | `string` | n/a | yes |
| <a name="input_statements"></a> [statements](#input\_statements) | An array of policy statements written in the policy language. | `list(string)` | n/a | yes |

## Outputs

No outputs.

## License

Copyright (c) 2023 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](../../license.txt) for more details.