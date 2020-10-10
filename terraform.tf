#########################
####### VARIABLES #######
#########################

# The following variables are declared in the accompanying TFVARS file

# vCenter Server username
variable "vcenter_user" { }

# vCenter Server password
variable "vcenter_password" { }

# vCenter Server address
variable "vcenter_server" { }

# Path in which the VM's public key should be saved
variable "ssh_public_key_path" { default = "~/.ssh/vsphere_workstation.pub" }

# vSphere network to use for the VM
variable "network" { default = "VM Network"}

# Hostname for the VM
variable "vm_name" { default = "vsphere-workstation" }

# vSphere datacenter in which to create the admin workstation VM
variable "datacenter" { }

# vSphere datastore to use for storage
variable "datastore" { }

# vSphere cluster in which to create the VM
variable "cluster" { }

# vSphere resource pool in which to create the VM
variable "resource_pool" { }

# Number of CPUs for this VM. Recommended minimum 4.
variable "num_cpus" { default = 4 }

# Memory in MB for this VM. Recommended minimum 8192.
variable "memory" { default = 8192 }

# The VM template (OVA) to clone
variable "vm_template" { }

# The IP address to assign to the VM
variable "ipv4_address" { }

# Netmask prefix length
variable "ipv4_netmask_prefix_length" { }

# Default gateway to use
variable "ipv4_gateway" { }

# DNS resolvers to use
variable "dns_nameservers" { }


##########################
##########################

provider "vsphere" {
  version        = "~> 1.5"
  user           = "${var.vcenter_user}"
  password       = "${var.vcenter_password}"
  vcenter_server = "${var.vcenter_server}"

  # if you have a self-signed cert
  allow_unverified_ssl = true
}

### vSphere Data ###

data "vsphere_datastore" "datastore" {
  name          = "${var.datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_datacenter" "dc" {
  name = "${var.datacenter}"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "${var.cluster}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "${var.resource_pool}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "${var.network}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template_from_ovf" {
  name          = "${var.vm_template}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

##########################
### IF USING STATIC IP ###
##########################
data "template_file" "static_ip_config" {
  template = <<EOF
network:
  version: 2
  ethernets:
    ens192:
      dhcp4: no
      dhcp6: no
      addresses: ["${var.ipv4_address}/${var.ipv4_netmask_prefix_length}"]
      gateway4: ${var.ipv4_gateway}
      nameservers:
        addresses: [${var.dns_nameservers}]
EOF
}

data "template_file" "user_data" {
  template = <<EOF
#cloud-config
apt:
  primary:
    - arches: [default]
      uri: http://us-west1.gce.archive.ubuntu.com/ubuntu/
write_files:
  - path: /tmp/static-ip.yaml
    permissions: '0644'
    encoding: base64
    content: |
      $${static_ip_config}
runcmd:
  - /var/lib/gke/guest-startup.sh
EOF
  vars = {
    static_ip_config = "${base64encode(data.template_file.static_ip_config.rendered)}"

  }
}
##########################
### IF USING STATIC IP ###
##########################

### vSphere Resources ###

resource "vsphere_virtual_machine" "vm" {
  name             = "${var.vm_name}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  num_cpus         = "${var.num_cpus}"
  memory           = "${var.memory}"
  guest_id         = "${data.vsphere_virtual_machine.template_from_ovf.guest_id}"
  enable_disk_uuid = "true"
  scsi_type = "${data.vsphere_virtual_machine.template_from_ovf.scsi_type}"
  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template_from_ovf.network_interface_types[0]}"
  }

  wait_for_guest_net_timeout = 15

  nested_hv_enabled = false
  cpu_performance_counters_enabled = false

  disk {
    label            = "disk0"
    size             = "${max(50, data.vsphere_virtual_machine.template_from_ovf.disks.0.size)}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template_from_ovf.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template_from_ovf.disks.0.thin_provisioned}"
  }

  cdrom {
    client_device = true
  }

  vapp {
    properties = {
      hostname    = "${var.vm_name}"
      public-keys = "${file(var.ssh_public_key_path)}"
      user-data   = "${base64encode(data.template_file.user_data.rendered)}"
    }
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template_from_ovf.id}"
  }
}

output "ip_address" {
  value = "${vsphere_virtual_machine.vm.default_ip_address}"
}
