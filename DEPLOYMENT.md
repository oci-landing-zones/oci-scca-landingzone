# Prerequisites for Deploying Landing Zone

SCCA Landing Zone

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

1. Monitoring/Alarms:  This limit should be raised to a minimum of 48. 
2. Service Connector Hub/Service Connector Count:  This limit should be raised to a minimum of 5. 

Requests to raise these limits can be done through the [request a service limit increase][2] page. 

[1]: https://cloud.oracle.com/loganalytics/home "Logging Analytics Home page."
[2]: https://cloud.oracle.com/support/create?type=limit "Request a service Limit Increase."


# How to Deploy

Deploy the SCCA Landing Zone using the OCI Resource Manager or the OCI Terraform provider.

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

1. From the console home page, navigate to `Developer Services -> Resource Manager -> Stacks`.
2. Select the compartment you want to create the stack in and select `Create stack`.
3. Select `Template -> Select Template -> Architecture -> SCCA Landing Zone`.
4. In Working Directory, make sure the root folder is selected.
5. In Name, give the stack a name or accept the default.
6. In Create in Compartment dropdown, select the compartment to store the Stack.
7. In Terraform Version dropdown, make sure to select 1.0.x at least. Lower Terraform versions are not supported.

After completing the Stack Creation Wizard, the subsequent step prompts for variables values. **For reference on the variable values read the [User Guide](USER-GUIDE.md).**

After filling in the required input variables, click next to review the stack values and create the stack.

From the Stack page, use the appropriate buttons to plan/apply/destroy your stack.

### For more information
- [Resource Manager Overview](https://docs.oracle.com/en-us/iaas/Content/ResourceManager/Concepts/resourcemanager.htm)

## License

Copyright (c) 2022,2023 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](./LICENSE) for more details.