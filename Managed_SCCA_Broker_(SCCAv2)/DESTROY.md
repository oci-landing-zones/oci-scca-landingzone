# Guide to Destroy SCCAv2 Landing Zone Using destroy_lz.py


### 1.	Navigate to the destroy_lz.py script here:
      https://github.com/oci-landing-zones/oci-scca-landingzone/blob/master/Mission_Owner_SCCA_(SCCAv1)/destroy_lz.py

### 2.	Download and move this script into your local landing zone directory.
For example: /User/mylandingzone/scca_cis_multi_tenancy/destroy_lz.py

### 3.	Run the destroy_lz.py script
Run this command in the command line (replace the information in the brackets with your compartment's information):

```text
python3 destroy_lz.py -c [YOUR LANDING ZONE COMPARTMENT NAME] -r [YOUR REGION KEY] -l [YOUR RESOURCE LABEL]  --template_name [TEMPLATE NAME (options: CHILD, PARENT, or WORKLOAD]
```
For example: python3 destroy_lz.py -c OCI-SCCA-LZ-CHILD-Home-RIC-miachildtest -r RIC -l miachildtest --template_name CHILD 

Note: You can find your region key in your named compartment.

Successful results of this script:
1. The Central-Vault resource will be moved to the root compartment
1. All other resources will be deleted with only empty compartments remaining

### 4. Modify the terraform state file to omit the identity domains from the state file (terraform destroy will throw an error if this is not run):
Run this command in the command line: 
```text
terraform state rm 'module.scca_identity_domains[0]'
```

### 5.	Run terraform destroy
Run this command in the command line: 
```text
terraform destroy
```
Successful results of this script:

1. All compartments in this deployment will be deleted
1. The Central-Vault resource will be marked for deletion

### 5.	OPTIONAL: Manually schedule vault deletion
Navigate to the cloud console and manually delete your vault resource. It will give options on when to schedule it for deletion.

Note:
1. Terraform destroy will mark the Central-Vault resource to be deleted in 30 days of the current time
1. You can navigate to the resource and manually mark it for deletion earlier (Note: The earliest a vault can be deleted is 7 days)

### 6.	Possible fail cases:
1. If terraform destroy is run before the script, the solution is to manually find all vault resources in the console and set the status to active (cancel the pending deletion). Then start over from step 3 of this guide.
1. If any of the 4 compartments (VDMS, VDSS, Logging, or Config) were manually deleted, the script will not work.
1. If Terraform destroy throws issues with the identity domain, follow this guide from step 4.
