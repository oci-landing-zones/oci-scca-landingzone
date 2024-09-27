
# Parent Template

## Table of Conents

1. [Overview](#overview)
1. [Deployment Guide](#deployment-guide)
    - [Baseline Deployment](#baseline-deployment)
        - [Baseline Deployment Variables](#baseline-deployment-variables)
    - [Service Deployment](#service-deployment)
        - [Service Deployment Variables](#service-deployment-variables)
1. [File Structure](#file-structure)
1. [Best Practices](#best-practices)
    

## Overview

This folder contains the main templates required to set up the **Parent SCCA Deployment** in the **Managed SCCA Landing Zone**. It includes the Terraform and configuration files necessary for managing and deploying core infrastructure components at the parent level. The deployment is structured to ensure flexibility and scalability, providing a consistent setup for further child service deployments.

## Deployment Guide

### Baseline Deployment

1. Navigate to the `parent-template/examples` folder.
2. Copy the `baseline_terraform.tfvars.template` file to the root of the `parent-template` folder.
3. Rename the file to `baseline_terraform.tfvars`.
4. Customize the `baseline_terraform.tfvars` file with your environment-specific variables. See [Baseline Deployment Variables](#baseline-deployment-variables) for more details about the variables. 
5. Run the following commands from the root of this folder:

    ```bash
    terraform plan -var-file="baseline_terraform.tfvars"
    terraform apply -var-file="baseline_terraform.tfvars"
    ```

6. When prompted, confirm the changes by typing "yes" and pressing Enter.
7. Ensure that the deployment successfully completes.

#### Baseline Deployment Variables

Following variables can be customized to suit the deployment of your baseline parent deployment: 

| Name | Description | Default Value |
|------|-------------|---------------|
| resource_label | Unique label to identify the resources created as part of the Landing Zone | "" |
| enable_domain_replication | Enables the replication of the identity domain | true |
| identity_domain_license_type | Type of license used for the identity domain. | "premium" |
| realm_key | Define what realm you are going to deploy the LZ into. Default is OC3 | "3" |
| home_region_deployment | Deploy the LZ in your home region? | true |
| enable_logging_compartment | Enable the creation of a logging compartment  | true |
| central_vault_type | Use a central vault | "DEFAULT" |
| enable_vault_replica | Use vault replica | false |
| enable_cloud_guard | Enable Cloud Guard. This should only be set to true when your tenancy has not yet enabled Cloud Guard. | true |
| bastion_client_cidr_block_allow_list | List of CIDR ranges that will be granted access to the bastion | ["15.0.0.0/16"] |
| enable_bastion | Enable the bastion service | true |
| vdms_critical_topic_endpoints | List of email address who will receive the VDMS critical topics | [] |
| vdms_warning_topic_endpoints | List of email address who will receive the VDMS warning topics | [] |
| vdss_critical_topic_endpoints | List of email address who will receive the VDSS critical topics | [] |
| vdss_warning_topic_endpoints | List of email address who will receive the VDSS warning topics | [] |
| enable_vdss_warning_alarm | Enable the VDSS warning alarm | true |
| enable_vdss_critical_alarm | Enable the VDSS critical alarms | true |
| enable_vdms_warning_alarm | Enable the VDMS warning alarms | true |
| enable_vdms_critical_alarm | Enable the VDMS critical alarms | true |
| onboard_log_analytics | Onboard on the log analytics service | false |
| vdss_vcn_cidr_block | CIDR block used for the VDSS VCN | "15.1.0.0/16" |
| lb_subnet_cidr_block | Load balancer subnet CIDR range | "15.1.1.0/24" |
| lb_subnet_name | Name used for the Load Balancer subnet | "OCI-SCCA-PARENT-LZ-VDSS-LB-SUBNET" |
| lb_dns_label | Name used for the DNS label for the Load Balancer | "lbsubnet" |
| firewall_subnet_name | Subnet name for the firewall | "OCI-SCCA-PARENT-LZ-VDSS-FW-SUBNET" |
| firewall_subnet_cidr_block | CIDR block used for the firewall | "15.1.2.0/24" |
| firewall_dns_label | DNS label used for the firewall | "firewallsubnet" |
| vdms_vcn_cidr_block | CIDR block used for the VDMS VCN | "16.1.0.0/16" |
| vdms_subnet_cidr_block | CIDR block used for the VDMS subnet | "16.1.1.0/24" |
| vdms_dns_label | DNS label used for the VDMS DNS | "vdmssubnet" |
| vdms_subnet_name | Subnet name for the VDMS subnet | "OCI-SCCA-PARENT-LZ-VDMS-SUBNET" |
| enable_vtap | Enable VTAP | true |
| enable_network_firewall | Enable the network firewall | true |
| enable_waf | Enable the Web Application Firewall | true |
| activate_service_connectors | Activate the service connector | true |
| enable_service_deployment | Enable the service deployment | false |
| enable_vcn_flow_logs | Enable the collection of the VCN flow logs | false |

### Service Deployment

For each child tenancy you want to connect to the parent hub, the following deployment is required into the parent tenancy: 

1. Navigate to the `parent-template/examples` folder.
2. Copy the `service_terraform.tfvars.template` file to the root of the `parent-template` folder or reuse the `baseline_terraform.tfvars` from the baseline deployment as this file will have most of the variables with their correct values. 
If you start with the copy of the `service_terraform.tfvars.template`, make sure that you copy the values from the `baseline_terraform.tfvars` as otherwise, terraform will overwrite or change the initial deployment! 
3. Rename the file to `service_terraform.tfvars`.
4. Customize the `service_terraform.tfvars` file with your environment-specific variables.
5. Run the following commands from the root of this folder:

    ```bash
    terraform plan -var-file="service_terraform.tfvars"
    terraform apply -var-file="service_terraform.tfvars"
    ```

6. When prompted, confirm the changes by typing "yes" and pressing Enter.
7. Ensure that the deployment successfully completes.

#### Service Deployment Variables

 ⚠️ **Warning:** it is important to understand that the values you provide for the variables are the same as the ones used in the baseline deployment. The best practice is to reuse the `baseline_terraform.tfvars` and rename it to `service_terraform.tfvars`. This will reduce the risk of providing different values in the service deployment.

 In addition to the variables from the [Baseline Deployment](#baseline-deployment-variables), following variables are unique to the service deployment and are required for a correct deployment: 

| Name | Description | Default Value |
|------|-------------|---------------|
| enable_service_deployment | Enable the service deployment | true |
| enable_vcn_flow_logs | Enable the collection of the VCN flow logs | true |
| nfw_ip_ocid | OCID for the Network Firewall IP created in the **baseline deployment** | "" |
| child_tenancy_ocid | Child tenancy OCID that you want to connect to the Hub in this parent tenancy | "" |
| child_admin_group_ocid | Child admin group OCID | "" |
| child_vdss_vcn_cidr | VDSS VCN CIDR block from the child tenancy that needs to connect to this hub parent | "" |
| child_vdms_vcn_cidr | VDMS VCN CIDR block from the child tenancy that needs to connect to this hub parent | "" |



## File Structure

- **examples/**: Contains template files and example configuration setups.
    - **baseline_terraform.tfvars.template**: The template file used to define environment-specific variables for the baseline deployment
    - **service_terraform.tfvars.template**: The template file used to define environment-specific variables for the service deployment
- **modules/**: Provides reusable Terraform modules that the parent template depends on.

## Best Practices

- Always run `terraform plan` before `terraform apply` to review the changes that will be made to the infrastructure.
- Customize the `service_terraform.tfvars` carefully, ensuring no critical parameters are omitted.
- Regularly back up your `terraform.tfstate` files to maintain state consistency.
- Reuse the `baseline_terraform.tfvars` file when creating the `service_terraform.tfvars` file in order to reduce the risk of changing values across baseline and service deployment. 
