////Spoke Networking Setup

//Create Spoke VCN
resource "oci_core_vcn" "spoke_vcn" {
    cidr_block = var.spoke_cidr
    compartment_id = oci_identity_compartment.demo.id
    dns_label = "spoke"
    display_name = "Spoke-VCN"
}

//Create IG
resource "oci_core_internet_gateway" "spoke_igw" {
    compartment_id = oci_identity_compartment.demo.id
    vcn_id = oci_core_vcn.spoke_vcn.id

    display_name = "Spoke-IGW"
}

//Modify Spoke Default Route Table
resource "oci_core_default_route_table" "spoke_default_route_table" {
    manage_default_resource_id = oci_core_vcn.spoke_vcn.default_route_table_id
    display_name = "Default Route Table"

    route_rules {
        network_entity_id = oci_core_internet_gateway.spoke_igw.id
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
        }
         
    route_rules {
        network_entity_id = oci_core_drg.drg.id
        destination = oci_core_vcn.hub_vcn.cidr_block
        destination_type = "CIDR_BLOCK"
    }

        route_rules {
        network_entity_id = oci_core_drg.drg.id
        destination = oci_core_vcn.multicloud_vcn.cidr_block
        destination_type = "CIDR_BLOCK"
    }

        route_rules {
        network_entity_id = oci_core_drg.drg.id
        destination = oci_core_vcn.onprem_vcn.cidr_block
        destination_type = "CIDR_BLOCK"
    }
}

//Modify Spoke Default Security List
resource "oci_core_default_security_list" "spoke_default_sl" {
    manage_default_resource_id = oci_core_vcn.spoke_vcn.default_security_list_id
    compartment_id = oci_identity_compartment.demo.id

   ingress_security_rules {
    protocol = "all"
    source = "0.0.0.0/0"
   }

    egress_security_rules {
    protocol = "all"
    destination = "0.0.0.0/0"
   }
}

//Create Public Subnet
resource "oci_core_subnet" "spoke_sub" {
    cidr_block = var.spoke_cidr
    compartment_id = oci_identity_compartment.demo.id
    vcn_id = oci_core_vcn.spoke_vcn.id

    dns_label = "spoke"
    display_name = "Spoke-Sub"
}

////Hub Networking Setup

//Create Hub VCN
resource "oci_core_vcn" "hub_vcn" {
    cidr_block = var.hub_cidr
    compartment_id = oci_identity_compartment.demo.id
    dns_label = "hub"
    display_name = "Hub-VCN"
}

resource "oci_core_default_security_list" "hub_default_sl" {
    manage_default_resource_id = oci_core_vcn.hub_vcn.default_security_list_id
    compartment_id = oci_identity_compartment.demo.id

   ingress_security_rules {
    protocol = "all"
    source = "0.0.0.0/0"
   }

    egress_security_rules {
    protocol = "all"
    destination = "0.0.0.0/0"
   }
}

//Edit Route Table
resource "oci_core_default_route_table" "hub_default_route_table" {
    manage_default_resource_id = oci_core_vcn.hub_vcn.default_route_table_id

route_rules {
        network_entity_id = oci_core_drg.drg.id
        destination = oci_core_vcn.spoke_vcn.cidr_block
        destination_type = "CIDR_BLOCK"
    }

        route_rules {
        network_entity_id = oci_core_drg.drg.id
        destination = oci_core_vcn.multicloud_vcn.cidr_block
        destination_type = "CIDR_BLOCK"
    }

        route_rules {
        network_entity_id = oci_core_drg.drg.id
        destination = oci_core_vcn.onprem_vcn.cidr_block
        destination_type = "CIDR_BLOCK"
    }
}

//Create Route Table for DRG VCN Attachment for incoming traffic via DRG
resource "oci_core_route_table" "hub_vcn_ingress_rt" {
    compartment_id = oci_identity_compartment.demo.id
    vcn_id = oci_core_vcn.hub_vcn.id
    display_name = "Hub_VCN_Ingress_RT"

   route_rules {
        network_entity_id = data.oci_core_private_ips.firewall_private_ip.private_ips[0].id
        destination = oci_core_vcn.spoke_vcn.cidr_block
        destination_type = "CIDR_BLOCK"
    }
       route_rules {
        network_entity_id = data.oci_core_private_ips.firewall_private_ip.private_ips[0].id
        destination = oci_core_vcn.onprem_vcn.cidr_block
        destination_type = "CIDR_BLOCK"
    }
}

//Create Public Subnet
resource "oci_core_subnet" "hub_sub" {
    cidr_block = var.hub_cidr
    compartment_id = oci_identity_compartment.demo.id
    vcn_id = oci_core_vcn.hub_vcn.id

    dns_label = "hub"
    display_name = "Hub-Sub"
}


////OnPrem Networking Setup

//Create OnPrem VCN
resource "oci_core_vcn" "onprem_vcn" {
    cidr_block = var.onprem_vcn_cidr
    compartment_id = oci_identity_compartment.demo.id
    dns_label = "onprem"
    display_name = "OnPrem-VCN"
}

//Create Public Subnet
resource "oci_core_subnet" "onprem_vpn_sub" {
    //cidr_block = var.onprem_cidr
    cidr_block = var.onprem_vpn_sub_cidr
    compartment_id = oci_identity_compartment.demo.id
    vcn_id = oci_core_vcn.onprem_vcn.id

    dns_label = "onprem"
    display_name = "OnPrem-Sub"
}

resource "oci_core_subnet" "onprem_workload_sub" {
    cidr_block = var.onprem_wl_sub_cidr
    compartment_id = oci_identity_compartment.demo.id
    vcn_id = oci_core_vcn.onprem_vcn.id
    route_table_id = oci_core_route_table.onprem_wl_rt.id

    dns_label = "onpremwl"
    display_name = "OnPrem-WL-Sub"
}

//Create IG for OnPrem
resource "oci_core_internet_gateway" "onprem_igw" {
    compartment_id = oci_identity_compartment.demo.id
    vcn_id = oci_core_vcn.onprem_vcn.id

    display_name = "OnPrem-IGW"
}

//Edit OnPrem VCN Default Route Table to use IGW
resource "oci_core_default_route_table" "onprem_default_route_table" {
    manage_default_resource_id = oci_core_vcn.onprem_vcn.default_route_table_id

    display_name = "Default Route Table"

    route_rules {
        network_entity_id = oci_core_internet_gateway.onprem_igw.id
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
    }

}

//Create new route table
resource "oci_core_route_table" "onprem_wl_rt" {
    compartment_id = oci_identity_compartment.demo.id
    vcn_id = oci_core_vcn.onprem_vcn.id
    display_name = "OnPrem_Priv_RT"

   route_rules {
        network_entity_id = data.oci_core_private_ips.onprem_libreswan_private_ip.private_ips[0].id
        destination = oci_core_vcn.spoke_vcn.cidr_block
        destination_type = "CIDR_BLOCK"
    }

    route_rules {
        network_entity_id = oci_core_internet_gateway.onprem_igw.id
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
    }
}

resource "oci_core_default_security_list" "onprem_default_sl" {
    manage_default_resource_id = oci_core_vcn.onprem_vcn.default_security_list_id
    compartment_id = oci_identity_compartment.demo.id

   ingress_security_rules {
    protocol = "all"
    source = "0.0.0.0/0"
   }

    egress_security_rules {
    protocol = "all"
    destination = "0.0.0.0/0"
   }

}


////Multicloud Networking Setup

//Create multicloud VCN
resource "oci_core_vcn" "multicloud_vcn" {
    cidr_block = var.multicloud_vcn_cidr
    compartment_id = oci_identity_compartment.demo.id
    dns_label = "multi"
    display_name = "Multicloud-VCN"
}

//Create IG for Multicloud
resource "oci_core_internet_gateway" "multicloud_igw" {
    compartment_id = oci_identity_compartment.demo.id
    vcn_id = oci_core_vcn.multicloud_vcn.id

    display_name = "Multicloud-IGW"
}

resource "oci_core_default_route_table" "multicloud_default_route_table" {
    manage_default_resource_id = oci_core_vcn.multicloud_vcn.default_route_table_id
    display_name = "Default Route Table"

    route_rules {
        network_entity_id = oci_core_internet_gateway.multicloud_igw.id
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
    }
}

//Create new route table
resource "oci_core_route_table" "multicloud_wl_rt" {
    compartment_id = oci_identity_compartment.demo.id
    vcn_id = oci_core_vcn.multicloud_vcn.id
    display_name = "Multicloud_Priv_RT"

   route_rules {
        network_entity_id = data.oci_core_private_ips.multicloud_libreswan_private_ip.private_ips[0].id
        destination = oci_core_vcn.spoke_vcn.cidr_block
        destination_type = "CIDR_BLOCK"
    }

        route_rules {
        network_entity_id = oci_core_internet_gateway.multicloud_igw.id
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
    }
}

resource "oci_core_default_security_list" "multicloud_default_sl" {
    manage_default_resource_id = oci_core_vcn.multicloud_vcn.default_security_list_id
    compartment_id = oci_identity_compartment.demo.id

   ingress_security_rules {
    protocol = "all"
    source = "0.0.0.0/0"
   }

    egress_security_rules {
    protocol = "all"
    destination = "0.0.0.0/0"
   }

}

//Create Public Subnet
resource "oci_core_subnet" "multicloud_vpn_sub" {
    cidr_block = var.multicloud_vpn_sub_cidr
    compartment_id = oci_identity_compartment.demo.id
    vcn_id = oci_core_vcn.multicloud_vcn.id

    dns_label = "multicloud"
    display_name = "Multicloud-Sub"
}

resource "oci_core_subnet" "multicloud_workload_sub" {
    cidr_block = var.multicloud_wl_sub_cidr
    compartment_id = oci_identity_compartment.demo.id
    vcn_id = oci_core_vcn.multicloud_vcn.id
    route_table_id = oci_core_route_table.multicloud_wl_rt.id

    dns_label = "multicloudwl"
    display_name = "Multicloud-WL-Sub"
}