# ###################################################################################################### #
# Copyright (c) 2025 Oracle and/or its affiliates, All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl. #
# ###################################################################################################### #


# ----------------------------------------------------------------------------------------
# -- 1. Rename this file to terraform.tfvars
# -- 2. Provide/review the variable assignments below.
# -- 3. In this folder, execute the typical Terraform workflow:
# ----- $ terraform init
# ----- $ terraform plan
# ----- $ terraform apply
# ----------------------------------------------------------------------------------------


#---------------------------------------
# Tenancy Connectivity Variables
#---------------------------------------

tenancy_ocid         =  # Get this from OCI Console (after logging in, go to top-right-most menu item and click option "Tenancy: <your tenancy name>").
current_user_ocid    =  # Get this from OCI Console (after logging in, go to top-right-most menu item and click option "My profile").
api_fingerprint      =  # The fingerprint can be gathered from your user account. In the "My profile page, click "API keys" on the menu in left hand side).
api_private_key_path =  # This is the full path on your local system to the API signing private key.
region               =  # This is your tenancy region, where all other resources are created. It can be the same as home_region.

#---------------------------------------
# COMPARTMENT variables
#---------------------------------------

home_region_deployment 		= true
home_compartment_name 		= "OCI-SCCA-LZ-Home"
vdms_compartment_name 		= "OCI-SCCA-LZ-VDMS"
vdss_compartment_name 		= "OCI-SCCA-LZ-VDSS"
backup_compartment_name 	= "OCI-SCCA-LZ-IAC-TF-Configbackup"
enable_logging_compartment 	= false
logging_compartment_name 	= "OCI-SCCA-LZ-Logging"
realm_key = "3"
resource_label = "TVK"
secondary_region = "us-gov-phoenix-1"

#---------------------------------------
# MONITORING variables
#---------------------------------------

vdms_critical_topic_endpoints 	= ["username@domain.com"]
vdms_warning_topic_endpoints  	= ["username@domain.com"] 
vdss_critical_topic_endpoints 	= ["username@domain.com"]
vdss_warning_topic_endpoints  	= ["username@domain.com"]
enable_vdss_warning_alarm  		= false
enable_vdss_critical_alarm 		= false
enable_vdms_warning_alarm  		= false
enable_vdms_critical_alarm 		= false
onboard_log_analytics      		= false


#---------------------------------------
# Security variables
#---------------------------------------


backup_bucket_name                   = "OCI-SCCA-LZ-IAC-Backup"
central_vault_name                   = "OCI-SCCA-LZ-Central-Vault"
central_vault_type                   = "DEFAULT"
enable_vault_replication             = false
master_encryption_key_name           = "OCI-SCCA-LZ-MSK"
cloud_guard_target_tenancy           = false
bastion_client_cidr_block_allow_list = ["0.0.0.0/0"]
retention_policy_duration_amount     = "1"
retention_policy_duration_time_unit  = "DAYS"
enable_bucket_replication            = false
bucket_storage_tier                  = "Archive"


#---------------------------------------
# Network variables
#---------------------------------------

vdss_vcn_cidr_block        	= "192.168.0.0/24"
firewall_subnet_cidr_block 	= "192.168.0.0/25"
lb_subnet_cidr_block       	= "192.168.0.128/25"
vdms_vcn_cidr_block        	= "192.168.1.0/24"
vdms_subnet_cidr_block     	= "192.168.1.0/24"
is_vdms_vtap_enabled 		= false
is_vtap_enabled      		= false

#---------------------------------------
# Workload Variables
#---------------------------------------

mission_owner_key 					= "WRK"
workload_name	 					= "SCWRK"
workload_vcn_cidr_block 			= "192.168.2.0/24"
workload_subnet_cidr_block 			= "192.168.2.0/24"
workload_db_vcn_cidr_block 			= "192.168.3.0/24"
workload_db_subnet_cidr_block 		= "192.168.3.0/24"
is_workload_vtap_enabled 			= false
workload_critical_topic_endpoints 	= ["username@domain.com"]
workload_warning_topic_endpoints 	= ["username@domain.com"]
enable_workload_warning_alarm 		= false
enable_workload_critical_alarm 		= false
