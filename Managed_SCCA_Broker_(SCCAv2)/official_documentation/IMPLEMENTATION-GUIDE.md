# OCI Managed SCCA Broker Landing Zone Implementation Guide

# Table of Contents

1. [Introduction](#introduction)
1. [Deployment Samples](#samples)

## <a name="introduction"></a>1. Introduction

The Managed SCCA Broker Landing Zone is designed to deploy an environment that supports Secure Cloud Computing Architecture (SCCA) standards for the US Department of Defense (DOD).
This configuration guide will detail the required and available configurations needed to deploy a Managed SCCA LZ on Oracle Cloud Infrastructure which is a requirement for DOD customers in the OC3 realm.  There are options of deploying a landing zone in either a single tenancy or multiple landing zones in a multitenancy configuration that supports a broker managed operational model.

## <a name="samples"></a>2. Deployment Samples

This section provides step by step deployment scenarios of the Managed SCCA LZ feature on parent and child tenancies. Please follow this ordered sequence of steps:

Single Tenancy Deployment 
1. Deploy Managed SCCA LZ on Single Tenancy.

Multitenancy Deployment

1. Deploy the Parent Baseline Template.
2. Deploy the Child Baseline Template.
3. Deploy the Parent Service Template.
4. Deploy the Child Service Template.

## 2.1 : Managed SCCA LZ Variables

### <ins>Parent Template Information<ins>

##### Parent Template tfvars Files:

* [Parent Baseline tfvars File Location](../parent-template/examples/baseline_terraform.tfvars.template)
* [Parent Service tfvars File Location](../parent-template/examples/service_terraform.tfvars.template)

#### Common Parent Tenancy Related Managed SCCA LZ Variables

| Variable Name      | Description| Type | Default
| ------------------- | ----- | ----- | ----- |
| <a name="resource_label"></a> [resource\_label](#enable\_network\_firewall\_prod)   | Parent Resource Label | `string` | `""`    |
| <a name="enable_domain_replication"></a> [enable\_domain\_replication](#enable\_network\_firewall\_prod)   | Enable to replicate domain to secondary region | `bool` | `false`    |
| <a name="identity_domain_license_type"></a> [identity\_domain\_license\_type](#enable\_network\_firewall\_prod)   | The license type of the identity domain(free/premium) | `string` | `""`    |
| <a name="realm_key"></a> [realm\_key](#enable\_network\_firewall\_prod)   | 1 for OC1 (commercial) and 3 for OC3 (government) | `string` | `"3"`    |
| <a name="home_region_deployment"></a> [home\_region\_deployment](#enable\_network\_firewall\_prod)   | Set to true if deploying in home region; set to false for backup region deployment | `bool` | `true`    |
| <a name="enable_logging_compartment"></a> [enable\_logging\_compartment](#enable\_network\_firewall\_prod)   | Set to true to enable logging compartment, to false if you already had existing buckets in another tenancy. | `bool` | `true`    |
| <a name="central_vault_type"></a> [central\_vault\_type](#enable\_network\_firewall\_prod)   | The type of the central vault: DEFAULT or VIRTUAL_PRIVATE | `string` | `"DEFAULT"`    |
| <a name="enable_vault_replica"></a> [enable\_vault\_replica](#enable\_network\_firewall\_prod)   | Only support for VIRTUAL_PRIVATE vault type | `bool` | `false`    |
| <a name="enable_cloud_guard"></a> [enable\_cloud\_guard](#enable\_network\_firewall\_prod)   | To enable Cloud Guard service | `bool` | `false`    |
| <a name="bastion_client_cidr_block_allow_list"></a> [bastion\_client\_cidr\_block\_allow\_list](#enable\_network\_firewall\_prod)   | Client CIDR block allow list of bastion | `string` | `""`    |
| <a name="enable_bastion"></a> [enable\_bastion](#enable\_network\_firewall\_prod)   | To enable Bastion service | `bool` | `false`    |
| <a name="vdms_critical_topic_endpoints"></a> [vdms\_critical\_topic\_endpoints](#enable\_network\_firewall\_prod)   | List of email addresses for VDMS Critical notifications | `list` | `""`    |
| <a name="vdms_warning_topic_endpoints"></a> [vdms\_warning\_topic\_endpoints](#enable\_network\_firewall\_prod)   | List of email addresses for VDMS Warning notifications | `list` | `""`    |
| <a name="vdss_critical_topic_endpoints"></a> [vdss\_critical\_topic\_endpoints](#enable\_network\_firewall\_prod)   | List of email addresses for VDSS Critical notifications | `list` | `""`    |
| <a name="vdss_warning_topic_endpoints"></a> [vdss\_warning\_topic\_endpoints](#enable\_network\_firewall\_prod)   | List of email addresses for VDSS Warning notifications | `list` | `""`    |
| <a name="enable_vdss_warning_alarm"></a> [enable\_vdss\_warning\_alarm](#enable\_network\_firewall\_prod)   | Enable warning alarms in VDSS compartment | `bool` | `false`    |
| <a name="enable_vdss_critical_alarm"></a> [enable\_vdss\_critical\_alarm](#enable\_network\_firewall\_prod)   | Enable critical alarms in VDSS compartment | `bool` | `false`    |
| <a name="enable_vdms_warning_alarm"></a> [enable\_vdms\_warning\_alarm](#enable\_network\_firewall\_prod)   | Enable warning alarms in VDMS compartment | `bool` | `false`    |
| <a name="enable_vdms_critical_alarm"></a> [enable\_vdms\_critical\_alarm](#enable\_network\_firewall\_prod)   | Enable critical alarms in VDMS compartment | `bool` | `false`    |
| <a name="vdss_vcn_cidr_block"></a> [vdss\_vcn\_cidr\_block](#enable\_network\_firewall\_prod)   | VDSS VCN CIDR block | `string` | `""`    |
| <a name="lb_subnet_cidr_block"></a> [lb\_subnet\_cidr\_block](#enable\_network\_firewall\_prod)   | Load Balancer subnet CIDR block | `string` | `""`    |
| <a name="lb_subnet_name"></a> [lb\_subnet\_name](#enable\_network\_firewall\_prod)   | Load Balancer subnet name | `string` | `""`    |
| <a name="lb_dns_label"></a> [lb\_dns\_label](#enable\_network\_firewall\_prod)   | Load Balancer DNS label | `string` | `""`    |
| <a name="firewall_subnet_name"></a> [firewall\_subnet\_name](#enable\_network\_firewall\_prod)   | Network firewall subnet name | `string` | `""`    |
| <a name="firewall_subnet_cidr_block"></a> [firewall\_subnet\_cidr\_block](#enable\_network\_firewall\_prod)   | Network firewall subnet CIDR block | `string` | `""`    |
| <a name="firewall_dns_label"></a> [firewall\_dns\_label](#enable\_network\_firewall\_prod)   | Network firewall DNS label | `string` | `""`    |
| <a name="vdms_vcn_cidr_block"></a> [vdms\_vcn\_cidr\_block](#enable\_network\_firewall\_prod)   | VDMS VCN CIDR block | `string` | `""`    |
| <a name="vdms_subnet_cidr_block"></a> [vdms\_subnet\_cidr\_block](#enable\_network\_firewall\_prod)   | VDMS VCN subnet CIDR block | `string` | `""`    |
| <a name="vdms_dns_label"></a> [vdms\_dns\_label](#enable\_network\_firewall\_prod) | VDMS DNS label | `string` | `""`    |
| <a name="vdms_subnet_name"></a> [vdms\_subnet\_name](#enable\_network\_firewall\_prod) | VDMS subnet name | `string` | `""`    |
| <a name="enable_vtap"></a> [enable\_vtap](#enable\_network\_firewall\_prod) | Enable VTAP | `bool` | `true`    |
| <a name="enable_network_firewall"></a> [enable\_network\_firewall](#enable\_network\_firewall\_prod) | Enable network firewall | `bool` | `true`    |
| <a name="enable_waf"></a> [enable\_waf](#enable\_network\_firewall\_prod) | Enable WAF | `bool` | `true` |
| <a name="activate_service_connectors"></a> [activate\_service\_connectors](#enable\_network\_firewall\_prod) | Activate Service Connector after deploying | `bool` | `true` |

### Baseline Specific Parent Template Variables

| Variable Name      | Description| Type | Expected Value
| ------------------- | ----- | ----- | ----- |
| <a name="enable_service_deployment"></a> [enable\_service\_deployment](#enable\_network\_firewall\_prod)   | Service Deployment | `bool` | `false`    |
| <a name="enable_vcn_flow_logs"></a> [enable\_vcn\_flow\_logs](#enable\_network\_firewall\_prod)   | Enable VCN flow logs | `bool` | `false`    |

### Service Specific Parent Template Variables

| Variable Name      | Description| Type | Expected Value
| ------------------- | ----- | ----- | ----- |
| <a name="enable_service_deployment"></a> [enable\_service\_deployment](#enable\_network\_firewall\_prod)   | Service Deployment | `bool` | `true`    |
| <a name="enable_vcn_flow_logs"></a> [enable\_vcn\_flow\_logs](#enable\_network\_firewall\_prod)   | Enable VCN flow logs if needed | `bool` | `true` |
| <a name="nfw_ip_ocid"></a> [nfw\_ip\_ocid](#enable\_network\_firewall\_prod)   | Network firewall forwarding IP OCID | `string` | `"OCID Value"` |
| <a name="child_tenancy_ocid"></a> [child\_tenancy\_ocid](#enable\_network\_firewall\_prod) | Child tenancy OCID | `string` | `"OCID Value"` |
| <a name="child_admin_group_ocid"></a> [child\_admin\_group\_ocid](#enable\_network\_firewall\_prod) | Child administrator group OCID. | `string` | `"OCID Value"` |
| <a name="child_vdss_vcn_cidr"></a> [child\_vdss\_vcn\_cidr](#enable\_network\_firewall\_prod) | Child VDSS VCN CIDR block | `string` | `""` |
| <a name="child_vdms_vcn_cidr"></a> [child\_vdms\_vcn\_cidr](#enable\_network\_firewall\_prod) | Child VDMS VCN CIDR block | `string` | `""` |

### <ins>Child Template Information<ins>

##### Child Template tfvars Files:

* [Child Baseline tfvars File Location](../child-template/examples/baseline_terraform.tfvars.template)
* [Child Service tfvars File Location](../child-template/examples/service_terraform.tfvars.template)

#### Common Child Tenancy Related Managed SCCA LZ Variables

| Variable Name      | Description| Type | Default
| ------------------- | ----- | ----- | ----- |
| <a name="resource_label"></a> [resource\_label](#enable\_network\_firewall\_prod)   | Parent Resource Label | `string` | `""`    |
| <a name="enable_domain_replication"></a> [enable\_domain\_replication](#enable\_network\_firewall\_prod)   | Enable to replicate domain to secondary region | `bool` | `false`    |
| <a name="identity_domain_license_type"></a> [identity\_domain\_license\_type](#enable\_network\_firewall\_prod)   | The license type of the identity domain(free/premium)| `string` | `""`    |
| <a name="realm_key"></a> [realm\_key](#enable\_network\_firewall\_prod)   | 1 for OC1 (commercial) and 3 for OC3 (government). | `string` | `"3"`    |
| <a name="home_region_deployment"></a> [home\_region\_deployment](#enable\_network\_firewall\_prod)   | Set to true if deploying in home region; set to false for backup region deployment | `bool` | `true`    |
| <a name="enable_logging_compartment"></a> [enable\_logging\_compartment](#enable\_network\_firewall\_prod)   | Set to true to enable logging compartment, to false if you already had existing buckets in another tenancy | `bool` | `true`    |
| <a name="central_vault_type"></a> [central\_vault\_type](#enable\_network\_firewall\_prod)   | The type of the central vault: DEFAULT or VIRTUAL_PRIVATE | `string` | `"DEFAULT"`    |
| <a name="enable_vault_replica"></a> [enable\_vault\_replica](#enable\_network\_firewall\_prod)   | Only support for VIRTUAL_PRIVATE vault type | `bool` | `false`    |
| <a name="enable_cloud_guard"></a> [enable\_cloud\_guard](#enable\_network\_firewall\_prod)   | To enable Cloud Guard service | `bool` | `false`    |
| <a name="bastion_client_cidr_block_allow_list"></a> [bastion\_client\_cidr\_block\_allow\_list](#enable\_network\_firewall\_prod)   | Client CIDR block allow list of bastion | `string` | `""`    |
| <a name="enable_bastion"></a> [enable\_bastion](#enable\_network\_firewall\_prod)   | To enable Bastion service | `bool` | `false`    |
| <a name="vdms_critical_topic_endpoints"></a> [vdms\_critical\_topic\_endpoints](#enable\_network\_firewall\_prod)   | List of email addresses for VDMS Critical notifications | `list` | `""`    |
| <a name="vdms_warning_topic_endpoints"></a> [vdms\_warning\_topic\_endpoints](#enable\_network\_firewall\_prod)   | List of email addresses for VDMS Warning notifications | `list` | `""`    |
| <a name="vdss_critical_topic_endpoints"></a> [vdss\_critical\_topic\_endpoints](#enable\_network\_firewall\_prod)   | List of email addresses for VDSS Critical notifications | `list` | `""`    |
| <a name="vdss_warning_topic_endpoints"></a> [vdss\_warning\_topic\_endpoints](#enable\_network\_firewall\_prod)   | List of email addresses for VDSS Warning notifications | `list` | `""`    |
| <a name="enable_vdss_warning_alarm"></a> [enable\_vdss\_warning\_alarm](#enable\_network\_firewall\_prod)   | Enable warning alarms in VDSS compartment | `bool` | `false`    |
| <a name="enable_vdss_critical_alarm"></a> [enable\_vdss\_critical\_alarm](#enable\_network\_firewall\_prod)   | Enable critical alarms in VDSS compartment | `bool` | `false`    |
| <a name="enable_vdms_warning_alarm"></a> [enable\_vdms\_warning\_alarm](#enable\_network\_firewall\_prod)   | Enable warning alarms in VDMS compartment | `bool` | `false`    |
| <a name="enable_vdms_critical_alarm"></a> [enable\_vdms\_critical\_alarm](#enable\_network\_firewall\_prod)   | Enable critical alarms in VDMS compartment | `bool` | `false`    |
| <a name="vdss_vcn_cidr_block"></a> [vdss\_vcn\_cidr\_block](#enable\_network\_firewall\_prod)   | VDSS VCN CIDR block | `string` | `""`    |
| <a name="lb_subnet_cidr_block"></a> [lb\_subnet\_cidr\_block](#enable\_network\_firewall\_prod)   | Load Balancer subnet CIDR block | `string` | `""`    |
| <a name="lb_subnet_name"></a> [lb\_subnet\_name](#enable\_network\_firewall\_prod)   | Load Balancer subnet name | `string` | `""`    |
| <a name="lb_dns_label"></a> [lb\_dns\_label](#enable\_network\_firewall\_prod)   | Load Balancer DNS label | `string` | `""`    |
| <a name="firewall_subnet_name"></a> [firewall\_subnet\_name](#enable\_network\_firewall\_prod)   | Network firewall subnet name | `string` | `""`    |
| <a name="firewall_subnet_cidr_block"></a> [firewall\_subnet\_cidr\_block](#enable\_network\_firewall\_prod)   | Network firewall subnet CIDR block | `string` | `""`    |
| <a name="firewall_dns_label"></a> [firewall\_dns\_label](#enable\_network\_firewall\_prod)   | Network firewall DNS label | `string` | `""`    |
| <a name="vdms_vcn_cidr_block"></a> [vdms\_vcn\_cidr\_block](#enable\_network\_firewall\_prod)   | VDMS VCN CIDR block | `string` | `""`    |
| <a name="vdms_subnet_cidr_block"></a> [vdms\_subnet\_cidr\_block](#enable\_network\_firewall\_prod)   | VDMS VCN subnet CIDR block | `string` | `""`    |
| <a name="vdms_dns_label"></a> [vdms\_dns\_label](#enable\_network\_firewall\_prod)   | VDMS DNS Label. | `string` | `""`    |
| <a name="vdms_subnet_name"></a> [vdms\_subnet\_name](#enable\_network\_firewall\_prod)   | VDMS subnet name | `string` | `""`    |
| <a name="enable_vtap"></a> [enable\_vtap](#enable\_network\_firewall\_prod)   | Enable VTAP. | `bool` | `true`    |
| <a name="enable_network_firewall"></a> [enable\_network\_firewall](#enable\_network\_firewall\_prod)   | Enable network firewall | `bool` | `true`    |
| <a name="enable_waf"></a> [enable\_waf](#enable\_network\_firewall\_prod)   | Enable WAF. | `bool` | `true`    |
| <a name="activate_service_connectors"></a> [activate\_service\_connectors](#enable\_network\_firewall\_prod)   | Activate Service Connector after deploying | `bool` | `true`    |

### Baseline Specific Child Template Variables

| Variable Name      | Description| Type | Expected Value
| ------------------- | ----- | ----- | ----- |
| <a name="enable_service_deployment"></a> [enable\_service\_deployment](#enable\_network\_firewall\_prod)   | Service deployment | `bool` | `false`    |
| <a name="enable_vcn_flow_logs"></a> [enable\_vcn\_flow\_logs](#enable\_network\_firewall\_prod)   | Enable VCN flow logs | `bool` | `false`    |

### Service Specific Child Template Variables

| Variable Name      | Description| Type | Expected Value
| ------------------- | ----- | ----- | ----- |
| <a name="enable_service_deployment"></a> [enable\_service\_deployment](#enable\_network\_firewall\_prod)   | Service deployment | `bool` | `true`    |
| <a name="enable_vcn_flow_logs"></a> [enable\_vcn\_flow\_logs](#enable\_network\_firewall\_prod)   | Enable VCN flow logs if needed | `bool` | `true` |
| <a name="nfw_ip_ocid"></a> [nfw\_ip\_ocid](#enable\_network\_firewall\_prod)   | Network firewall forwarding IP OCID | `string` | `"OCID Value"` |
| <a name="parent_namespace"></a> [parent\_namespace](#enable\_network\_firewall\_prod)   | Parent template namespace | `string` | `"namespace Value"` |
| <a name="scca_parent_logging_compartment_ocid"></a> [scca\_parent\_logging\_compartment\_ocid](#enable\_network\_firewall\_prod)   | Parent template Logging compartment OCID | `string` | `"OCID Value"` |
| <a name="parent_resource_label"></a> [parent\_resource\_label](#enable\_network\_firewall\_prod)   | Parent template resource label | `string` | `""` |

### Single Tenancy Deployment Variables

To Deploy Managed SCCA LZ Parent on Single Tenancy use this variable.

| Variable Name      | Description| Type | Expected Value
| ------------------- | ----- | ----- | ----- |
| <a name="deployment_type"></a> [deployment\_type](#deployment\_type)   | Single Tenancy deployment | `string` | `SINGLE`    |


## 2.2 : Managed SCCA LZ Deployment

### 2.2.1 : Managed SCCA LZ Parent Baseline Deployment

* Step 2.2.1.1) Go to folder [Parent_Examples](../parent-template/examples) and copy the baseline_terraform.tfvars.template file.
* Step 2.2.1.2) Go to folder [Parent_Template](../parent-template) and paste the baseline_terraform.tfvars.template file.
* Step 2.2.1.3) Rename the file name from baseline_terraform.tfvars.template file to baseline_terraform.tfvars.
* Step 2.2.1.4) Execute the CLI command "terraform init".
* Step 2.2.1.5) Execute the CLI command "terraform plan -var-file="baseline_terraform.tfvars".
* Step 2.2.1.6) Make sure the "terraform plan" command successfully exited.
* Step 2.2.1.7) Execute the CLI command "terraform apply -var-file="baseline_terraform.tfvars".
* Step 2.2.1.8) When prompted enter "yes" and then enter.
* Step 2.2.1.9) Make sure the "terraform apply" command gracefully exited from the current shell.

### 2.2.2 : Managed SCCA LZ Child Baseline Deployment

* Step 2.2.2.1) Go to folder [Child_Examples](../child-template/examples) and copy the baseline_terraform.tfvars.template file.
* Step 2.2.2.2) Go to folder [Child_Template](../child-template) and paste the baseline_terraform.tfvars.template file.
* Step 2.2.2.3) Rename the file name from baseline_terraform.tfvars.template file to baseline_terraform.tfvars.
* Step 2.2.2.4) Execute the CLI command "terraform init".
* Step 2.2.2.5) Execute the CLI command "terraform plan -var-file="baseline_terraform.tfvars".
* Step 2.2.2.6) Make sure the "terraform plan" command successfully exited.
* Step 2.2.2.7) Execute the CLI command "terraform apply -var-file="baseline_terraform.tfvars".
* Step 2.2.2.8) When prompted enter "yes" and then enter.
* Step 2.2.2.9) Make sure the "terraform apply" command gracefully exited from the current shell.

### 2.2.3 : Managed SCCA LZ Parent Service Deployment

* Step 2.2.3.1) Go to folder [Parent_Examples](../parent-template/examples) and copy the service_terraform.tfvars.template file.
* Step 2.2.3.2) Go to folder [Parent_Template](../parent-template) and paste the service_terraform.tfvars.template file.
* Step 2.2.3.3) Rename the file name from service_terraform.tfvars.template file to service_terraform.tfvars.
* Step 2.2.3.4) Execute the CLI command "terraform plan -var-file="service_terraform.tfvars".
* Step 2.2.3.5) Make sure the "terraform plan" command successfully exited.
* Step 2.2.3.6) Execute the CLI command "terraform apply -var-file="service_terraform.tfvars".
* Step 2.2.3.7) When prompted enter "yes" and then enter.
* Step 2.2.3.8) Make sure the "terraform apply" command gracefully exited from the current shell.

### 2.2.4 : Managed SCCA LZ Child Service Deployment

* Step 2.2.4.1) Go to folder [Child_Examples](../child-template/examples) and copy the service_terraform.tfvars.template file.
* Step 2.2.4.2) Go to folder [Child_Template](../child-template) and paste the service_terraform.tfvars.template file.
* Step 2.2.4.3) Rename the file name from service_terraform.tfvars.template file to service_terraform.tfvars.
* Step 2.2.4.4) Execute the CLI command "terraform plan -var-file="service_terraform.tfvars".
* Step 2.2.4.5) Make sure the "terraform plan" command successfully exited.
* Step 2.2.4.6) Execute the CLI command "terraform apply -var-file="service_terraform.tfvars".
* Step 2.2.4.7) When prompted enter "yes" and then enter.
* Step 2.2.4.8) Make sure the "terraform apply" command gracefully exited from the current shell.

### 2.2.5 : Managed SCCA LZ Workload Template Deployment

* Step 2.2.5.1) Go to folder [Workload_Examples](../workload-template/example) and copy the terraform.tfvars file.
* Step 2.2.5.2) Go to folder [Workload_Template](../workload-template) and copy the terraform.tfvars file.
* Step 2.2.5.3) Update the terraform.tfvars file variables.
* Step 2.2.2.4) Execute the CLI command "terraform init".
* Step 2.2.2.5) Execute the CLI command "terraform plan".
* Step 2.2.2.6) Execute the CLI command "terraform apply".
* Step 2.2.2.7) Make sure the "terraform apply" command gracefully exited from the current shell.

### 2.2.6 : Managed SCCA LZ Workload Update Child Template Route Rules

* Step 2.2.6.1) Go to Child Template folder.
* Step 2.2.6.2) Add the Workload VCN CIDR Block in service Template workload_additionalsubnets_cidr_blocks variable.
* Step 2.2.6.3) Execute the CLI command "terraform apply -var-file="service_terraform.tfvars".
* Step 2.2.6.4) Make sure the "terraform apply" command gracefully exited from the current shell.

## 2.3 : Managed SCCA LZ Deployment on Single Tenancy

* Step 2.3.1.1) Go to Folder Child_Examples and copy the single_terraform.tfvars.template file.
* Step 2.3.1.2) Go to Folder Child_Template and paste the single_terraform.tfvars.template file.
* Step 2.3.1.3) Rename the file name from single_terraform.tfvars.template file to single_terraform.tfvars.
* Step 2.3.1.4) Set the Flag "deployment_type" to "SINGLE" on the single_terraform.tfvars file (Flag Already Set in tfvars file).
* Step 2.3.1.5) Execute the CLI command "terraform init".
* Step 2.3.1.6) Execute the CLI command "terraform plan -var-file="single_terraform.tfvars".
* Step 2.3.1.7) Make Sure the Terraform Plan Command Successfully Exited.
* Step 2.3.1.8) Execute the CLI command "terraform apply -var-file="single_terraform.tfvars".
* Step 2.3.1.9) When prompted enter "yes" and then enter.
* Step 2.3.1.10) Make sure the "terraform apply" command gracefully exited from the current shell.
