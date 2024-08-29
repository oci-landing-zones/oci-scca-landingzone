# CIS OCI Service Connector Module Example - External Dependency

## Introduction

This example shows how to deploy Service Connectors resources in OCI using the [Service Connector module](../..). It creates one service connector that reads all tenancy audit logs and non-audit logs from a specific compartment and sends them to an externally managed strem. The example obtains its dependencies from OCI Object Storage objects, specified in *oci_compartments_object_name* and *oci_streams_object_name* variables. 

As this example needs to read from an OCI Object Storage bucket, the following extra permissions are required for the executing user, in addition to the permissions required by the [Service Connector module](../..) itself.

```
allow group <group> to read objectstorage-namespaces in tenancy
allow group <group> to read buckets in compartment <bucket-compartment-name>
allow group <group> to read objects in compartment <bucket-compartment-name> where target.bucket.name = '<bucket-name>'
```

Note: *<bucket-name>* is the bucket specified by *oci_shared_config_bucket* variable. *<bucket-compartment-name>* is *<bucket-name>*'s compartment.

## Using this example
1. Rename *input.auto.tfvars.template* to *\<project-name\>.auto.tfvars*, where *\<project-name\>* is any name of your choice.

2. Within *\<project-name\>.auto.tfvars*, provide tenancy connectivity information and adjust the *alarms_configuration* input variable, by making the appropriate substitutions:
   - Replace *\<REPLACE-BY-COMPARTMENT-REFERENCE\>* placeholders by the appropriate compartment references, expected to be found in the OCI Object Storage object specified by *oci_compartments_object*.
   - Replace *\<REPLACE-BY-STREAM-REFERENCE\>* placeholder by the appropriate stream reference, expected to be found in the OCI Object Storage object specified by *oci_streams_object*.
   - Replace *\<REPLACE-BY-BUCKET-NAME\>* placeholder by the OCI Object Storage bucket for configuration sharing across modules.
   - Replace *\<REPLACE-BY-OBJECT-NAME-FOR-COMPARTMENTS\>* placeholder by the OCI Object Storage object with the compartments references. This object is tipically stored in OCI Object Storage by the module that manages compartments.
   - Replace *\<REPLACE-BY-OBJECT-NAME-FOR-STREAMS\>* placeholder by the OCI Object Storage object with stream references. This object is tipically stored in OCI Object Storage by the module that manages streams.

Refer to [Service Connector module README.md](../../README.md) for overall attributes usage.

3. In this folder, run the typical Terraform workflow:
```
terraform init
terraform plan -out plan.out
terraform apply plan.out
```