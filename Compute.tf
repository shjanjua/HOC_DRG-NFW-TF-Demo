//Create On-Premise CPE VM
resource "oci_core_instance" "onprem_libreswan" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id = oci_identity_compartment.demo.id
  display_name        = "OnPrem-VPN"
  shape               = "VM.Standard.E4.Flex"

  shape_config {
    ocpus         = 1
    memory_in_gbs = 8
  }

  create_vnic_details {
    subnet_id      = oci_core_subnet.onprem_vpn_sub.id
    assign_public_ip          = true
    hostname_label            = "onprem-vpn"
    skip_source_dest_check = true
  }
  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.os.images[0].id
  }
  metadata = {
    ssh_authorized_keys = file(var.public_key_path)
  }
}

//Create On-Premise Workload VM
resource "oci_core_instance" "onprem_workload_vm" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id = oci_identity_compartment.demo.id
  display_name        = "OnPrem-VM"
  shape               = "VM.Standard.E4.Flex"

  shape_config {
    ocpus         = 1
    memory_in_gbs = 8
  }

  create_vnic_details {
    subnet_id      = oci_core_subnet.onprem_workload_sub.id
    assign_public_ip          = true
    hostname_label            = "OnPrem-VM"
    skip_source_dest_check = true
  }
  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.os.images[0].id
  }
  metadata = {
    ssh_authorized_keys = file(var.public_key_path)
  }
}

//Create Multicloud CPE VM
resource "oci_core_instance" "multicloud_libreswan" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id = oci_identity_compartment.demo.id
  display_name        = "Multicloud-VPN"
  shape               = "VM.Standard.E4.Flex"

  shape_config {
    ocpus         = 1
    memory_in_gbs = 8
  }

  create_vnic_details {
    subnet_id      = oci_core_subnet.multicloud_vpn_sub.id
    assign_public_ip          = true
    hostname_label            = "ulticloud-vpn"
    skip_source_dest_check = true
  }
  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.os.images[0].id
  }
  metadata = {
    ssh_authorized_keys = file(var.public_key_path)
  }
}

//Create Multicloud Workload VM
resource "oci_core_instance" "multicloud_workload_vm" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id = oci_identity_compartment.demo.id
  display_name        = "Multicloud-VM"
  shape               = "VM.Standard.E4.Flex"

  shape_config {
    ocpus         = 1
    memory_in_gbs = 8
  }

  create_vnic_details {
    subnet_id      = oci_core_subnet.multicloud_workload_sub.id
    assign_public_ip          = true
    hostname_label            = "multicloud-vm"
    skip_source_dest_check = true
  }
  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.os.images[0].id
  }
  metadata = {
    ssh_authorized_keys = file(var.public_key_path)
  }
}

//Create Spoke/Cloud Workload VM
resource "oci_core_instance" "spoke" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id = oci_identity_compartment.demo.id
  display_name        = "SpokeVM"
  shape               = "VM.Standard.E4.Flex"

  shape_config {
    ocpus         = 1
    memory_in_gbs = 8
  }

  create_vnic_details {
    subnet_id      = oci_core_subnet.spoke_sub.id
    assign_public_ip          = true
    hostname_label            = "spoke"
    skip_source_dest_check = true
  }
  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.os.images[0].id
  }
  metadata = {
    ssh_authorized_keys = file(var.public_key_path)
  }
}