# Release Notes

## v0.1.0 - 10/12/2022
- Initial LA release

## v0.1.8 - 03/20/2023
- Updated iam script to support dynamic groups for creation of osms dynamic group.
- Added options to replicate identity-domain and object storage buckets.

## v0.1.9 - 03/28/2023
- Added cleanup script to simplify destroying the stack. Instructions on usage are included in the Prerequisites documentation.
- Added replication to secondary region for identity domain, buckets, and vault. Updated options in ORM schema.
- Fixed OSMS issue moving OSMS into identity domain and updating IAM group script to support dynamic group creation.
- Added Known Issues to Prerequisites documentation and updated variable descriptions.

## v0.1.10 - 04/13/2023
- Added OC2 Realm.

## v1.1.0 - 01/19/2024
- Added support for non-home region SCCA LZ deployment after existing home region SCCA LZ deployment for paired regions. Instructions are included in Configuration Guide.

## v1.2.0 - 02/14/2024
- Added support for workload expansion
- Refactored the identity domain group creation modules
- Removed the Python Dependencies for identity domain group creation


## License

Copyright (c) 2023 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](./license.txt) for more details.