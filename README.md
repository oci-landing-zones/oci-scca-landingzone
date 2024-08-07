# OCI SCCA Landing Zone

This repository contains the Landing Zone to deploy to the Oracle Cloud Infrastructure platform that supports the requirements of DISA's SCCA. This landing zone is assembled from modules and templates that users can use in their default configuration or fork this repo and customize for their own use cases.

## Oracle Enterprise Landing Zone Secure Cloud Computing Architecture (SCCA)

The Oracle SCCA Landing Zone deploys a secure architecture that supports DISA SCCA requirements. Users can use the guides below to get started with the SCCA Landing Zone.

- [Implementation Guide](IMPLEMENTATION.md)
- [Configuration Guide](CONFIGURATION-GUIDE.md)

## Deploy Using Oracle Resource Manager
1. Click to deploy the stack

[![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oci-landing-zones/oci-scca-landingzone/archive/refs/heads/master.zip)

    If you aren't already signed in, when prompted, enter the tenancy and user credentials. Review and accept the terms and conditions.


2. Select the region where you want to deploy the stack.
3. For Working directory, select the root folder.
4. Follow the on-screen prompts and instructions to create the stack.
5. After creating the stack, click Terraform Actions, and select Plan.
6. Wait for the job to be completed, and review the plan.
7. To make any changes, return to the Stack Details page, click Edit Stack, and make the required changes. Then, run the Plan action again.
8. If no further changes are necessary, return to the Stack Details page, click Terraform Actions, and select Apply.


## The Team

This repository is developed and supported by the Oracle OCI Landing Zones team.

## How to Contribute

Interested in contributing?  See our contribution [guidelines](CONTRIBUTING.md) for details.

## License

Copyright (c) 2023 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](./LICENSE.txt) for more details.