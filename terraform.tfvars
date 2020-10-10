# vCenter Server username
vcenter_user = "ANZ_provide"

# vCenter Server password
vcenter_password = "ANZ_provide"

# vCenter Server IP or hostname
vcenter_server = "ANZ_provide"

# Path in which the admin workstation's VM's public key should be saved
ssh_public_key_path = "~/.ssh/vsphere_workstation.pub"

# Hostname for the VM
vm_name = "gkeadminworkstation"

# vSphere datastore to use for storage
datastore = "Anthos"  #ANZ to confirm

# vSphere datacenter in which to create the VM
datacenter = "ANZ_provide"

# vSphere cluster in which to create the VM
cluster = "ANZ_provide"

# vSphere resource pool in which to create VM, if you are using a non-default resource pool
# If you are using the default resource pool, provide a value like "[CLUSTER-NAME]/Resources"
resource_pool = "anthos"  #ANZ to confirm

# vSphere network to use for the VM
network = "ANZ_provide"

# Number of CPUs for this VM. Recommended minimum 4.
num_cpus = 4

# Memory in MB for this VM. Recommended minimum 8192.
memory = 8192

# The VM template (OVA) to clone. Change the version if you imported a different version of the OVA.
vm_template = "update_version_need_to download"

################################################
# Static IP settings                           #
################################################

# An IPv4 static IP for the admin workstataion
ipv4_address = "ANZ_to_confirm"

# The netmask prefix length to use
ipv4_netmask_prefix_length = "24"

# The IPv4 gateway the admin workstation should use
ipv4_gateway = "Anz_to_Confirm"

# Comma-delimited DNS servers
dns_nameservers = "ANZ_confirm"
