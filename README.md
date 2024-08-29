# Landing Zones

This repository contains different types of Landing Zones to deploy to the 
Oracle Cloud Infrastructure platform. The landing zones are assembled from 
modules and templates that users can use in their default configuration or 
fork this repo and customize for your own scenarios. 

#  Secure Cloud Computing Architecture (SCCA) Landing Zone
The SCCA Landing zone is designed to deploy an environment that supports 
Secure Cloud Computing Architecture (SCCA) standards for the US 
Department of Defense (DOD).  We have two solutions for DOD customers to 
select from:

## 1. [Mission Owner deployable SCCA Landing Zone, or MO deployable SCCA LZ](https://github.com/oci-landing-zones/oci-scca-landingzone/blob/Repo_Changes/SCCAv1/README.md) 
- Customers self deploying SCCA for themselves with a standardized templetized automation script.
- Customers wanting a simplified in-console experience.
- Customers wanting to download from DoD site and deploy a pre-ATOed automation solution that they can start deploying on Day one of deployment.

## 2. [Managed SCCA Broker Landing Zone, or Managed SCCA LZ](https://github.com/oci-landing-zones/oci-scca-landingzone/blob/Repo_Changes/SCCAv2/README.md) 
- Agencies wanting to deploy the SCCA solution for their Mission Owners'workloads simplifying the components sharing, mitigating Compliance 
verification tasks, and leveraging economies of scale.
- Agencies needing a SCCA broker to managed and operate per specific contract adn conpliance guidelines
- Managed Services Provider (MSP) managing more than one IL4/IL5/IL6 workloads needing SCCA Broker for managing and operating  multiple 
Mission Owners' workloads.
- A system integrator (S.I.) deploying multiple mission owners workload in one or more than one compliance realms.

The table below details the prerequisites, configuration requirements and 
installation steps to deploy the Managed SCCA LZ.  
|#|Document       |Description|
|-|---------------|-----------|
|1.|[Prerequisites Guide](./SCCAv2/official_documentation/PREREQUISITES.md) | Provides details on the tenancy and environment prerequisites for deploying the SCCA LZ |
|2.| [Configuration Guide](./SCCAv2/official_documentation/CONFIGURATION-GUIDE.md) | Provide details on the available configurations for deploying the SCCA LZ|
|3.| [Implementation Guide](./SCCAv2/official_documentation/IMPLEMENTATION-GUIDE.md) | Provides the installation instructions for deploying the Managed SCCA LZ using the Terraform Command Line Interface (CLI)|

## Oracle SCCA Resources

[Oracle Cloud Native SCCA LandingZone](https://www.oracle.com/government/federal/dod-scca/)<br />
[SCCA Admin Guide](https://www.oracle.com/a/ocom/docs/industries/public-sector/oci-scca-architecture-guide.pdf)<br /> 
[MO Deployable SCCA LZ Press Release](https://www.oracle.com/news/announcement/oracle-introduces-first-cloud-native-secure-cloud-computing-architecture-solution-for-the-us-dod-2023-07-31/)
