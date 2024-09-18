#---------------------------------------
# Tenancy Connectivity Variables
#---------------------------------------

tenancy_ocid         = "" # Get this from OCI Console (after logging in, go to top-right-most menu item and click option "Tenancy: <your tenancy name>").
current_user_ocid    = "" # Get this from OCI Console (after logging in, go to top-right-most menu item and click option "My profile").
api_fingerprint      = "" # The fingerprint can be gathered from your user account. In the "My profile page, click "API keys" on the menu in left hand side).
api_private_key_path = "" # This is the full path on your local system to the API signing private key.
region               = "" # This is your tenancy region, where all other resources are created. It can be the same as home_region.
secondary_region     = ""

#---------------------------------------
# Input variables
#---------------------------------------
# COMPARTMENT
resource_label = "WKL1"

scca_child_home_compartment_ocid = ""
scca_child_vdms_compartment_ocid = ""
scca_child_vdss_compartment_ocid = ""

# IDENTITY DOMAIN
scca_child_identity_domain_id = "" # the ocid of the identity domain in the scca landing zone child tenancy

# MONITORING
workload_critical_topic_endpoints = []
workload_warning_topic_endpoints  = []
enable_workload_warning_alarm     = true
enable_workload_critical_alarm    = true

# NETWORKING
lb_subnet_cidr_block_child = ""
fw_subnet_cidr_block_child = ""
child_drg_id               = ""
  
wrk_vcn_cidr_block                   = "13.1.0.0/16"
wrk_vcn_dns_label                    = "wrkvcndns"
web_subnet_cidr_block                = "13.1.1.0/24"
web_subnet_dns_label                 = "wrkwebdns"
web_subnet_name                      = "OCI-SCCA-LZ-WRK-Web-Subnet"
app_subnet_cidr_block                = "13.1.2.0/24"
app_subnet_dns_label                 = "wrkappdns"
app_subnet_name                      = "OCI-SCCA-LZ-WRK-App-Subnet"
db_subnet_cidr_block                 = "13.1.3.0/24"
db_subnet_dns_label                  = "wrkdbdns"
db_subnet_name                       = "OCI-SCCA-LZ-WRK-DB-Subnet"
enable_workload_network_firewall     = false
enable_bastion_wrk                   = false
bastion_client_cidr_block_allow_list = ["13.1.0.0/16"]
