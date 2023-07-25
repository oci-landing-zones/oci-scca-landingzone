
# SCCA Landing Zone User Guide

The SCCA Landing zone is designed to deploy an environment compliant with SCCA standards for Government organizations. 

This configuration guide will detail the required and available configurations needed to deploy an SCCA compliant Landing Zone (LZ) on Oracle Cloud Infrastructure. 

## Prerequisites

This landing zone is designed to be deployed to a tenancy owned by the individual Mission Owner. The user deploying the Landing Zone must be a member of the Administrators group for the tenancy. The tenancy must have the required Resource Limits and have the Logging Analytics feature turned on. Detailed information on these prerequisites, how to check that your tenancy meets them, and enable needed features can be found in the [Implementation Document](Implementation.md).

## What we deploy

This landing zone deploys a structure of Compartments for the following:

* Organization of resources and defining administration boundaries 
* Identity resources such as a federatable Identity Domain and user groups for various types of Admin users 
* A hub-and-spoke style Network architecture with firewall 
* Infrastructure for collection of all logging data from Oracle services 
* Logging Analytics datasources for analysis of that log data 
* Various security monitoring services such as Oracle CloudGuard and Vulnerability Scanning Service 
* Resource monitoring alarms with email notifications 
* A sample Workload infrastructure with network 
* Admin and monitoring features

Additional workload infrastructures can be added and terraform stacks will eventually be available to automate adding such additional workloads. 

## Minimum required configuration

Deployment of the Landing Zone is controlled by several Terraform [input variables](VARIABLES.md), however most of these have sensible default values. Here are the minimum required configurations to deploy a Landing Zone:

### Basic Terraform Connection Information

This is the basic information Terraform needs to connect to OCI. If you deploy the Landing Zone via Oracle Resource Manager (ORM), many of these may be filled in for you. 

* [region](VARIABLES.md#input_region) - OCI Region where Landing Zone will be deployed.
* [secondary_region](VARIABLES.md#input_secondary_region) - Secondary region used for some Data Redundancy features. 
* [tenancy_ocid](VARIABLES.md#input_tenancy_ocid) - ID of tenancy LZ will be deployed to.
* [current_user_ocid](VARIABLES.md#input_current_user_ocid) - ID of user deploying Landing Zone.
* [api_fingerprint](VARIABLES.md#input_api_fingerprint) - Fingerprint string for user's API Key. 
* [api_private_key_path](VARIABLES.md#input_api_private_key_path) - Path to user's private API key file.

### Other needed configurations 

* [mission_owner_key](VARIABLES.md#input_mission_owner_key) - A short string (3-4 char) appended to Workload resource names to help distinguish them.
* [workload_name](VARIABLES.md#input_workload_name) - A name for the sample workload. Each workload in the LZ should have a unique name.
* [resource_label](VARIABLES.md#input_resource_label) - Some resources, such as policies and CloudGuard configurations, need to be deployed globally to the tenancy. This is a short (3-4 char) string appended to resource names to distinguish them in case more than one Landing Zone is deployed. This should be unique per tenancy. 
* [bastion_client_cidr_block_allow_list](VARIABLES.md#input_bastion_client_cidr_block_allow_list) - A list of strings, describing CIDR blocks allowed to connect to the Bastion deployed in the sample Workload network. 

### Deployment

The landing Zone may be deployed via a standard Terraform command line, or Oracle Resource Manager. 
Terraform versions > 1.0.0 are recommended. 

These configurations will be enough to deploy a landing zone with the default configurations. Additional customization is detailed below. 

## SCCA Landing Zone Architecture

![Architecture](</images/SCCA-CA.png> "Architecture")

This architecture diagram illustrates the resources SCCA LZ deployes and the details for most of these resources is listed below. 


## Compartment

For organization and access control purposes, resources created by the Secure Landing Zone are grouped together logically using OCI's Compartments feature. These compartments are organized as follows:
* **Home Compartment**:  Most resources created by the Landing Zone are created within this compartment, or sub-compartments within it. It’s name is set by [home_compartment_name](VARIABLES.md#input_home_compartment_name) variable. Default is _"OCI-SCCA-LZ-Home"_. This name must be unique within the tenancy.
    * **VDSS Compartment**: All core network resources are placed here. It's name is set by [vdss_compartment_name](VARIABLES.md#input_vdss_compartment_name) variable. Default is _"OCI-SCCA-LZ-VDSS"_. This name must be unique within the LZ. 
    * **VDMS Compartment**: Security resources are placed here. It's name is set by [vdms_compartment_name](VARIABLES.md#input_vdms_compartment_name) variable. Default is _"OCI-SCCA-LZ-VDMS"_. This name must be unique within the LZ. 
    * **Workload Compartment**: This is the compartment for the initial workload. It's name will start with _"OCI-SCCA-LZ-"_, and have the [Workload Name](VARIABLES.md#input_workload_name) and [Mission Owner Key](VARIABLES.md#input_mission_owner_key) appended to it. 
    * **Logging Compartment**: This is Optional. It is controlled by the boolean  [enable_logging_compartment](VARIABLES.md#input_enable_logging_compartment) variable, which is set to `true` to enable. The variable defaults to `true`. If logging to a third-party tenancy, this should be disabled. If enabled, this will contain the Object Storage buckets used for logging. If disabled, information on the third-party tenancy and buckets to log to must be provided. See the [Security](#security) section for details on that configuration. It's name is set by [logging_compartment_name](VARIABLES.md#input_logging_compartment_name) variable. Default is _"OCI-SCCA-LZ-Logging"_. This name must be unique within the LZ. 
    * **TF-Config Backup Compartment**: This will contain a single Object Storage bucket created in a [secondary region](VARIABLES.md#input_secondary_region), different from the one the Landing Zone was deployed in. Once the Landing Zone has been created through Terraform, you may upload the Terraform state file to this bucket for geographical redundancy of the Landing Zone's configuration. This compartment's name is set by [backup_compartment_name](VARIABLES.md#input_backup_compartment_name) variable. Default is _"OCI-SCCA-LZ-IAC-TF-Configbackup"_. This name must be unique within the LZ. 

### Other Compartment configurations
* [enable_compartment_delete](VARIABLES.md#input_enable_compartment_delete) - Boolean variable. Default is `true`. This is used to control Terraform's cleanup during a `terraform destroy` of the Landing Zone. Terraform ordinarily does not attempt to delete OCI compartments during a destroy operation, this variable can force it to do so. This is mostly an internal detail and most users will not need to change this value. 

## Identity

For control over users and user groups, a federatable Identity Domain is created in the **VDMS Compartment**. This Domain supports x509. To do so, the user deploying the landing zone will need to add the x509 Identity Provider (IdP) to the Domain and set up federation after the Landing Zone has deployed. 

The Landing Zone also creates 3 User Groups, meant for subcomponent administrators. 

They are:
* VDSSAdmin
* VDMSAdmin 
* WorkloadAdmin

The landing zone deploys policies that will grant administrative privileges to members of each of those groups over resources in their respective compartments. 

### Identity Configurations

* [realm_key](VARIABLES.md#input_realm_key) - To function properly, Identity services must know which OCI Realm they are operating in. Valid values are "1" for `OC1 - Commercial` realm, and "3" for `OC3 - Government` realm. 

## Monitoring

For monitoring of resources deployed within the Landing Zone, it deploys Alarms, enables Announcements, sets up Notifications via email, and pipes logging and event information into the Logging Analytics service for more in-depth analysis and visualization. 

### Alarms

Alarms are triggers that can alert on various conditions. This can be resource usage (such as network bandwidth or compute instance memory usage going over a certain threshold), or security events (such as a bastion session login).

Alarms can have two different priorities, `CRITICAL` for high-importance events, and `WARNING` for more informational events. 

The Landing Zone deploys over 40 different best-practice alarms to detect important situations. 

The Landing Zone divides alarms into groups: VDSS alarms for networking-related events, VDMS alarms for more general resource and security-related events, and Workload alarms for things related to the initial workload (see Workload section for details on workload configuration).

Alarms are initially deployed in a `disabled` state, and can be enabled as desired. Different groups of alarms can be enabled on deploy by configuration variables. These are Boolean variables, and all default to `false`. When set to `true` the corresponding group of alarms will be enabled on deployment of the Landing Zone: 

* [enable_vdss_warning_alarm](VARIABLES.md#input_enable_vdss_warning_alarm)
* [enable_vdss_critical_alarm](VARIABLES.md#input_enable_vdss_critical_alarm)
* [enable_vdms_warning_alarm](VARIABLES.md#input_enable_vdms_warning_alarm)
* [enable_vdms_critical_alarm](VARIABLES.md#input_enable_vdms_critical_alarm)

### Announcements

Announcements are events sent by Oracle concerning things such as planned maintinance and outages that may impact the operation of OCI services.

### Notifications 

Notifications allow events, such as Alarm triggers or Announcements, to be sent to a list of recipients via email. Sets of events are directed to a topic and a list of email address (called endpoints) is subscribed to that topic. Each email address will receive an email with a link to activate their subscription.  

The landing zone directs Alarm trigger notifications to a topic named after the group and priority of the alarm (so `CRITICAL` alarm triggers in the VDSS group are sent to the `vdss_critical_topic`). Announcements are sent to `vdms_critical_topic`.

Email addresses for each topic are configured via the variables listed below. Each takes a list of strings (email addresses). The default for all of these is an empty list:

* [vdms_critical_topic_endpoints](VARIABLES.md#input_vdms_critical_topic_endpoints)
* [vdms_warning_topic_endpoints](VARIABLES.md#input_vdms_warning_topic_endpoints)
* [vdss_critical_topic_endpoints](VARIABLES.md#input_vdss_critical_topic_endpoints)
* [vdss_warning_topic_endpoints](VARIABLES.md#input_vdss_warning_topic_endpoints)

### Logging Analytics

The Landing Zone copies all logs and auditing events to the Logging analytics service for analysis and visualization. Once the Landing Zone is deployed, users can visit the [Logging Analytics home page](https://cloud.oracle.com/loganalytics/home) to set up dashboards and view data. 


## Networking

For security, and flexibility purposes, the Landing Zone configures the deployed networks in a "Hub and Spoke" model. This consists of multiple, distinct Virtual Cloud Networks (VCN's) connected together. 
There is a "Hub" network (named "OCI-SCCA-LZ-VDSS-VCN-*region*") containing a Dynamic Routing Gateway (DRG), which acts as the central router for all traffic, and a Network Firewall. Connected off of the DRG are multiple "Spoke" networks for workloads, management resources, etc.  All traffic into or out of any of the "Spoke" networks is routed through the Network Firewall for security purposes. This includes traffic to and from other Oracle Cloud services, such as Object Storage. 
No gateways to the public Internet are provided, as it is assumed an interconnect (such as FastConnect) to a local, on-premises network will be used. Such interconnects will be connected to the DRG on the "Hub" network. 

### VDSS (Hub) Network:
This is the hub of the network architecture. It connects core network infrastructure for the Landing Zone's networks. 
* This network is named "OCI-SCCA-LZ-VDSS-VCN-*region*".
* It is found in the VDSS Compartment. 
* It is connected to the DRG, which acts as the core router for all network traffic in the Landing Zone, and a Service Gateway, which allows access (via the Network Firewall) for Oracle Cloud services, such as Object Storage. 
* It contains two subnets. On the first (named "OCI-SCCA-LZ-VDSS-SUB1-*region*") is the Load Balancer subnet, and the second (named  "OCI-SCCA-LZ-VDSS-SUB2-*region*") is the Firewall subnet. 
* Connected to the Load Balancer subnet is a Load Balancer with Web Application Firewall and Web Application Accelerator features enabled. This can be used as a central reverse-proxy for workload applications, and for management or security applications. 
* Connected to the Firewall subnet is the Network Firewall. All traffic to and from any spoke network, or the Oracle Service gateway will pass through this firewall. By default, the firewall will reject all traffic. It's policies should be adjusted as needed to allow secure access for deployed applications. 

#### VDSS Network Configuration:
* [vdss_vcn_cidr_block](VARIABLES.md#input_vdss_vcn_cidr_block) - The CIDR block for VDSS Network. (string) Default: _"192.168.0.0/24"_ 
* [lb_subnet_cidr_block](VARIABLES.md#input_lb_subnet_cidr_block) - The CIDR block for VDSS Load Balancer Subnet. This must be within VDSS Network CIDR block. (string) Default: _"192.168.0.128/25"_ 
* [firewall_subnet_cidr_block](VARIABLES.md#input_firewall_subnet_cidr_block) - The CIDR block for VDSS Firewall Subnet. This must be within the VDSS Network CIDR block. (string) Default: _"192.168.0.0/25"_ 

### VDMS (Security and Management) Network:
This is a "Spoke" network for any Management (Security, Monitoring, etc.) applications that may be deployed. 
* This network is named "OCI-SCCA-LZ-VDMS-VCN-*region*".
* It is found in the VDMS compartment. 
* Like all "Spoke" networks, it is only connected to the DRG.
* It contains one subnet, named "OCI-SCCA-LZ-VDMS-SUB-*region*".
* Connected to that subnet is a Load Balancer with WAF enabled, for use by any management applications. 

#### VDMS Network Configuration:
* [vdms_vcn_cidr_block](VARIABLES.md#input_vdms_vcn_cidr_block) - The CIDR block for VDMS Network. (string) Default: _"192.168.1.0/24"_ 
* [vdms_subnet_cidr_block](VARIABLES.md#input_vdms_subnet_cidr_block) - The CIDR block for VDMS Subnet. This must be within VDMS Network CIDR block. (string) Default: _"192.168.1.0/24"_ 

### Workload Networks

See the Workload section for more details.

### VTAPs
The Landing Zone can optionally deploy a VTAP on the VDMS or Workload networks. 
A VTAP is a cloud resource that can clone network traffic from any source on the same VCN, filter it appropriately, then forward it on to applications such network security, packet collectors, or network analytics packages. 
The collected traffic is encapsulated in VXLAN protocol, on UDP port 4789. It is first sent to a Network Load Balancer (NLBs are *not* the same as regular web Load Balancers and are designed to handle lower-level network traffic.) 
If you choose to create a VTAP, the Landing Zone will create an NLB, preconfigured with a listener on UDP port 4789, for you. You can then configure the server(s) for your network security, analytics, or logging applications as backends on this NLB. 

For more information on VTAPs see: https://blogs.oracle.com/cloud-infrastructure/post/announcing-vtap-for-oracle-cloud-infrastructure

#### VTAP Configuration
* [is_vdms_vtap_enabled](VARIABLES.md#input_is_vdms_vtap_enabled) - Deploys VTAP infrastructure on VDMS network if `true`. (Boolean) Default: `false`

## Security

To provide for a secure environment, the Landing Zone deploys several Oracle security services, such as CloudGuard to monitor for insecure cloud resource deployments, Vulnerability Scanning Service to scan compute instances for open ports and known vulnerabilities, and OS Management Service to manage updates and patches. 

To provide secure storage and key management, the landing zone deploys a Vault and a creates a Master Encryption Key stored in that vault, which can be used to encrypt data in Object Storage. 

For secure storage and future analysis of logging data, the landing zone directs all logging data, including general log data, service events, and audit logs, to secure storage. This can be secure object storage buckets created by the landing zone, and encrypted with the Master Encryption Key stored in the central Vault, or it can be buckets in a remote tenancy for third party analysis. 

For Geographic redundancy of Landing Zone configuration data, the Landing Zone deploys an Object Storage bucket in a secondary region. 

For secure access to workload resources, the landing zone deploys a Bastion in the Workload network. 

### Security Services

The Landing Zone deploys configurations for multiple security services. VSS (Vulnerability Scanning Service) will scan compute instances deployed in the landing zone (i.e. as part of workloads) for open ports and known security vulnerabilities.  OSMS (OS Management Service) works with operating systems on deployed compute instances (such as Oracle Autonomous Linux) to manage patches and updates to ensure a secure environment. These two services work together with the most comprehensive security service, which is CloudGuard. CloudGuard can monitor for a multitude of security conditions. The Landing Zone configures CloudGuard with several Oracle-managed security recipes for up-to-date best practice security monitoring. The one user selectable configuration available when deploying CloudGuard is the scope if it's monitoring. By default, CloudGuard is configured to monitor just the resources deployed in the Landing Zone Home compartment, and compartments within that. An option is for CloudGuard to monitor the entire tenancy. This is controlled by the [cloud_guard_target_tenancy](VARIABLES.md#input_cloud_guard_target_tenancy) variable. This is a Boolean variable that defaults to `false`. If it is set to `true`, CloudGuard will be configured to monitor the entire tenancy instead of just the Landing Zone Home compartment. 

For further details on CloudGuard, see the [Cloud Guard documentation](https://docs.oracle.com/en-us/iaas/cloud-guard/home.htm).

### Vault and Key Management

For secure key management, a central Vault is created within the Landing Zone for secure storage of cryptographic keys. A user-manageable Master Encryption Key is also created, stored in the Vault, and is usable for encryption of data in Object Storage. This Vault and Key are found in the VDMS compartment of the landing zone. 

#### Vault and key configuration
* [central_vault_name](VARIABLES.md#input_central_vault_name) - The Name of the central Vault. (string) Default: _"OCI-SCCA-LZ-Central-Vault"_
* [central_vault_type](VARIABLES.md#input_central_vault_type) - Type of central Vault. There are two available options: `DEFAULT` and `VIRTUAL_PRIVATE`. Default value is `DEFAULT`. See [OCI Vault documentation](https://docs.oracle.com/en-us/iaas/Content/KeyManagement/Concepts/keyoverview.htm) to determine which Vault type meets your security needs. 
* [enable_vault_replication](VARIABLES.md#input_enable_vault_replication) - Enable replication of central Vault to another region. (Boolean) Default is `false`. This feature can only be enabled if the **central_vault_type** is `VIRTUAL_PRIVATE`. 
* [master_encryption_key_name](VARIABLES.md#input_master_encryption_key_name) - The Name of Master Encryption Key. (string) Default: _"OCI-SCCA-LZ-MSK"_

### Logging

The Landing Zone sets up secure storage of all log data generated by resources and services in the Landing Zone. There are two different strategies available; Local and Remote logging. These are controlled by the [enable_logging_compartment](VARIABLES.md#input_enable_logging_compartment) variable. 

If this variable is set to `true` (which is the default), then the Landing Zone is set up for Local logging. A Logging Compartment is created, and within that three Object Storage buckets are created (one each for Audit Logs, Service Events, and default General logging). These are encrypted with the Master Encryption Key stored in the Vault. A Retention Policy is also applied to those buckets to manage data retention, disallowing deletion or modification of data for a configurable time period. 

If the **enable_logging_compartment** variable is set to `false`, the Landing Zone is configured for Remote logging. This allows logs to be directed to a third-party tenancy for storage and analysis.  
The logs will be directed to 3 existing buckets in the remote tenancy (again for Audit, Service Event, and Default logs.), and the names and namespace of those buckets, as well as details of the tenancy they reside in will need to be provided. 

#### Local Logging configuration
* [retention_policy_duration_amount](VARIABLES.md#input_retention_policy_duration_amount) - The duration for logging bucket retention policy. This should be a number. Default is _"1"_
* [retention_policy_duration_time_unit](VARIABLES.md#input_retention_policy_duration_time_unit) - The time unit for logging bucket retention policy. Default is "DAYS"
* [bucket_storage_tier](VARIABLES.md#input_bucket_storage_tier) - The storage tier for logging bucket. (string) Default: _"Archive"_

#### Remote Logging configuration
* [remote_tenancy_ocid](VARIABLES.md#input_remote_tenancy_ocid) - The ID of tenancy to log to. (string) 
* [remote_tenancy_name](VARIABLES.md#input_remote_tenancy_name) - The name of Remote tenancy to log to. (string)
* [remote_namespace](VARIABLES.md#input_remote_namespace) - The Object Storage namespace of remote logging buckets. (string) 
* [remote_audit_log_bucket_name](VARIABLES.md#input_remote_audit_log_bucket_name) - The name of remote bucket for Audit logs. (string)
* [remote_default_log_bucket_name](VARIABLES.md#input_remote_default_log_bucket_name) - The name of remote bucket for general Default logs. (string)
* [remote_service_event_bucket_name](VARIABLES.md#input_remote_service_event_bucket_name) - The name of remote bucket for service event logs. (string)

### Geographically Redundant Terraform State Backup

For data redundancy, an Object Storage bucket is created in a secondary region. This is available for users to upload a copy of the Terraform state file for the Landing Zone to ensure redundant storage of the Landing Zone configuration. 

#### Terraform State Backup Configuration
* [backup_bucket_name](VARIABLES.md#input_backup_bucket_name) - The name for bucket to store terraform state backups. (string) Default: _"OCI-SCCA-LZ-IAC-Backup"_ 

### Bastion

To allow secure access to compute resources in the sample Workload network, Bastion is deployed to that network. 

#### Bastion configuration
* [bastion_client_cidr_block_allow_list](VARIABLES.md#input_bastion_client_cidr_block_allow_list) - A list of strings, describing CIDR blocks are allowed to connect to the Bastion deployed in the sample Workload network. 


## Workload

The Landing Zone is designed to allow for multiple workloads to deployed. To start with, a single example set of workload infrastructure is deployed (A Terraform stack to allow easy addition of additional workload infrastructures to a Landing Zone deployment is planned for future release).

The Landing Zone only deploys the surrounding infrastructure for a workload, such as compartments, networks, monitoring and notification infrastructure. The actual resources used by the workload itself, such as compute or database instances, would be deployed by users, as those will vary from workload to workload. 

All workloads are automatically covered by the security services and logging infrastructure set up for the Landing Zone as a whole, and do not need additional setup per workload for those services.

The following pieces of infrastructure are created for each workload:

### General Workload infrastructure
For each workload, a compartment is created and an Admin user group is created that grants its members admin rights to resources in the workload's compartment. 

#### General workload configuration
* [mission_owner_key](VARIABLES.md#input_mission_owner_key) - A short string (3-4 char) appended to Workload resource names to help distinguish them.
* [workload_name](VARIABLES.md#input_workload_name) - A name for the sample workload. Each workload in the LZ should have a unique name.

### Workload Networks

For each workload, two separate networks are created; one for workload application use, and one for Database resources. 

#### Workload Application Network:
This is a "Spoke" network for workload applications. 
* This network is named "OCI-SCCA-LZ-Workload-VCN-**workload_name**-**region**".
* It is found in the Workload ("OCI-SCCA-LZ-**workload_name**") compartment.
* Like all "Spoke" networks, it is only connected to the DRG.
* It contains one subnet, named "OCI-SCCA-LZ-Workload-SUB-**workload_name**-**region**".
* Connected to that subnet is a Load Balancer with WAF enabled, for use by any workload applications.

#### Workload DB Network:
This is a an additional "Spoke" network for workload applications to allow greater isolation for potentially sensitive databases. 
* This network is named "OCI-SCCA-LZ-Workload-DB-VCN-**workload_name**-**region**".
* It is found in the Workload ("OCI-SCCA-LZ-**workload_name**") compartment.
* Like all "Spoke" networks, it is only connected to the DRG.
* It contains one subnet, named "OCI-SCCA-LZ-Workload-DB-SUB-**workload_name**-**region**".

#### Workload Network Configurations
* [workload_vcn_cidr_block](VARIABLES.md#input_workload_vcn_cidr_block) - The CIDR block for Workload application network. (string) Default: _"192.168.2.0/24"_ 
* [workload_subnet_cidr_block](VARIABLES.md#input_workload_subnet_cidr_block) - The CIDR block for Workload application Subnet. the must be within the Workload application network CIDR block. (string) Default: _"192.168.2.0/24"_ 
* [workload_db_vcn_cidr_block](VARIABLES.md#input_workload_db_vcn_cidr_block) - The CIDR block for Workload database network. (string) Default: _"192.168.3.0/24"_ 
* [workload_db_subnet_cidr_block](VARIABLES.md#input_workload_db_subnet_cidr_block) - The CIDR block for Workload database subnet. This must be within the Workload database network CIDR block. (string) Default: _"192.168.3.0/24"_ 
* [is_workload_vtap_enabled](VARIABLES.md#input_is_workload_vtap_enabled) - This deploys VTAP infrastructure on Workload network if `true`. (Boolean) Default: `false`

### Workload Monitoring Alarms and Notifications

Each workload receives a small set of monitoring Alarms per workload as well as two notification topics, one for each Alarm priority. As with the rest of the Landing Zone, workload Alarms are deployed in a disabled state unless the appropriate **enable_..._alarm** flag is set to `true`. 

#### Workload Alarm and Notification configurations
* [workload_critical_topic_endpoints](VARIABLES.md#input_workload_critical_topic_endpoints) - The list of Email addresses to receive workload_critical alarm triggers. (list of strings). The default is an empty list.
* [workload_warning_topic_endpoints](VARIABLES.md#input_workload_warning_topic_endpoints) - The list of Email addresses to receive workload_warming alarm triggers. (list of strings). The default is an empty list
* [enable_workload_warning_alarm](VARIABLES.md#input_enable_workload_warning_alarm) - This enables all workload warning alarms on deployment of LZ. (Boolean) Default `false`
* [enable_workload_critical_alarm](VARIABLES.md#input_enable_workload_critical_alarm) - This enables all workload critical alarms on deployment of LZ. (Boolean) Default `false`

## Terraform Outputs

On successful deployment of the Landing Zone, Terraform will output the following values:
* [bastion\_ocid](VARIABLES.md#output\_bastion\_ocid) - The ID of the Bastion configured in the Workload network. 
* [policy\_to\_add](VARIABLES.md#output\_policy\_to\_add) - If the Remote logging option is selected (see [Logging](#remote-logging-configuration)), this will contain the text of the policy the remote tenant will need to add to their tenancy to allow logging to their buckets from the Landing Zone. 
