# Table of Contents
- [General](#general)
- [Compartments](#compartments)
- [Logging](#logging)
- [Monitoring](#monitoring)
- [Network](#network)
- [Security](#security)

## General

| Variable Name | Description | Type | Default | Required |
| --- | --- | --- | --- | --- |
| region | the OCI home region | string | N/A | Yes |
| secondary_region | The secondary region used for replication and backup | string | N/A | Yes |
| tenancy_ocid | The OCID of tenancy | string | N/A | Yes |
| current_user_ocid | OCID of the current user | string | N/A | Yes |
| api_fingerprint | The fingerprint of API | string | "" | No |
| api_private_key_path | The local path to the API private key | string | "" | No |
| home_region_deployment | Set to true if deploying in home region, set to false for Backup Region Deployment | bool | true | No |
| compartments_dependency | A map of objects containing the externally managed compartments this module may depend on. All map objects must have the same type and must contain at least an 'id' attribute (representing the compartment OCID) of string type. | map(any) | null | No |
| topics_dependency | A map of objects containing the externally managed topics this module may depend on. All map objects must have the same type and must contain at least an 'id' attribute (representing the topic OCID) of string type. | map(any) | null | No |


## Compartments

| Variable Name | Description | Type | Default | Required |
| --- | --- | --- | --- | --- |
| home_compartment_name | Name of the Landing Zone Home compartment. | string | "OCI-SCCA-LZ-PARENT-Home" | No |
| vdms_compartment_name | Name of the VDMS compartment. | string | "OCI-SCCA-LZ-PARENT-VDMS" | No |
| vdss_compartment_name | Name of the VDSS compartment. | string | "OCI-SCCA-LZ-PARENT-VDSS" | No |
| logging_compartment_name | Name of the Logging compartment. | string | "OCI-SCCA-LZ-Logging" | No |
| backup_compartment_name | Name of the Logging compartment. | string | "OCI-SCCA-LZ-BACKUP-Config" | No |
| resource_label | Resource label to append to resource names to prevent collisions. | string | N/A | Yes |
| enable_compartment_delete | Set to true to allow the compartments to delete on terraform destroy. | bool | true | No |
| enable_logging_compartment | Set to true to enable logging compartment, to false if you already had existing buckets in another tenancy | bool | true | No |
| multi_region_home_compartment_ocid | OCID of the home compartment created in home region for multi-region deployment | string | "" | No |
| multi_region_logging_compartment_ocid | OCID of the workload compartment created in home region for multi-region deployment | string | "" | No |
| multi_region_vdss_compartment_ocid | OCID of the vdss compartment created in home region for multi-region deployment | string | "" | No |
| multi_region_vdms_compartment_ocid | OCID of the vdms compartment created in home region for multi-region deployment | string | "" | No |
| multi_region_workload_compartment_ocid | OCID of the workload compartment created in home region for multi-region deployment | string | "" | No |

## Logging

| Variable Name | Description | Type | Default | Required |
| --- | --- | --- | --- | --- |
| default_log_group_name | the display name of Default Log Group | string | "DEFAULT_PARENT_LOG_GROUP" | No |
| default_log_group_desc | Default Log Group Description | string | "DEFAULT_PARENT_LOG_GROUP_Description" | No |
| lb_access_log_name | LB Access Log Name | string | "OCI-SCCA-LZ-PARENT-LB-ACCESS-LOG" | No |
| lb_access_log_type | LB Access Log Type | string | "SERVICE" | No |
| lb_access_log_category | LB Access Log Category | string | "access" | No |
| lb_access_log_resource_id | LB Access Log Rescource ID | string | "" | No |
| lb_access_log_service | LB Access Log Service | string | "loadbalancer" | No |
| lb_error_log_name | LB Error Log Name | string | "OCI-SCCA-LZ-PARENT-LB-ERROR-LOG" | No |
| lb_error_log_type | LB Error Log Type | string | "SERVICE" | No |
| lb_error_log_category | LB Error Log Category | string | "error" | No |
| lb_error_log_resource_id | LB Error Log Resource ID | string | "" | No |
| lb_error_log_service | LB Error Log Service Type | string | "loadbalancer" | No |
| os_write_log_name | OS Write Log Name | string | "OCI-SCCA-LZ-PARENT-OS-WRITE-LOG" | No |
| os_write_log_type | OS Write Log Type | string | "SERVICE" | No |
| os_write_log_category | OS Write Log Category | string | "write" | No |
| os_write_log_service | OS Write Log Service | string | "objectstorage" | No |
| os_read_log_name | OS Read Log | string | "OCI-SCCA-LZ-PARENT-OS-READ-LOG" | No |
| os_read_log_type | OS Read Log Type | string | "SERVICE" | No |
| os_read_log_category | OS Read Log Category | string | "read" | No |
| os_read_log_service | OS Read Log Service Type | string | "objectstorage" | No |
| vss_log_name | VSS Log Name | string | "OCI-SCCA-LZ-PARENT-VSS-LOG" | No |
| vss_log_type | VSS Log Type | string | "SERVICE" | No |
| vss_log_category | VSS Log Category | string | "all" | No |
| vss_log_service | VSS Log Service Type | string | "flowlogs" | No |
| waf_log_name | WAF Log Name | string | "OCI-SCCA-LZ-PARENT-WAF-LOG" | No |
| waf_log_type | WAF Log Type | string | "SERVICE" | No |
| waf_log_category | WAF Log Category | string | "all" | No |
| waf_log_service | WAF Log Service Type | string | "waf" | No |
| event_log_name | Event Log Name | string | "OCI-SCCA-LZ-PARENT-EVENT-LOG" | No |
| event_log_type | Event Log Type | string | "SERVICE" | No |
| event_log_category | Event Log Category | string | "ruleexecutionlog" | No |
| event_log_service | Event Log Service Type | string | "cloudevents" | No |
| firewall_threat_log_name | Firewall Threat Log | string | "OCI-SCCA-LZ-PARENT-NFW-THREAT-LOG" | No |
| firewall_threat_log_type | Firewall Threat Log Type | string | "SERVICE" | No |
| firewall_threat_log_category | Firewall Threat Log Category | string | "threatlog" | No |
| firewall_threat_log_service | Firewall Threat Log Service Type | string | "ocinetworkfirewall" | No |
| firewall_traffic_log_name | Firewall Traffic Log | string | "OCI-SCCA-LZ-PARENT-NFW-TRAFFIC-LOG" | No |
| firewall_traffic_log_type | Firewall Traffic Log Type | string | "SERVICE" | No |
| firewall_traffic_log_category | Firewall Traffic Log Category | string | "trafficlog" | No |
| firewall_traffic_log_service | Firewall Traffic Log Service Type | string | "ocinetworkfirewall" | No |
| backup_bucket_name | Backup Bucket Name. | string | "OCI-SCCA-LZ-PARENT-BACKUP" | No |
| retention_policy_duration_amount | Retention Policy Duration Amount. | string | "1" | No |
| retention_policy_duration_time_unit | Retention Policy Duration In Time Unit. | string | "DAYS" | No |
| bucket_storage_tier | Bucket Storage Tier. | string | "Archive" | No |
| enable_bucket_replication | Enable to replicate buckets to secondary region. | bool | false | No |
| enable_vcn_flow_logs | Enable VCN Flow Logs on the VDSS Compartment. | bool | false | No |
| activate_service_connectors | Activate Service Connector After Provisioning. | bool | true | No |

## Monitoring

| Variable Name | Description | Type | Default | Required |
| --- | --- | --- | --- | --- |
| vdms_critical_topic_endpoints | List of email addresses for VDMS Critical notifications. | list(string) | [] | No |
| vdms_warning_topic_endpoints | List of email addresses for VDMS Warning notifications. | list(string) | [] | No |
| vdss_critical_topic_endpoints | List of email addresses for VDSS Critical notifications. | list(string) | [] | No |
| vdss_warning_topic_endpoints | List of email addresses for VDSS Warning notifications. | list(string) | [] | No |
| enable_vdss_warning_alarm | Enable warning alarms in VDSS compartment | bool | false | No |
| enable_vdss_critical_alarm | Enable critical alarms in VDSS compartment | bool | false | No |
| enable_vdms_warning_alarm | Enable warning alarms in VDMS compartment | bool | false | No |
| enable_vdms_critical_alarm | Enable critical alarms in VDMS compartment | bool | false | No |
| onboard_log_analytics | Set to true ONLY if your tenancy has NOT been onboarded onto log analytics (fails otherwise). Verify by visiting log analytics in the console. | bool | false | No |

## Network

| Variable Name | Description | Type | Default | Required |
| --- | --- | --- | --- | --- |
| vdss_vcn_cidr_block | CIDR block for the VDSS VCN | string | "192.168.0.0/24" | No |
| lb_subnet_cidr_block | CIDR block for the load balancer subnet | string | "192.168.0.128/25" | No |
| lb_subnet_name | Display name of the load balancer subnet | string | "OCI-SCCA-LZ-LB-SUBNET" | No |
| lb_dns_label | DNS label of the load balancer | string | "lbsubnet" | No |
| firewall_subnet_name | Display name of the firewall subnet | string | "OCI-SCCA-LZ-FW-SUBNET" | No |
| firewall_subnet_cidr_block | CIDR block for the firewall subnet | string | "192.168.0.0/25" | No |
| firewall_dns_label | DNS label of the firewall | string | "firewallsubnet" | No |
| workload_additionalsubnets_cidr_blocks | A list of subnets cidr blocks in additional workload stack in prod | list(string) | [] | No |
| vdms_vcn_cidr_block | CIDR block of the VDMS VCN | string | "192.168.1.0/24" | No |
| vdms_subnet_cidr_block | CIDR block of the VDMS subnet | string | "192.168.1.0/24" | No |
| vdms_dns_label | DNS label of the VDMS subnet | string | "vdmssubnet" | No |
| enable_vtap | Set to true to enable VTAP, set to false to disable VTAP | bool | true | No |
| enable_network_firewall | Set to true to deploy the Network Firewall, set to false otherwise | bool | true | No |
| enable_waf | Set to true to deploy and enable the WAF and WAA, set to false otherwise | bool | true | No |
| enable_service_deployment | Enable NFW Route Rules on the VDSS VCN. | bool | false | No |
| nfw_ip_ocid | NFW Forwarding IP OCID. | string | "" | No |
| child_vdss_vcn_cidr | CIDR block of the Child Template VDSS VCN. | string | "192.168.1.0/24" | No |
| child_vdms_vcn_cidr | CIDR block of the Child Template VDMS VCN. | string | "192.168.1.0/24" | No |

## Security

| Variable Name | Description | Type | Default | Required |
| --- | --- | --- | --- | --- |
| central_vault_name | the display name of vault | string | "OCI-SCCA-LZ-PARENT-Central-Vault" | No |
| master_encryption_key_name | the display name of key | string | "OCI-SCCA-LZ-PARENT-MSK" | No |
| central_vault_type | the type of the central vault: DEFAULT or VIRTUAL_PRIVATE | string | "DEFAULT" | No |
| enable_vault_replica | Only support for VIRTUAL_PRIVATE vault type | bool | false | No |
| cloud_guard_name | the cloud guard name | string | "OCI-SCCA-LZ-PARENT-CLOUD-GUARD" | No |
| cloud_guard_target_name | the cloud guard target name | string | "OCI-SCCA-LZ-PARENT-CLOUD-GUARD-TARGET" | No |
| enable_cloud_guard | the flag to enable cloud guard service | bool | false | No |
| host_scan_recipe_display_name | Host Scan Recipe Display Name | string | "OCI-SCCA-LZ-PARENT-HOST-SCAN-RECIPE" | No |
| vss_target_display_name | VSS Target Recipe Name | string | "OCI-SCCA-LZ-PARENT-VSS-Target" | No |
| vss_policy_display_name | VSS Policy Name | string | "OCI-SCCA-LZ-PARENT-VSS-Policy" | No |
| bastion_client_cidr_block_allow_list | the client CIDR block allow list of bastion | list(string) | ["10.0.0.0/0"] | No |
| bastion_display_name | the display name of bastion | string | "OCI-SCCA-LZ-PARENT-BASTION" | No |
| enable_bastion | Set to true to enable bastion service, set to false to disable bastion | bool | false | No |


