# OCI Managed SCCA Broker Landing Zone Configuration Guide

## Table of Contents

1. [Introduction](#introduction)
1. [Prerequisites](#prerequisites)
1. [Minimum Required Configuration](#configuration)
1. [Compartment](#compartment)
1. [Identity](#identity)
1. [Monitoring](#monitoring)
1. [Security](#security)
1. [Network](#network)
1. [Logging](#logging)
1. [Workload Template](#workload)
1. [Multi-Region](#multiregion)

## <a name="introduction"></a>1. Introduction

Managed SCCA Broker Landing Zone is designed to deploy an environment that supports Secure Cloud Computing Architecture (SCCA) standards for the US Department of Defense (DOD).
This configuration guide will detail the required and available configurations needed to deploy a Managed SCCA LZ on Oracle Cloud Infrastructure which is a requirement for DOD customers in the OC3 realm.

## <a name="prerequisites"></a>2. Prerequisites

This Landing Zone (LZ) is designed to be deployed to a single tenancy owned by the individual Mission Owner and/or multiple tenancies supported by a Broker and may require additional coordination between the parties.  The user deploying Managed SCCA LZ must be a member of the Administrators group for the tenancy. The tenancy must have the required Resource Limits and have the Logging Analytics feature turned on. Detailed information on these prerequisites, how to check that your tenancy meets these requirements, and how to enable the necessary features can be found in the [Prerequisites Document](PREREQUISITES.md).

## <a name="configuration"></a>3. Minimum Required Configuration

Deployment of Managed SCCA LZ is controlled by several Terraform [input variables](VARIABLES.md), however most of these have sensible default values. Here are the minimum required configurations to deploy a Landing Zone:

### Basic Terraform Connection Information

This is the basic information Terraform needs to connect to OCI.

* [region](VARIABLES.md#input_region) - OCI Region where Managed SCCA LZ will be deployed.
* [secondary_region](VARIABLES.md#input_secondary_region) - Secondary region used for some Data Redundancy features.
* [tenancy_ocid](VARIABLES.md#input_tenancy_ocid) - ID of tenancy Managed SCCA LZ will be deployed to.
* [current_user_ocid](VARIABLES.md#input_current_user_ocid) - ID of user deploying Managed SCCA LZ.
* [api_fingerprint](VARIABLES.md#input_api_fingerprint) - Fingerprint string for user's API Key.
* [api_private_key_path](VARIABLES.md#input_api_private_key_path) - Path to user's private API key file.

### Other Needed Configurations

* [resource_label](VARIABLES.md#input_resource_label) - Some resources, such as policies and Cloud Guard configurations, need to be deployed globally to the tenancy. This is a short (3-4 char) string appended to resource names to distinguish them in case more than one Managed SCCA LZ is deployed. This should be unique per tenancy.
* [bastion_client_cidr_block_allow_list](VARIABLES.md#input_bastion_client_cidr_block_allow_list) - A list of strings, describing CIDR blocks allowed to connect to the Bastion deployed in the sample Workload network.
* [home_region_deployment](VARIABLES.md#input_home_region_deployment) - A boolean variable to indicate whether the current stack deployment is to the home region or a non-home region.

## <a name="compartment"></a>4. Compartment

For organization and access control purposes, resources created by the Managed SCCA LZ are grouped together logically using OCI's Compartments feature. In a multi-tenancy configuration, the default compartment names include the template name (either _"PARENT"_ or _"CHILD"_) depending on which template was deployed. In a single-tenancy configuration, the template string is removed from the default compartment names. These compartments are organized as follows:

* **Home Compartment**: Most resources created by Managed SCCA LZ are created within this compartment or subcompartments within it. Its name is set by [home_compartment_name](VARIABLES.md#input_home_compartment_name) variable. Default is _"OCI-SCCA-LZ-\<template\>-Home"_. This name must be unique within the tenancy.
* **VDSS Compartment**: All core network resources are placed here. Its name is set by [vdss_compartment_name](VARIABLES.md#input_vdss_compartment_name) variable. Default is _"OCI-SCCA-LZ-\<template\>-VDSS"_. This name must be unique within the Landing Zone.
* **VDMS Compartment**: Security resources are placed here. Its name is set by [vdms_compartment_name](VARIABLES.md#input_vdms_compartment_name) variable. Default is _"OCI-SCCA-LZ-\<template\>-VDMS"_. This name must be unique within the Landing Zone.
* **Logging Compartment**: This is optional. It is controlled by the boolean [enable_logging_compartment](VARIABLES.md#input_enable_logging_compartment) variable. Default is `true`. If enabled, this will contain the Object Storage buckets used for logging. Its name is set by [logging_compartment_name](VARIABLES.md#input_logging_compartment_name) variable. Default is _"OCI-SCCA-LZ-Logging"_. This name must be unique within the Landing Zone.
* **TF-Config Backup Compartment**: This will contain a single Object Storage bucket created in a [secondary region](VARIABLES.md#input_secondary_region), different from the one Managed SCCA LZ was deployed in. Once the Landing Zone has been created through Terraform, you may upload the Terraform state file to this bucket for geographic redundancy of the Landing Zone's configuration. This compartment's name is set by [backup_compartment_name](VARIABLES.md#input_backup_compartment_name) variable. Default is _"OCI-SCCA-LZ-BACKUP-Config"_. This name must be unique within the Landing Zone.

#### Other Compartment Configurations
* [enable_compartment_delete](VARIABLES.md#input_enable_compartment_delete) - Boolean variable. Default is `true`. This is used to control Terraform's cleanup during a `terraform destroy` of Managed SCCA LZ. Terraform ordinarily does not attempt to delete OCI compartments during a destroy operation; this variable can force it to do so. This is mostly an internal detail and most users will not need to change this value.

## <a name="identity"></a>5. Identity

For control over users and user groups, an Identity Domain, that can be federated, is created in the **Home Compartment**. This Identity Domain can support x509. To do so, the user deploying the landing zone will need to add the x509 Identity Provider (IdP) to the Domain and set up federation after Managed SCCA LZ has deployed.

Managed SCCA LZ also creates six User Groups, meant for subcompartment administrators. In a multi-tenancy configuration, the default groupname has "_PARENT_" or "_CHILD_" appended to the name depending on which template is deployed. In a single-tenancy deployment, the default names are as follows:

* SECURITY_ADMIN
* NETWORK_ADMIN
* SYSTEM_ADMIN
* APPLICATION_ADMIN
* AUDIT_ADMIN
* BUSINESS_ADMIN

Managed SCCA LZ deploys policies that will grant administrative privileges to members of each of those groups over resources in their respective compartments.

### Identity Configurations

* [realm_key](VARIABLES.md#input_realm_key) - To function properly, Identity Services must know which OCI realm they are operating in. Valid values are "1" for `OC1 - Commercial` realm, and "3" for `OC3 - Government` realm.

* [identity_domain_license_type](VARIABLES.md#input_identity_domain_license_type) - Managed SCCA LZ identity domain is deployed with one identity domain type; each domain type is associated with a different set of features and object limits. The default value in the Landing Zone is "premium".

* [enable_domain_replication](VARIABLES.md#input_enable_domain_replication) - Replication is enabled for the Default identity domain to paired regions to which the tenant is subscribed. Additional identity domains do not replicate to other regions unless specifically enabled. This boolean variable can be used to enable replication of the additional (secondary) identity domain created in the Landing Zone to the replica region.

## <a name="monitoring"></a>6. Monitoring

For monitoring of resources deployed within the Landing Zone, it deploys Alarms, enables Announcements, sets up Notifications via email, and pipes logging and event information into the Logging Analytics service for more in-depth analysis and visualization.

### Alarms

Alarms are triggers that can alert on various conditions. This can be resource usage (such as network bandwidth or compute instance memory usage going over a specified threshold), or security events (such as a bastion session login).

Alarms can have two different priorities, `CRITICAL` for significant events that may need action, and `WARNING` for less urgent, informational events.

Managed SCCA LZ deploys over 40 different best-practice alarms to detect important situations.

Managed SCCA LZ divides alarms into groups: VDSS alarms for networking-related events, VDMS alarms for more general resource and security-related events, and Workload alarms for things related to the initial workload (see Workload section for details on workload configuration).

Alarms are initially deployed in a `disabled` state and can be enabled as desired. Different groups of alarms can be enabled on deploy by configuration variables. These are boolean variables, which all default to `false`. When set to `true` the corresponding group of alarms will be enabled on deployment of Managed SCCA LZ:

* [enable_vdss_warning_alarm](VARIABLES.md#input_enable_vdss_warning_alarm)
* [enable_vdss_critical_alarm](VARIABLES.md#input_enable_vdss_critical_alarm)
* [enable_vdms_warning_alarm](VARIABLES.md#input_enable_vdms_warning_alarm)
* [enable_vdms_critical_alarm](VARIABLES.md#input_enable_vdms_critical_alarm)

### Announcements

Announcements are events sent by Oracle concerning things such as planned maintenance and outages that may impact the operation of OCI services.

### Notifications

Notifications allow events, such as Alarm triggers or Announcements, to be sent to a list of recipients via email. Sets of events are directed to a topic and a list of email addresses (called endpoints) is subscribed to that topic. Each email address will receive an email with a link to activate its subscription.

Managed SCCA LZ directs Alarm trigger notifications to a topic named after the group and priority of the alarm (so `CRITICAL` alarm triggers in the VDSS group are sent to the `vdss_critical_topic`). Announcements are sent to `vdms_critical_topic`.

Email addresses for each topic are configured via the variables listed below. Each takes a list of strings (email addresses). The default for all of these is an empty list:

* [vdms_critical_topic_endpoints](VARIABLES.md#input_vdms_critical_topic_endpoints)
* [vdms_warning_topic_endpoints](VARIABLES.md#input_vdms_warning_topic_endpoints)
* [vdss_critical_topic_endpoints](VARIABLES.md#input_vdss_critical_topic_endpoints)
* [vdss_warning_topic_endpoints](VARIABLES.md#input_vdss_warning_topic_endpoints)

### Logging Analytics

Managed SCCA LZ copies all logs and auditing events to the Logging Analytics service for analysis and visualization. Once the Landing Zone is deployed, users can visit the [Logging Analytics home page](https://cloud.oracle.com/loganalytics/home) to set up dashboards and view data.

See [Logging Analytics](PREREQUISITES.md#logging-analytics) for prerequisites. If the tenancy has not yet been on-boarded to Logging Analytics, set the following variable to `true`, otherwise leave as `false`:

* [onboard_log_analytics](VARIABLES.md#input_onboard_log_analytics)

## <a name="security"></a>7. Security

To provide for a secure environment, Managed SCCA LZ deploys several Oracle security services, such as Cloud Guard to monitor for insecure cloud resource deployments, Vulnerability Scanning Service to scan compute instances for open ports and known vulnerabilities, and OS Management Service to manage updates and patches. 

To provide secure storage and key management, Managed SCCA LZ deploys a Vault and a creates a Master Encryption Key stored in that vault, which can be used to encrypt data in Object Storage. 

For secure storage and future analysis of logging data, Managed SCCA LZ directs all logging data, including general log data, service events, and audit logs, to secure storage. This can be secure object storage buckets created by Managed SCCA LZ, and encrypted with the Master Encryption Key stored in the central Vault, or it can be buckets in a remote tenancy for third party analysis. 

For geographic redundancy of Landing Zone configuration data, Managed SCCA LZ deploys an Object Storage bucket in a secondary region. 

For secure access to workload resources, Managed SCCA LZ deploys a Bastion in the Workload network. 

### Security Services

Managed SCCA LZ deploys configurations for multiple security services. VSS (Vulnerability Scanning Service) will scan compute instances deployed in the Landing Zone (i.e. as part of workloads) for open ports and known security vulnerabilities. OSMS (OS Management Service) works with operating systems on deployed compute instances (such as Oracle Autonomous Linux) to manage patches and updates to ensure a secure environment. These two services work together with the most comprehensive security service, which is Cloud Guard. Cloud Guard can monitor for a multitude of security conditions. Managed SCCA LZ configures Cloud Guard with several Oracle-managed security recipes for up-to-date best practice security monitoring. Cloud Guard is configured to monitor the resources deployed in the Landing Zone Home compartment and compartments within that. To enable Cloud Guard service, set the [enable_cloud_guard](VARIABLES.md#input_enable_cloud_guard) boolean value to `true`. The default value of the variable is `false`.

For further details on Cloud Guard, see the [Cloud Guard documentation](https://docs.oracle.com/en-us/iaas/cloud-guard/home.htm).

### Vault and Key Management

For secure key management, a central vault is created within Managed SCCA LZ for secure storage of cryptographic keys. A user-manageable Master Encryption Key is also created, stored in the vault, and is usable for encryption of data in Object Storage. This vault and key are found in the VDMS compartment of the Landing Zone. 

#### Vault and Key Configuration
* [central_vault_name](VARIABLES.md#input_central_vault_name) - The name of the central vault (string). Default (multi-tenancy): _"OCI-SCCA-LZ-\<template\>-Central-Vault"_, where \<template\> is either "_PARENT_" or "_CHILD_", depending on which template was deployed. For single-tenancy deployments, the template string is removed from the default name. 
* [central_vault_type](VARIABLES.md#input_central_vault_type) - Type of central vault. There are two available options: `DEFAULT` and `VIRTUAL_PRIVATE`. Default value is `DEFAULT`. See [OCI Vault documentation](https://docs.oracle.com/en-us/iaas/Content/KeyManagement/Concepts/keyoverview.htm) to determine which vault type meets your security needs. 
* [enable_vault_replica](VARIABLES.md#input_enable_vault_replica) - Enable replication of central vault to another region. (Boolean) Default is `false`. This feature can only be enabled if the **central_vault_type** is `VIRTUAL_PRIVATE`. 
* [master_encryption_key_name](VARIABLES.md#input_master_encryption_key_name) - The name of Master Encryption Key (string). Default (single-tenancy): _"OCI-SCCA-LZ-MSK"_. Default (multi-tenancy): _"OCI-SCCA-LZ-\<template\>-MSK"_, either "_PARENT_" or "_CHILD_", depending on which template was deployed.


### Bastion

To allow secure access to compute resources in the sample Workload network, Bastion is deployed to that network. 

#### Bastion Configuration
* [bastion_client_cidr_block_allow_list](VARIABLES.md#input_bastion_client_cidr_block_allow_list) - A list of strings, describing CIDR blocks that are allowed to connect to the Bastion deployed in the sample Workload network. 
* [enable_bastion](VARIABLES.md#input_enable_bastion) - Boolean. Set to `true` to enable the bastion service. Default is `false`.

## <a name="network"></a>8. Network

For security and flexibility purposes, Managed SCCA LZ configures the deployed networks in a "Hub and Spoke" model in parent and child tenancies. This model consists of multiple, distinct Virtual Cloud Networks (VCNs) connected together. 
There is a "Hub" network (named "OCI-SCCA-<CHILD\|PARENT\>-LZ-VDSS-VCN-*region*") containing a Dynamic Routing Gateway (DRG), which acts as the central router for all traffic, and a Network Firewall. Connected off of the DRG are multiple "Spoke" networks for workloads, management resources, etc.  All traffic into or out of any of the "Spoke" networks is routed through the Network Firewall for security purposes. This includes traffic to and from other Oracle Cloud services, such as Object Storage. 
No gateways to the public Internet are provided, as it is assumed an interconnect (such as FastConnect) to a local, on-premises network will be used. Such interconnects will be connected to the DRG on the "Hub" network. 

#### Inter-Tenancy Communication

For Inter-Tenancy VCN peering, we are using the Remote Procedure Connection over the two Dynamic Route Gateway(DRG) of Parent and Child Tenancies.To establish connections between two tenancies, one tenancy is designated as the REQUESTOR, and the other tenancy is designated as the ACCEPTOR. [More Information on RPC](https://www.ateam-oracle.com/post/inter-tenancy-vcn-peering-using-remote-peering-connection)

#### VDSS (Hub) Network:
This is the hub of the network architecture. It connects core network infrastructure for the Managed SCCA LZ networks. 

*  This network is named "OCI-SCCA-<CHILD\|PARENT\>-LZ-VDSS-VCN-*region*".
*  VDSS VCN is created inside the VDSS Compartment "SCCA_<PARENT\|CHILD\>_VDSS_CMP". 
*  It is connected to the DRG, which acts as the core router for all network traffic in the Landing Zone, and a Service Gateway, which allows access (via the Network Firewall) for Oracle Cloud services, such as Object Storage. 
*  It contains two subnets. On the first (named "<PARENT\|CHILD\>-VDSS-LB-SUBNET" ) is the Load Balancer subnet, and the second (named  "<PARENT\|CHILD\>-VDSS-FW-SUBNET") is the Network Firewall subnet. 
*  Connected to the Load Balancer subnet is a Load Balancer with Web Application Firewall and Web Application Accelerator features enabled. This can be used as a central reverse-proxy for workload applications, and for management or security applications. 
*  Connected to the Firewall subnet is the Network Firewall. All traffic to and from any spoke network, or the Oracle Service gateway will pass through this firewall. By default, the firewall will reject all traffic. It's policies should be adjusted as needed to allow secure access for deployed applications. 

#### VDSS Network Configuration:
*  <PARENT\|CHILD\>-VDSS-LB-SUBNET - The CIDR block for VDSS Load Balancer Subnet.
*  <PARENT\|CHILD\>-VDSS-FW-SUBNET - The CIDR block for VDSS Network Firewall Subnet.

#### VDMS (Security and Management) Network:
This is a "Spoke" network for any Management (Security, Monitoring, etc.) applications that may be deployed. 
*  This network is named "OCI-SCCA-LZ-VDMS-VCN-*region*".
*  VDSS VCN is created inside the VDSS Compartment "SCCA_<PARENT\|CHILD\>_VDSS_CMP". 
*  Like all "Spoke" networks, the intra and inter communication happen via DRG.
*  It contains one subnet, named <PARENT\|CHILD\>-VDMS-LB-SUBNET.
*  Connected to that subnet is a Load Balancer with WAF enabled, for use by any management applications. 

#### VDMS Network Configuration:
* <PARENT\|CHILD\>-VDMS-LB-SUBNET - The CIDR block for VDMS Load Balancer Subnet.

## <a name="logging"></a>9. Logging

Managed SCCA LZ sets up secure storage of all log data generated by resources and services in the Landing Zone. There are two different strategies available; Local and Remote logging. These are controlled by the [enable_logging_compartment](VARIABLES.md#input_enable_logging_compartment) variable. 

If this variable is set to `true` (which is the default), then the Landing Zone is set up for local logging. A Logging compartment is created, and in that compartment, three Object Storage buckets are created (one each for Audit Logs, Service Events, and default General logging). These are encrypted with the Master Encryption Key stored in the vault. A retention policy is also applied to those buckets to manage data retention, disallowing deletion or modification of data for a configurable time period.

In a multi-tenancy configuration, Managed SCCA LZ in the child tenancy can also be configured to send logs to the parent tenancy with a cross-tenancy service connector. The local logs in the child tenancy will be directed to an existing bucket in the parent tenancy. The namespace of the target object storage bucket, the logging compartment, and details of the tenancy they reside in need to be provided. 

#### Local Logging Configuration
* [retention_policy_duration_amount](VARIABLES.md#input_retention_policy_duration_amount) - The duration for logging bucket retention policy. This should be a number. Default is _"1"_
* [retention_policy_duration_time_unit](VARIABLES.md#input_retention_policy_duration_time_unit) - The time unit for logging bucket retention policy. Default is _"DAYS"_
* [bucket_storage_tier](VARIABLES.md#input_bucket_storage_tier) - The storage tier for logging bucket. (string) Default: _"Archive"_
* [enable_vcn_flow_logs](VARIABLES.md#input_enable_vcn_flow_logs) - Boolean value to enable VCN flog logs. Default is `false`.

#### Cross-Tenancy Remote Logging Configuration (Multi-Tenancy)
This is configured within the child tenancy to send logs from child tenancy to the parent tenancy.

* [parent_tenancy_ocid](VARIABLES.md#input_parent_tenancy_ocid) - The OCID of the parent tenancy. (string) 
* [parent_namespace](VARIABLES.md#input_parent_namespace) - The name of the Object Storage namespace of the parent tenancy where remote log buckets reside. (string) 
* [scca_parent_logging_compartment_ocid](VARIABLES.md#input_scca_parent_logging_compartment_ocid) - the OCID of the target logging compartment in the parent tenancy. (string) 
* [parent_resource_label](VARIABLES.md#input_parent_resource_label) - the resource_label used in the parent landing zone template. (string) 

### Geographically Redundant Terraform State Backup

For data redundancy, an Object Storage bucket is created in a secondary region. This is available for users to upload a copy of the Terraform state file for Managed SCCA LZ to ensure redundant storage of the Landing Zone configuration. 

#### Terraform State Backup Configuration
* [backup_bucket_name](VARIABLES.md#input_backup_bucket_name) - The name for bucket to store Terraform state backups. (string) Default: _"OCI-SCCA-LZ-BACKUP"_ (single-tenancy deployment); _"OCI-SCCA-LZ-\<template\>-BACKUP"_ (depending on which template, (depending on which template, _"PARENT"_ or _"CHILD"_, was deployed in multi-tenancy deployment) 

## <a name="workload"></a>10. Workload Template

Managed SCCA LZ is designed to allow for multiple workloads to be deployed. The Terraform stack for the workload template allows for easy addition of additional workload infrastructures to a Landing Zone deployment.

Managed SCCA LZ only deploys the surrounding infrastructure for a workload, such as compartments, networks, monitoring and notification infrastructure. The actual resources used by the workload itself, such as compute or database instances, would be deployed by users, as those will vary from workload to workload. 

All workloads are automatically covered by the security services and logging infrastructure set up for Managed SCCA LZ as a whole, and do not need additional setup per workload for those services.

The following pieces of infrastructure are created for each workload:

#### General Workload Configuration
* [resource_label](VARIABLES.md#input_resource_label) - A short string (max 5 characters) appended to Workload resource names to help distinguish them.
* [scca_child_home_compartment_ocid](VARIABLES.md#input_scca_child_home_compartment_ocid) - the OCID of home compartment where the workload subcompartment will reside.

### Compartment

* **Workload Compartment**: This is the compartment for the workload. Its name will start with _"OCI-SCCA-LZ-WORKLOAD"_ and have the workload [Resource Label](VARIABLES.md#input_resource_label) appended to it. It is deployed as a subcompartment to the home compartment.

### Identity

The workload template adds workload groups to the Managed SCCA LZ identity domain with a workload _resource_label_ appended to the name.

* WRK_SECURITY_ADMIN_CHILD
* WRK_NETWORK_ADMIN_CHILD
* WRK_SYSTEM_ADMIN_CHILD
* WRK_APPLICATION_ADMIN_CHILD
* WRK_AUDIT_ADMIN_CHILD
* WRK_BUSINESS_ADMIN_CHILD

Managed SCCA LZ deploys policies that grant administrative privileges to members of each of those groups over resources in their respective compartments.

### Workload Monitoring Alarms and Notifications

Each workload receives a small set of monitoring Alarms per workload as well as two notification topics, one for each Alarm priority. As with the rest of Managed SCCA LZ, workload Alarms are deployed in a disabled state unless the appropriate **enable_..._alarm** flag is set to `true`.

#### Workload Alarm and Notification Configurations
* [workload_critical_topic_endpoints](VARIABLES.md#input_workload_critical_topic_endpoints) - The list of email addresses to receive workload_critical alarm triggers. (list of strings). The default is an empty list.
* [workload_warning_topic_endpoints](VARIABLES.md#input_workload_warning_topic_endpoints) - The list of email addresses to receive workload_warming alarm triggers. (list of strings). The default is an empty list
* [enable_workload_warning_alarm](VARIABLES.md#input_enable_workload_warning_alarm) - This enables all workload warning alarms on deployment of Landing Zone. (Boolean) Default `false`
* [enable_workload_critical_alarm](VARIABLES.md#input_enable_workload_critical_alarm) - This enables all workload critical alarms on deployment of Landing Zone. (Boolean) Default `false`

## <a name="multiregion"></a>11. Multi-Region

Managed SCCA LZ can be deployed in a non-home region as long as there has already been a successful Landing Zone deployment in the home region and the non-home region is an OCI designated paired region with the home region.

This deployment can be controlled using the [home_region_deployment](VARIABLES.md#input_home_region_deployment) variable. This variable is set to `true` by default, which deploys all standard Landing Zone compartments and resources in the home region.

If the [home_region_deployment](VARIABLES.md#input_home_region_deployment) variable is set to `false`, then Managed SCCA LZ is configured for a non-home region deployment. This creates all the standard Landing Zone resources previously deployed in the home region, **except** identity resources such as compartments, policies, and domains. This is because identity resources can only be created in the home region.

To deploy to a non-home region using the Terraform CLI, follow steps 1-3 in the [Implementation Guide](IMPLEMENTATION-GUIDE.md) to create a new Landing Zone stack.

In the terraform.tfvars file, set **home_region_deployment** to `false` and set **region** to the current, non-home region you are intending to deploy to. This is often the same region as the [secondary_region](VARIABLES.md#input_secondary_region).

Next, ensure you have access to the OCI Console and login to it. Navigate to the Compartments section by searching "Compartments" in the top search bar. Find the compartment you previously deployed named "OCI-SCCA-LZ-Home" with your resource_label appended to it and click on it.

For each compartment, you must copy its OCID value into its corresponding multi-region compartment OCID variable in the terraform.tfvars file. Follow the remaining steps listed in the [Implementation Guide](IMPLEMENTATION-GUIDE.md).

To deploy to a non-home region using Resource Manager, follow the instructions in the [Implementation Guide](IMPLEMENTATION.md). When the startup wizard prompts for multi-region variables, set **home_region_deployment** to `false` and set **region** to the current, non-home region you are intending to deploy to. This is often the same region as the [secondary_region](VARIABLES.md#input_secondary_region). In addition, copy the compartment OCID values for each compartment into its corresponding configuration variable.

#### Multi-Region Configurations
* [multi_region_home_compartment_ocid](VARIABLES.md#input_multi_region_home_compartment_ocid) - OCID of the home compartment created in home region for multi-region deployment.
* [multi_region_logging_compartment_ocid](VARIABLES.md#input_multi_region_logging_compartment_ocid) - OCID of the logging compartment created in home region for multi-region deployment.
* [multi_region_vdss_compartment_ocid](VARIABLES.md#input_multi_region_vdss_compartment_ocid) - OCID of the VDSS compartment created in home region for multi-region deployment.
* [multi_region_vdms_compartment_ocid](VARIABLES.md#input_multi_region_vdms_compartment_ocid) - OCID of the VDMS compartment created in home region for multi-region deployment.
* [multi_region_workload_compartment_ocid](VARIABLES.md#input_multi_region_workload_compartment_ocid) - OCID of the workload compartment created in home region for multi-region deployment.
