# Guide to Destroy SCCAv2 Landing Zone Using destroy_lz.py

### Prerequisites:
1. Ensure all four sub-compartments (VDMS,VDSS, Logging, and Config) are present in the parent compartment
2. Do not run terraform destroy before running the destroy_lz.py script
   1. If you have already run terraform destroy, navigate to the vault resource in the cloud console and manually set the status to "active"

### 1.	Navigate to the destroy_lz.py script:
     /Managed_SCCA_Broker_(SCCAv2)/destroy_lz.py
The script is in the same directory as this guide, titled "destroy_lz.py"

### 2.	Download and move this script into your local landing zone directory:
For example: /User/mylandingzone/scca_cis_multi_tenancy/destroy_lz.py

### 3.	Run the destroy_lz.py script:
Run this command in the command line (replace the information in the brackets with your compartment's information):

```text
python3 destroy_lz.py -c [YOUR LANDING ZONE COMPARTMENT NAME] -r [YOUR REGION KEY] -l [YOUR RESOURCE LABEL]  --template_name [TEMPLATE NAME (options: CHILD, PARENT, or WORKLOAD]
```
For example: python3 destroy_lz.py -c OCI-SCCA-LZ-CHILD-Home-RIC-miachildtest -r RIC -l miachildtest --template_name CHILD 

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
Navigate to the cloud console and manually delete your vault resource. It will give options on when to schedule it for deletion.

Note:
1. Terraform destroy will mark the Central-Vault resource to be deleted in 30 days of the current time
2. You can navigate to the resource and manually mark it for deletion earlier (Note: The earliest a vault can be deleted is 7 days)

###	Known Issues:

1. Running terraform destroy before running the destroy_lz.py script will throw errors because the vault resources were not moved to the root compartment.
```text
Error: During deletion, Terraform expected the resource to reach state(s): DELETED, but the service reported unexpected state: ACTIVE.
│ Delete failed due to the following resource(s): ocid1.vault.oc3.us-gov-ashburn-1.j.......   <-(this is the vault ocid)
```
Avoid this error by running the destroy_lz.py script. Follow this guid from step 3. 

2. Running terraform destroy before running the destroy_lz.py script will throw errors because the identity domain resources were not deleted.
```text
Error: 412-PreConditionFailed, Cannot perform DELETE_DOMAIN operation on Domain with Status CREATED
│ Suggestion: Please retry or contact support for help with service: Identity Domain
```
Avoid this error by running the destroy_lz.py script and omitting the identity domains from the state file before running terraform destroy. Follow this guide from step 3.

3. Failing to omit the identity users before running terraform destroy will throw errors. 
```text
Error: 403-BadErrorResponse,
│ Suggestion: Please retry or contact support for help with service: Identity Domains Users
   ```
Avoid this error by omitting the identity domains from the state file before running terraform destroy. Follow this guide from step 4.