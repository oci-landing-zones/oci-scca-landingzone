# Secure Landing Zone Implementation Guide

## Prerequisites
---
## User

The SCCA Landing Zone should be deployed by a user who is a member of the Administrators group for the tenancy.

## Region

The Landing Zone should be deployed to the tenancy's Home Region. 

## Tenancy

### Logging Analytics

The Logging Analytics service should be enabled for the tenancy. 
To check the current status of Logging Analytics for a tenancy, visit the [Logging Analytics home page][1].
There will be a dark grey box at the top of the page. On the right hand side of that box, if Logging analytics has *not* been enabled, there will be a notice that Logging Analytics has not been enabled for the tenancy, and a blue button to enable it.  To enable it, click the blue button, and wait for the 3 onboarding steps to complete.  No further action will be required, as the Landing Zone will configure the needed datasources. 

### Resource Limits

Most of the initial resource limits a new tenancy comes with should be sufficient to deploy 1 SCCA Landing Zone. 
However, there are 2 resource limits that will need to be increased in order to deploy the landing zone: 

1. Monitoring/Alarms:  This limit should be raised to minimum 60 above the current limit (deployment includes 48).
2. Service Connector Hub/Service Connector Count:   This limit should be raised to minimum 5 above the current limit (deployment includes 5).

Example to check the limits in tenancy:

1.	Login to OCI Console and click on the left top corner burger menu. 
2.	Scroll down and click on Governance and Administration 
3.	Under Tenancy Management click on Limits, Quotas and Usage Option 

![ScreenShot1](</images/p1.png> "ScreenShot1")

4.	Under Service option select Service Connector Hub and it will show how much is the limit, used and available.

![ScreenShot2](</images/p2.png> "ScreenShot2")

Also, this link can provide all the details on limits, quotas and usage as to how use, request increase etc.

https://docs.oracle.com/en-us/iaas/Content/General/Concepts/servicelimits.htm

Requests to raise these limits can be done through the [request a service limit increase][2] page. 

[1]: https://cloud.oracle.com/loganalytics/home "Logging Analytics Home page."
[2]: https://cloud.oracle.com/support/create?type=limit "Request a service Limit Increase."

## Needed Values

When launching the Secure Landing Zone, you’ll need to have certain values ready to successfully launch the stack. Here are the most important values to consider before launching:
* The home compartment name, which is the name of the top level organizational compartment.
* Mission Owner key, a short string used to label workload resources.
* Workload name, for the first workload.

CIDR Blocks will also need to be defined for the following Virtual Cloud Networks and subnets:
* VDSS (Hub) network
    * Firewall Subnet
    * LB Subnet
* VDMS network:
    * VDMS subnet
* Workload network
    * Workload subnet
* Workload DB network
    * Workload DB subnet

These network CIDR blocks should be non-overlapping, and should not conflict with any on-premises network you may plan to connect with (e.g. with FastConnect)
The subnet CIDR blocks should be non-overlapping, and within their respective network blocks. 

## SCCA Landing Zone Architecture

![Architecture](</images/SCCA-CA.png> "Architecture")

This architecture diagram illustrates the resources SCCA LZ deployes and desription for the major resources is listed below. Please refer [CONFIGURATION-GUIDE Document](CONFIGURATION-GUIDE.md) for the details of most of the resources.


## Compartment Structure
---
For organization and access control purposes, resources created by the Secure Landing Zone are grouped together logically using OCI's Compartments feature.  These compartments are organized as follows:
* **Home Compartment**: Named according to user selection. All resources created by the Secure Landing Zone are created within this compartment, or sub-compartments within it. 
    * **VDSS Compartment**: All core network resources are placed here.
    * **VDMS Compartment**: Security resources are placed here
    * **Workload Compartment**: This is the compartment for the initial workload. It's name will have the "Workload Name" and "Mission Owner Key" appended to it. 
    * **Logging Compartment**: This is Optional. If logging to a third-party tenancy is enabled, this will not be created. Otherwise, this will contain the Object Storage buckets used for logging. 
    * **TF-Comfig Backup Compartment**: This will contain a single Object Storage bucket created in a *different* region from the one the Landing Zone was deployed in. Once the Landing Zone has been created through Terraform, a script will be available to upload the Terraform state file to this bucket for geographical redundancy of the Landing Zone's configuration. 

## Networking Structure
---
For security, and flexibility purposes, the Secure Landing Zone configures the deployed networks in a "Hub and Spoke" model.  This consists of multiple, separate Virtual Cloud Networks (VCN's) connected together. 
There is a a "Hub" network (named "OCI-SCCA-LZ-VDSS-VCN-*region*") containing a Dynamic Routing Gateway (DRG), which acts as the central router for all traffic, and a Network Firewall. Connected off of the DRG are multiple "Spoke" networks for workloads, management resources, etc.  All traffic into or out of any of the "Spoke" networks is routed through the Network Firewall for security purposes. This includes traffic to and from other Oracle Cloud services, such as Object Storage. 
No gatweays to the public Internet are provided, as it is assumed an interconnect (such as FastConnect) to a local, on-premises network will be used. Such interconnects will be connected to the DRG on the "Hub" network. 

### Configured Virtual Networks

#### VDSS (Hub) Network:
This is the hub of the network architecture. It connects core network infrastructure for the Landing Zone's networks. 
* This network is named "OCI-SCCA-LZ-VDSS-VCN-*region*".
* It is found in the VDSS Compartment. 
* It is connected to the DRG, which acts as the core router for all network traffic in the Landing Zone, and a Service Gateway, which allows access (via the Network Firewall) for Oracle Cloud services, such as Object Storage. 
* It contains two subnets. On the first (named "OCI-SCCA-LZ-VDSS-SUB1-*region*") is the Load Balancer subnet, and the second (named  "OCI-SCCA-LZ-VDSS-SUB2-*region*") is the Firewall subnet. 
* Connected to the Load Balancer subnet is a Load Balancer with Web Application Firewall and Web Application Accelerator features enabled. This can be used as a central reverse-proxy for workload applications, and and management or security applications. 
* Connected to the Firewall subnet is the Network Firewall. All traffic to and from any spoke network, or the Oracle Service gateway will pass through this firewall. By default, the firewall will reject all traffic. It's policies should be adjusted as needed to allow secure access for deployed applications. 

#### VDMS (Security and Management) Network:
This is a "Spoke" network for any Management (Security, Monitoring, etc) applications that may be deployed. 
* This network is named "OCI-SCCA-LZ-VDMS-VCN-*region*".
* It is found in the VDMS compartment. 
* Like all "Spoke" networks, it is only connected to the DRG.
* It contains one subnet, named "OCI-SCCA-LZ-VDMS-SUB-*region*".
* Connected to that subnet is a Load Balancer with WAF enabled, for use by any management applications. 

#### Workload Network:
This is a "Spoke" network for workload applications. 
* This network is named "OCI-SCCA-LZ-Workload-VCN-*workload_name*-*region*".
* It is found in the Workload ("OCI-SCCA-LZ-*workload_name*") compartment.
* Like all "Spoke" networks, it is only connected to the DRG.
* It contains one subnet, named "OCI-SCCA-LZ-Workload-SUB-*workload_name*-*region*".
* Connected to that subnet is a Load Balancer with WAF enabled, for use by any workload applications.

#### Workload DB Network:
This is a an additional "Spoke" network for workload applications to allow greater isolation for potentially sensitive databases. 
* This network is named "OCI-SCCA-LZ-Workload-DB-VCN-*workload_name*-*region*".
* It is found in the Workload ("OCI-SCCA-LZ-*workload_name*") compartment.
* Like all "Spoke" networks, it is only connected to the DRG.
* It contains one subnet, named "OCI-SCCA-LZ-Workload-DB-SUB-*workload_name*-*region*".

### VTAPs
The Landing Zone can optionally deploy a VTAP on the VDMS or Workload networks. 
A VTAP is a cloud resource that can clone network traffic from any source on the same VCN, filter it appropriately, then forward it on to applications such network security, packet collectors, or network analytics packages. 
The collected traffic is encapsulated in VXLAN protocol, on UDP port 4789. It is first sent to a Network Load Balancer (NLBs are *not* the same as regular web Load Balancers, and are designed to handle lower-level network traffic.) 
If you choose to create a VTAP, the Landing Zone will create an NLB, preconfigured with a listener on UDP port 4789, for you. You can then configure the server(s) for your network security, analytics, or logging applications as backends on this NLB. 

For more information on VTAPs see: https://blogs.oracle.com/cloud-infrastructure/post/announcing-vtap-for-oracle-cloud-infrastructure

## Identity Structure

For control over users and user groups, a federatable Identity Domain is created in the **VDMS Compartment**. This Domain supports x509. To do so, the user deploying the landing zone will need to add the x509 Identity Provider (IdP) to the Domain and set up federation after the Landing Zone has deployed. 

The Landing Zone also creates 3 User Groups, meant for subcomponent administrators. 

They are:
* VDSSAdmin
* VDMSAdmin 
* WorkloadAdmin

The landing zone deploys policies that will grant administrative priviledges to members of each of those groups over resources in their respective compartments. 

## Workloads
---
The landing zone will set up one initial workload configuration. In the future, a separate Terraform stack will be available to easily add additional workloads to a deployed Secure Landing Zone.

Note that Workload compartments and networks all contain a user provided *workload_name* suffix in their names. This allows multiple workloads, each with their own separate compartment and networks, to be deployed. 

## Deployment of SCCA-LZ

## How to Deploy
---
The Secure Landing Zone can be launched through Oracle Resource Manager or from the Terraform CLI.

## Terraform CLI
1. Set up API keys to work with your OCI account. Follow the instructions [here](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm).

2. Visit the GitHub page to clone the Terraform template: [REPLACE]()

3. Create a terraform.tfvars file in the root of the repository and populate it with the required variables or override existing variables. 

    Note: An example tfvars file is included for reference. Using this file is the preferred way to run the stack from the CLI, because of the large number of variables to manage. 

4. From the root of the module run the following commands to deploy the terraform.
   * `terraform init`
   * `terraform plan`
   * `terraform apply`

5. Terraform will provision your resources and provide outputs once it completes.

### For more information 
- [Deploy to OCI using Terraform tutorials](https://docs.oracle.com/en-us/iaas/developer-tutorials/tutorials/tf-provider/01-summary.htm).

- [OCI provider documentation](https://registry.terraform.io/providers/oracle/oci/latest/docs).

## Resource Manager

To deploy using Resource Manager, the stack must be imported into the console in one of 2 ways:

Use the `Deploy to Oracle Cloud` button which will take you directly to OCI Resource Manager if you are logged in. You can skip to step 4 if you use this.
Or you can select the select the stack manually through the console starting from step 1.

1. From the console home page, navigate to `Developer Services -> Resource Manager -> Stacks`
2. Select the compartment you want to create the stack in and select `Create stack`.
3. Select `Template -> Select Template -> Architecture -> Scca Landing Zone`.
4. In Working Directory, make sure the root folder is selected.
5. In Name, give the stack a name or accept the default.
6. In Create in Compartment dropdown, select the compartment to store the Stack.
7. In Terraform Version dropdown, make sure to select 1.0.x at least. Lower Terraform versions are not supported.

After completing the Stack Creation Wizard, the subsequent step prompts for variables values. **For reference on the variable values read the [User Guide](USER-GUIDE.md).**

After filling in the required input variables, click next to review the stack values and create the stack.

In the Stack page use the appropriate buttons to plan/apply/destroy your stack.

### For more information
- [Resource Manager Overview](https://docs.oracle.com/en-us/iaas/Content/ResourceManager/Concepts/resourcemanager.htm)

## License

Copyright (c) 2023 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](./LICENSE) for more details.