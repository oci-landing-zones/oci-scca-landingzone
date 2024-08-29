# CIS OCI Service Connectors Module Example - Vision service connectors

## Introduction

This example shows how to deploy a service connector in OCI that utilizes a managed stream as target. 

It deploys one service connector with the following characteristics:
- Captures logging data from audit logs tenancy wide.
- Captures logging data from other logs than audit logs from two specific compartments.
- Consolidates captured data in an stream, that is managed in the same configuration.

An Identity and Access Management (IAM) policy is deployed in the tenancy home region, granting the Service Connector service rights to push data to the stream.

## Using this example
1. Rename *input.auto.tfvars.template* to *\<project-name\>.auto.tfvars*, where *\<project-name\>* is any name of your choice.

2. Within *\<project-name\>.auto.tfvars*, provide tenancy connectivity information and adjust the *service_connectors_configuration* input variable, by making the appropriate substitutions:
   - Replace *\<REPLACE-BY-COMPARTMENT-OCID\>* placeholders by appropriate compartment OCIDs. 
   
Refer to [Service Connectors module README.md](../../README.md) for overall attributes usage.

3. In this folder, run the typical Terraform workflow:
```
terraform init
terraform plan -out plan.out
terraform apply plan.out
```