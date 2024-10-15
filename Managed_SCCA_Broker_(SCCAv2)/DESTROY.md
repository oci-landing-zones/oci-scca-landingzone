# Guide to Destroy SCCAv2 Landing Zone Using destroy_lz.py

### Prerequisites:
1. Ensure all four sub-compartments (VDMS, VDSS, Logging, and Config) are present in the parent compartment
2. Do not run terraform destroy before running the destroy_lz.py script
   1. If you have already run terraform destroy, follow these steps:
      1) Navigate to the OCI Cloud Console
      2) Go to Identity & Security > Key Management & Secret Management > Vault
      3) Select your deployment's parent compartment in the drop down menu on the left side
      4) Select the listed vault resource
      5) Click "Cancel Deletion"

### 1.	Navigate to the destroy_lz.py script:
     /Managed_SCCA_Broker_(SCCAv2)/destroy_lz.py
The script is in the same directory as this guide, titled "destroy_lz.py"

### 2.	Download and move this script into your local landing zone directory:
For example: /User/mylandingzone/oci-scca-landingzone/destroy_lz.py

### 3.	Run the destroy_lz.py script:
Run this command in the command line (replace the information in the brackets with your compartment's information):

```text
python3 destroy_lz.py -c [YOUR LANDING ZONE COMPARTMENT NAME] -r [YOUR REGION KEY] -l [YOUR RESOURCE LABEL]  --template_name [TEMPLATE NAME (options: CHILD, PARENT, WORKLOAD, or SINGLE (standalone)]
```
For example: python3 destroy_lz.py -c OCI-SCCA-LZ-CHILD-Home-RIC-examplename -r RIC -l examplename --template_name CHILD

Note: You can find your region key in your named compartment

Successful results of this script:
1. The Central-Vault resource will be moved to the root compartment
2. All resources except for compartments will be deleted

### 4. Modify the terraform state file to omit the identity domains:
Note: Terraform destroy will throw an error if this is not run (see known issues at the bottom)

Run this command in the command line:
```text
terraform state rm 'module.scca_identity_domains[0]'
```

### 5.	Run terraform destroy:
Run this command in the command line:
```text
terraform destroy
```
Successful results of this script:

1. All compartments in this deployment will be deleted
2. The Central-Vault resource will be marked for deletion in 30 days

### 6.	OPTIONAL: Manually schedule vault deletion:
The vault should already be marked for deletion in 30 days; however, 
you can schedule it for an earlier deletion by following these steps:

1) Navigate to the OCI Cloud Console
2) Go to Identity & Security > Key Management & Secret Management > Vault
3) Select your deployment's parent compartment in the drop down menu on the left side
4) Select the listed vault resource
5) Click "Cancel Deletion"
6) Wait for the vault status to become active (it may take a minute)
7) Click on "Delete Vault"
8) Choose the preferred calendar date and time you'd like to delete the vault
9) Click "Delete Vault"
10) Done. Your vault is now scheduled for deletion

###	Known Issues:

1. Running terraform destroy before running the destroy_lz.py script will throw errors because the vault resources were not moved to the root compartment.
```text
Error: During deletion, Terraform expected the resource to reach state(s): DELETED, but the service reported unexpected state: ACTIVE.
│ Delete failed due to the following resource(s): ocid1.vault.oc3.us-gov-ashburn-1.j.......
```
Avoid this error by running the destroy_lz.py script. Follow this guide from step 3.

2. Running terraform destroy before running the destroy_lz.py script will throw errors because the identity domain resources were not deleted.
```text
Error: 412-PreConditionFailed, Cannot perform DELETE_DOMAIN operation on Domain with Status CREATED
│ Suggestion: Please retry or contact support for help with service: Identity Domain
```
Avoid this error by running the destroy_lz.py script and omitting the identity domains from the state file before running terraform destroy. Follow this guide from step 3.

3. Failing to omit the identity domains before running terraform destroy will throw errors.
```text
Error: 403-BadErrorResponse,
│ Suggestion: Please retry or contact support for help with service: Identity Domains Users
   ```
Avoid this error by omitting the identity domains from the state file before running terraform destroy. Follow this guide from step 4.
