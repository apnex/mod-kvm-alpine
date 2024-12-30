# Specify the libvirt provider
# https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs 
# https://github.com/dmacvicar/terraform-provider-libvirt
terraform {
	required_providers {
		libvirt = {
			source = "dmacvicar/libvirt"
		}
	}
}

# Configure the Libvirt provider for local system
provider "libvirt" {
	uri = "qemu:///system"
}

# Create a blank 10GB disk
resource "libvirt_volume" "mydisk" {
	name	= "mydisk"
	pool	= "default"
	format	= "qcow2"
	size	= 10000000000
}

# Create a new domain - boot from alpine iso URL
resource "libvirt_domain" "alpine-01" {
	name	= "alpine-01"
	cpu {
		mode = "host-passthrough"
	}
	vcpu	= 2
	memory	= 2048

	network_interface {
	}
	disk {
		volume_id = libvirt_volume.mydisk.id
		scsi      = "true"
	}
	disk {
		url = "http://pxe.apnex.io/alpine.iso"
	}
	boot_device {
		dev = [ "hd", "cdrom" ]
	}
}
