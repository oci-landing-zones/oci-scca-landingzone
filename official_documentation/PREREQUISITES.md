# OCI Managed SCCA Broker Landing Zone Deployment Prerequisites

## Table of Contents

1. [Introduction](#introduction)
1. [Prerequisites](#prerequisites)
1. [Tenancy and Region](#tenancy_region)
1. [User](#user)
1. [Logging Analytics](#logging_analytics)
1. [Resource Limits](#resource_limits)
1. [Deleting the Stack](#deleting_stack)
1. [Known Issues](#known_issues)
1. [License](#license)

## <a name="introduction"></a>1. Introduction

This document describes the prerequisites required to deploy Managed SCCA Broker Landing Zone on Oracle Cloud Infrastructure (OCI).

## <a name="prerequisites"></a>2. Prerequisites

To deploy the Managed SCCA LZ from the Terraform CLI you will need the following prerequisites.
- [Use Terrafom Version less than 1.3](https://releases.hashicorp.com/terraform/1.2.9/)
- [OCI Terraform provider](https://registry.terraform.io/providers/oracle/oci/latest/docs) v5.16.0 or later
- [Oracle Cloud Infrastructure CLI](https://github.com/oracle/oci-cli)

## <a name="tenancy_region"></a>3. Tenancy and Region

When deploying Managed SCCA LZ, resources are created in the tenancy's Home Region and Secondary region.
To deploy Managed SCCA LZ the following tenancy and region requirements must be completed:
1. Provision a tenancy
A tenancy needs to have been provisioned to hold all the cloud resources.
The tenancy is where users can create, organize and administer OCI cloud resources.
2. Subscribe to a secondary region

Once the tenancy has been provisioned in a given home region, the tenancy must also be subscribed to a designated secondary region.
Subscribing to a secondary region can be done by Administrators mentioned in the [User section](##User)

For details on how to subscribe to a secondary region see: [Subscribing to an Infrastructure Region]( https://docs.oracle.com/en-us/iaas/Content/Identity/regions/To_subscribe_to_an_infrastructure_region.htm)

## <a name="user"></a>4. User

Managed SCCA LZ should be deployed by a user who is a member of the Administrators group for the tenancy.
This user needs to have an API key entry defined as described [here](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm).
Once the user and API Key are defined in the oci-cli configuration file, the ~/.oci/config default profile should resemble the following example.

```text
[DEFAULT]
user=ocid1.xxxxxx.xxxxxx.xxxxxx.....  #USER OCID
fingerprint=xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx #USER API KEY FINGERPRINT
tenancy=ocid1.xxxxxx.xxxxxx.xxxxxx..... #TENANCY OCID
region=us-phoenix-1 #REGION
key_file=<path to your private keyfile> # PRIVATE KEY ABSOLUTE PATH
secondary_region     = "" # SECONDARY REGION
```

## <a name="logging_analytics"></a>5. Logging Analytics

OCI Logging Analytics service is used by Managed SCCA LZ to aggregate logs to provide various views and dashboards for audit log analysis and insights.
The Logging Analytics service should be enabled for the tenancy.
If it is not already enabled, see: [Oracle Cloud Infrastructure Logging Analytics Quick Start Guide](https://docs.oracle.com/en/cloud/paas/logging-analytics/logqs/)

## <a name="resource_limits"></a>6. Resource Limits (must be done before deployment)

Most of the initial resource limits a new tenancy comes with should be sufficient to deploy Managed SCCA LZ, Parent Template, Child Template and Workload Template.
However, some resource limits may need to be increased in order to deploy Managed SCCA LZ.
Below is a table listing the Terraform OCI resource names and numbers deployed, please check the resources and limits and ensure your tenancy has sufficient limits before deploying Managed SCCA LZ:

### Managed SCCA LZ Parent Template

#### Parent Baseline and Service Template Resources Count

| OCI Definition | OCI Terraform Resource Name | Count |
| :------:       |          :------:           | ----: |
| Creates a new Target | oci_cloud_guard_target| 1|
| Creates a new compartment in the specified compartment | oci_identity_compartment| 6|
| Creates a new alarm in the specified compartment | oci_monitoring_alarm| 23|
| Creates a new bastion |oci_bastion_bastion| 1|
| Creates a topic in the specified compartment | oci_ons_notification_topic| 4|
| Creates a Subscription resource in the specified compartment | oci_ons_subscription| 4|
| Creates a new service connector in the specified compartment | oci_sch_service_connector| 5|
| Creates a new Bucket Object Storage in the specified compartment | oci_objectstorage_bucket| 4|
| Creates a log within the specified log group | oci_logging_log| 9|
| Creates a new security list for the specified VCN | oci_core_default_security_list| 2|
| Creates a new  DRG in the specified compartment | oci_core_drg| 1|
| Attaches the specified DRG to the specified network resource | oci_core_drg_attachment| 2|
| Creates a new Service gateway for the specified VCN | oci_core_service_gateway| 1|
| Creates a new route table for the specified VCN | oci_core_route_table| 7|
| Create Route Rule in DRG Route Table | oci_core_drg_route_table_route_rule| 4|
| Creates a new route distribution for the specified DRG | oci_core_drg_route_distribution| 1|
| Adds one route distribution statement to the specified route distribution | oci_core_drg_route_distribution_statement| 3|
| Creates a new subnet in the specified VCN | oci_core_subnet| 3|
| Creates a new Virtual Cloud Network (VCN) | oci_core_vcn| 2|
| Creates a new Event rule | oci_events_rule| 3|
| Creates a new domain in the tenancy |oci_identity_domain| 1|
| Creates a Domain Replication To Another Region |oci_identity_domain_replication_to_region| 1|
| Creates a new group in the tenancy | oci_identity_domains_group| 6|
| Creates a new policy in the specified compartment | oci_identity_policy| 20|
| Creates a new master encryption key | oci_kms_key| 1|
| Creates a new vault | oci_kms_vault| 1|
| Creates a new log group in the specified compartment | oci_log_analytics_log_analytics_log_group| 2|
| Create a new log group with a unique display name | oci_logging_log_group| 1|
| Starts the provisioning of a new stream | oci_streaming_stream| 2|
| Starts the provisioning of a new stream pool | oci_streaming_stream_pool| 1|
| Creates a new HostScanRecipe | oci_vulnerability_scanning_host_scan_recipe| 1|
| Creates a new HostScanTarget | oci_vulnerability_scanning_host_scan_target| 1|
| Creates a Network Firewall   | oci_network_firewall_network_firewall| 1|
| Creates a Network Firewall Policy  | oci_network_firewall_network_firewall_policy| 1|
| Creates a new WebAppFirewall   | oci_waf_web_app_firewall | 2|
| Creates a new WebAppFirewall Policy  | oci_waf_web_app_firewall_policy| 2|
| Creates a new WebAppAcceleration   | oci_waa_web_app_acceleration | 1|
| Creates a new WebAppAcceleration Policy  | oci_waa_web_app_acceleration_policy| 1|
| Create a load balancer   | oci_load_balancer_load_balancer | 2|
| Attaches the specified route table to the specified subnet | oci_core_route_table_attachment | 3|
| Adds one static route rule to the specified DRG route table | oci_core_drg_route_table| 8|

### Managed SCCA LZ Child Template

#### Child Baseline and Service Template Resources Count

| OCI Definition | OCI Terraform Resource Name | Count |
| :------:       |          :------:           | ----: |
| Creates a new Target | oci_cloud_guard_target| 1|
| Creates a new compartment in the specified compartment | oci_identity_compartment| 6|
| Creates a new alarm in the specified compartment | oci_monitoring_alarm| 23|
| Creates a new bastion |oci_bastion_bastion| 1|
| Creates a topic in the specified compartment | oci_ons_notification_topic| 4|
| Creates a Subscription resource in the specified compartment | oci_ons_subscription| 4|
| Creates a new service connector in the specified compartment | oci_sch_service_connector| 5|
| Creates a new Bucket Object Storage in the specified compartment | oci_objectstorage_bucket| 4|
| Creates a log within the specified log group | oci_logging_log| 9|
| Creates a new security list for the specified VCN | oci_core_default_security_list| 2|
| Creates a new  DRG in the specified compartment | oci_core_drg| 1|
| Attaches the specified DRG to the specified network resource | oci_core_drg_attachment| 2|
| Creates a new Service gateway for the specified VCN | oci_core_service_gateway| 1|
| Creates a new route table for the specified VCN | oci_core_route_table| 7|
| Create Route Rule in DRG Route Table | oci_core_drg_route_table_route_rule| 6|
| Creates a new route distribution for the specified DRG | oci_core_drg_route_distribution| 1|
| Adds one route distribution statement to the specified route distribution | oci_core_drg_route_distribution_statement| 3|
| Creates a new subnet in the specified VCN | oci_core_subnet| 3|
| Creates a new Virtual Cloud Network (VCN) | oci_core_vcn| 2|
| Creates a new Event rule | oci_events_rule| 3|
| Creates a new domain in the tenancy |oci_identity_domain| 1|
| Creates a Domain Replication To Another Region |oci_identity_domain_replication_to_region| 1|
| Creates a new group in the tenancy | oci_identity_domains_group| 6|
| Creates a new policy in the specified compartment | oci_identity_policy| 20|
| Creates a new master encryption key | oci_kms_key| 1|
| Creates a new vault | oci_kms_vault| 1|
| Creates a new log group in the specified compartment | oci_log_analytics_log_analytics_log_group| 2|
| Create a new log group with a unique display name | oci_logging_log_group| 1|
| Starts the provisioning of a new stream | oci_streaming_stream| 2|
| Starts the provisioning of a new stream pool | oci_streaming_stream_pool| 1|
| Creates a new HostScanRecipe | oci_vulnerability_scanning_host_scan_recipe| 1|
| Creates a new HostScanTarget | oci_vulnerability_scanning_host_scan_target| 1|
| Creates a Network Firewall   | oci_network_firewall_network_firewall| 1|
| Creates a Network Firewall Policy  | oci_network_firewall_network_firewall_policy| 1|
| Creates a new WebAppFirewall   | oci_waf_web_app_firewall | 2|
| Creates a new WebAppFirewall Policy  | oci_waf_web_app_firewall_policy| 2|
| Creates a new WebAppAcceleration   | oci_waa_web_app_acceleration | 1|
| Creates a new WebAppAcceleration Policy  | oci_waa_web_app_acceleration_policy| 1|
| Create a load balancer   | oci_load_balancer_load_balancer | 2|
| Attaches the specified route table to the specified subnet | oci_core_route_table_attachment | 3|
| Create a VTAP resource | oci_core_vtap | 1|
| Creates a virtual test access point (VTAP) capture filter in the specified compartment | oci_core_capture_filter | 1|
| Adds a backend set to a network load balancer | oci_network_load_balancer_backend_set | 1|
| Adds a listener to a network load balancer | oci_network_load_balancer_listener| 1|
| Creates a network load balancer | oci_network_load_balancer_network_load_balancer | 1|
| Adds one static route rule to the specified DRG route table | oci_core_drg_route_table| 9|

### Managed SCCA LZ Workload Template

| OCI Definition | OCI Terraform Resource Name | Count |
| :------:       |          :------:           | ----: |
| Creates a new alarm in the specified compartment | oci_monitoring_alarm| 17|
| Creates a new bastion |oci_bastion_bastion| 1|
| Creates a topic in the specified compartment |oci_ons_notification_topic| 2|
| Creates a new route table for the specified VCN |oci_core_default_route_table| 1|
| Creates a new security list for the specified VCN |oci_core_default_security_list| 1|
| Attach a VCN Resource to DRG |oci_core_drg_attachment| 1|
| Attaches the specified route table to the specified subnet |oci_core_route_table_attachment| 3|
| Creates a new Service gateway for the specified VCN  |oci_core_service_gateway| 1|
| Creates a new subnet in the specified VCN |oci_core_subnet| 3|
| Creates a new Virtual Cloud Network (VCN) |oci_core_vcn| 1|
| Creates a Network Firewall |oci_network_firewall_network_firewall| 1|
| Creates a Network Firewall Policy |oci_network_firewall_network_firewall_policy| 1|
| Creates a new group in the tenancy  |oci_identity_domains_group| 6|
| Create a load balancer| 1|

#### Managed SCCA LZ Total Limit For Child Tenancy

Please add up Child Baseline & Service Template and Workload Template Resource.
Please find the information regarding some critical resource limit.

| OCI Definition | OCI Terraform Resource Name | Count |
| :------:       |          :------:           | ----: |
| Creates a new alarm in the specified compartment | oci_monitoring_alarm| 40|
| Creates a new group in the tenancy  |oci_identity_domains_group| 12|
| Creates a Network Firewall |oci_network_firewall_network_firewall| 2|
| Creates a new subnet in the specified VCN |oci_core_subnet| 6|
| Creates a new Virtual Cloud Network (VCN) | oci_core_vcn| 3|

Requests to raise these limits can be done through the [request a service limit increase](https://docs.oracle.com/en-us/iaas/Content/General/Concepts/govinfo.htm#Requesti) page.

## <a name="deleting_stack"></a>7. Deleting the Stack

Certain resources created by the Landing Zone stack can block deletion of the stack.
If testing the stack, it is recommended to not enable these services.

1. Enabling logging can prevent deletion of the stack as it creates **logs in the object storage buckets**. To delete, remove the retention rule then delete the contents of the bucket.

2. The **log analytics log group** can also prevent deletion if there are logs present in the group. Navigate to storage in the log analytics administration page and purge the logs to delete the groups.

3. The **vault** can be marked for deletion but not immediately deleted. This also prevents deletion of the containing compartments.

## <a name="known_issues"></a>8. Known Issues

1. Attempting to onboard your tenancy to log analytics more than once will cause errors.
   ```
   `Error: 409-Conflict, Error on-boarding LogAnalytics for tenant idbktv455emw as it is already on-boarded or in the process of getting on-boarded`
   ```
   Avoid this error by setting the `onboard_log_analytics` variable to `false`.

2. Object storage namespace can sometimes fail in long running deployments because of Terraform provision order.
   ```
    Error: Missing required argument
    with module.backup_bucket.oci_objectstorage_bucket.bucket,
    on modules/bucket/main.tf line 12, in resource "oci_objectstorage_bucket" "bucket"
    12:   namespace      = data.oci_objectstorage_namespace.ns.namespace
    The argument "namespace" is required, but no definition was found.
    ```
    Rerunning the deployment will remove the error.

## <a name="license"></a>9. License

Copyright (c) 2024 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](../LICENSE.txt) for more details.

