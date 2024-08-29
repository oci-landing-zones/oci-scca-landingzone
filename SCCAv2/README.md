# OCI Managed SCCA Broker Landing Zone

Welcome to the [OCI Landing Zones (OLZ) Community](https://github.com/oci-landing-zones)!
OCI Landing Zones simplify onboarding and running on OCI by providing design guidance, best practices, and pre-configured Terraform deployment templates for various architectures and use cases.
These enable customers to easily provision a secure tenancy foundation in the cloud along with all required services, and reliably scale as workloads expand.

This repository contains the Landing Zone to deploy to the Oracle Cloud Infrastructure platform that supports the requirements of DISA's SCCA.
This landing zone is assembled from modules and templates that users can use in their default configuration or fork this repo and customize for their own use cases.

## Oracle Managed Secure Cloud Computing Architecture (SCCA) Broker Landing Zone

The Managed SCCA LZ deploys a secure architecture that supports DISA SCCA requirements.
It supports the same functionality as the Mission Owner deployable SCCA Landing Zone but it also provides multi-tenancy capabilities that supports an operational model where a broker is involved.
Users can use the guides below to get started with the Managed SCCA LZ.
- [Implementation Guide](./official_documentation/IMPLEMENTATION-GUIDE.md)
- [Configuration Guide](./official_documentation/CONFIGURATION-GUIDE.md)

## Deploy Using Oracle Resource Manager

1. Deploy Managed SCCA LZ via Terraform CLI

## The Team

This repository is developed and supported by the Oracle OCI Landing Zones team.

## Contributing

Interested in contributing? See our [contribution guidelines](./CONTRIBUTING.md) for details.

## Security

Please consult the [security guide](./SECURITY.md) for our responsible security vulnerability disclosure process.

## License

Copyright (c) 2024 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](./LICENSE.txt) for more details.
