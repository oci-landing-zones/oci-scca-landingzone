# OCI SCCA Landing Zone Release Notes

## v2.0.3 - 2024-12-06

- Update terraform version support for >= 1.5
- Add destroy script and documentation for stack deletion


## v2.0.2 - 2024-10-04

- Updated Parent template network file WAA and WAF API Calls to specific CIS Release 0.6.7 .
- Updated Implementation Guide Default Variables values to match with Both Parent and Child Templates tfvars values.
- Added variables.md file to document all the possible inputs to parent template.
- Added variables.md file to document all the possible inputs to child template.

## v2.0.1 - 2024-09-29
- Refined and Clarified the IMPLEMENTATION-GUIDE and PREREQUISITES Documentation Semantics.
- Removed Stale File From Child-Template.


## v2.0.0 - 2024-09-29
- The initial release of version 2.0.0 of the Managed SCCA Broker Landing Zone Landing Zone is designed to deploy an environment that supports Secure Cloud Computing Architecture (SCCA) standards for the U.S. Department of Defense (DoD) in a OCI multi-tenancy environment. 


- Known Issues
  * 400-InvalidParameter Error in CreateServiceConnector operation:  This can occasionally happen due to logs taking longer than normal to create while setting up the logging infrastructure.  This will correct itself when the logs finish creating. Later Apply jobs in CLI  `terraform apply` should succeed.
  * 429-TooManyRequests Error: A tenancy making a large number of OCI API requests in rapid succession may be throttled by the API.  The solution is to wait some period of time (a few minutes) and retry the terraform operation again.  This is rarely seen on `terraform apply` but may occasionally be seen on `terraform destroy` runs, as the delete operations are much faster than create, and Terraform makes many API calls. 



## License

Copyright (c) 2024 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](./LICENSE.txt) for more details.
