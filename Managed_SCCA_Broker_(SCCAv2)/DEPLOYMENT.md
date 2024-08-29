# Prerequisites for Deploying Managed SCCA Broker Landing Zone

Prerequistes Guide ([Follow PREREQUISITES Guide](./official_documentation/PREREQUISITES.md))

### Logging Analytics

The Logging Analytics service should be enabled for the tenancy. 
To check the current status of Logging Analytics for a tenancy, visit the [Logging Analytics home page][1].
There will be a dark grey box at the top of the page. On the right hand side of that box, if Logging analytics has *not* been enabled, there will be a notice that Logging Analytics has not been enabled for the tenancy, and a blue button to enable it.  To enable it, click the blue button, and wait for the 3 onboarding steps to complete.  No further action will be required, as the Landing Zone will configure the needed datasources. 

### Resource Limits

Most of the initial resource limits a new tenancy comes with should be sufficient to deploy Managed SCCA LZ, Parent Template, Child Template and Workload Template.
Resource Limit Managed SCCA LZ ([Follow PREREQUISITES Guide Section 6](./official_documentation/PREREQUISITES.md))

# How to Deploy

Deploy Managed SCCA LZ via Terraform CLI ([Follow Implementation Guide](./official_documentation/IMPLEMENTATION-GUIDE.md))

## License

Copyright (c) 2024 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](./LICENSE.txt) for more details.
