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

1. Monitoring/Alarms:  This limit should be raised to minimum 60 above the current limit (deployment includes 48). 
2. Service Connector Hub/Service Connector Count:  This limit should be raised to minimum 5 above the current limit (deployment includes 5). 

Requests to raise these limits can be done through the [request a service limit increase][2] page. 

### Deleting the Stack 

Certain resources created by the Landing Zone stack can block deletion of the stack. If testing the stack, it is recommended to not enable these services.

1. Enabling logging can prevent deletion of the stack as it creates **logs in the object storage buckets**. To delete, remove the retention rule then delete the contents of the bucket.

2. The **log analytics log group** can also prevent deletion if there are logs present in the group. Navigate to storage in the log analytics administration page and purge the logs to delete the groups.

3. The **vault** can be marked for deletion but not immediately deleted. This also prevents deletion of the containing compartments.


#### Cleanup Script
A clean up script is provided to assist in cleaning up lingering resources that block terraform destroy.
It can be found at `./destroy_lz.py`

Once the script has been run, service connectors, buckets, and log analytics log groups will be deleted, identity domains deactivated, and vaults moved to the root compartment. 
Terraform destroy will need to be run after.

1. To run the script ensure you have **python3** installed as well as an **oci api key**.
   * install python [here](https://www.python.org/downloads/)
   * set up api keys [here](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm)

2. Verify the profile name(eg. DEFAULT) by checking the config file found at `~/.oci/config` (if the profile you want to use is not DEFAULT use the `--profile` flag to indicate).

3. Install dependencies using the command: 
    ```
    pip install oci tqdm
    ```

4. Run the command (from the templates/enterprise-landing-zone directory)
    ```
    python destroy_lz.py -r IAD -l ARJ2 -c OCI-SCCA-LZ-Home-IAD-ARJ2

    ```

The `-r` flag indicates the 3 letter region key, the `-l` indicates the resource label, such as production and non-production, and the `-c` indicating the home compartment. 

For more information on flag usage for the script use the `--help` flag.
```
python destroy_lz.py  --help
```

### Known Issues
1. Attempting to onboard your tenancy to log analytics more than once will cause errors.
   ```
   `Error: 409-Conflict, Error on-boarding LogAnalytics for tenant idbktv455emw as it is already on-boarded or in the process of getting on-boarded`
   ```
   Avoid this error by setting the `onboard_log_analytics` variable to `false`.

2. Object storage namespace can sometimes fail in long running deployments becuase of terraform provision order. 
   ```
    Error: Missing required argument
    with module.backup_bucket.oci_objectstorage_bucket.bucket,
    on modules/bucket/main.tf line 12, in resource "oci_objectstorage_bucket" "bucket" 
    12:   namespace      = data.oci_objectstorage_namespace.ns.namespace
    The argument "namespace" is required, but no definition was found.
    ```
    Rerunning the deployment will remove the error.

[1]: https://cloud.oracle.com/loganalytics/home "Logging Analytics Home page."
[2]: https://cloud.oracle.com/support/create?type=limit "Request a service Limit Increase."

## License

Copyright (c) 2023 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](./LICENSE) for more details.