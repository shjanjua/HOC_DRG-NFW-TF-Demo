//Create DRG
resource "oci_core_drg" "drg" {
    compartment_id = oci_identity_compartment.demo.id

    display_name = "Demo-DRG"
}

//Create Route Table for traffic incoming to DRG from OnPrem VCN
resource "oci_core_drg_route_table" "drg_onprem_ipsec_rt" {
    drg_id = oci_core_drg.drg.id

    display_name = "DRG-OnPrem-IPSec-RT"
}

//Create Route Table Rule
resource "oci_core_drg_route_table_route_rule" "drg_onprem_ipsec_rt_rule" {
    drg_route_table_id = oci_core_drg_route_table.drg_onprem_ipsec_rt.id
    destination = oci_core_vcn.spoke_vcn.cidr_block
    destination_type = "CIDR_BLOCK"
    next_hop_drg_attachment_id = oci_core_drg_attachment.hub_drg_attachment.id
}

//Create Route Table for traffic incoming to DRG from Multicloud VCN
resource "oci_core_drg_route_table" "drg_multicloud_ipsec_rt" {
    drg_id = oci_core_drg.drg.id

    display_name = "DRG-Multicloud-IPSec-RT"
}

//Create Route Table Rule
resource "oci_core_drg_route_table_route_rule" "drg_multicloud_ipsec_rt_rule" {
    drg_route_table_id = oci_core_drg_route_table.drg_multicloud_ipsec_rt.id
    destination = oci_core_vcn.spoke_vcn.cidr_block
    destination_type = "CIDR_BLOCK"
    next_hop_drg_attachment_id = oci_core_drg_attachment.spoke_drg_attachment.id
}

//Create Route Table for traffic incofming to DRG from Hub VCN
resource "oci_core_drg_route_table" "drg_hub_rt" {
    drg_id = oci_core_drg.drg.id

    display_name = "DRG-Hub-RT"
    import_drg_route_distribution_id = oci_core_drg_route_distribution.drg_hub_route_distribution.id
}

//Create Import Route Distribution for DRG Hub VCN Route Table
resource "oci_core_drg_route_distribution" "drg_hub_route_distribution" {
    distribution_type = "IMPORT"
    drg_id = oci_core_drg.drg.id

    display_name = "DRG-Hub-Route-Distro"
}

//Create Route Table Rule
resource "oci_core_drg_route_table_route_rule" "drg_hub_rt_rule" {
    drg_route_table_id = oci_core_drg_route_table.drg_hub_rt.id
    destination = oci_core_vcn.spoke_vcn.cidr_block
    destination_type = "CIDR_BLOCK"
    next_hop_drg_attachment_id = oci_core_drg_attachment.spoke_drg_attachment.id
}

//Create Route Table Import Route Distribution Statement
resource "oci_core_drg_route_distribution_statement" "drg_hub_route_distribution_statement" {
    drg_route_distribution_id = oci_core_drg_route_distribution.drg_hub_route_distribution.id
    action = "ACCEPT"

    match_criteria {
        match_type = "DRG_ATTACHMENT_TYPE"

        attachment_type = "IPSEC_TUNNEL"
    }
    priority = 1
}

//Create Route Table for traffic incoming to DRG from Spoke VCN
resource "oci_core_drg_route_table" "drg_spoke_rt" {
    drg_id = oci_core_drg.drg.id
    display_name = "DRG-Spoke-RT"
    import_drg_route_distribution_id = oci_core_drg_route_distribution.drg_spoke_route_distribution.id
}

resource "oci_core_drg_route_table_route_rule" "drg_spoke_rt_rule" {
    for_each = toset([oci_core_vcn.hub_vcn.cidr_block, oci_core_vcn.onprem_vcn.cidr_block])

    drg_route_table_id = oci_core_drg_route_table.drg_spoke_rt.id
    destination = each.key
    destination_type = "CIDR_BLOCK"
    next_hop_drg_attachment_id = oci_core_drg_attachment.hub_drg_attachment.id
}

//Create Import Route Distribution for DRG Spoke VCN Route Table
resource "oci_core_drg_route_distribution" "drg_spoke_route_distribution" {
    distribution_type = "IMPORT"
    drg_id = oci_core_drg.drg.id

    display_name = "DRG-Spoke-Route-Distro"
}

resource "oci_core_drg_route_distribution_statement" "drg_spoke_route_distribution_statement1" {
    drg_route_distribution_id = oci_core_drg_route_distribution.drg_spoke_route_distribution.id
    action = "ACCEPT"

    match_criteria {
        match_type = "DRG_ATTACHMENT_ID"

        attachment_type = "IPSEC_TUNNEL"
        drg_attachment_id = oci_core_drg_attachment_management.multicloud_ipsec_attachment_tunnel_a.id
    }
    priority = 1
}

resource "oci_core_drg_route_distribution_statement" "drg_spoke_route_distribution_statement2" {
    drg_route_distribution_id = oci_core_drg_route_distribution.drg_spoke_route_distribution.id
    action = "ACCEPT"

    match_criteria {
        match_type = "DRG_ATTACHMENT_ID"

        attachment_type = "IPSEC_TUNNEL"
        drg_attachment_id = oci_core_drg_attachment_management.multicloud_ipsec_attachment_tunnel_b.id
    }
    priority = 2
}

//Attach DRG to Hub VCN
resource "oci_core_drg_attachment" "hub_drg_attachment" {
  drg_id             = oci_core_drg.drg.id
  display_name       = "Hub-VCN-Attachment"
  drg_route_table_id = oci_core_drg_route_table.drg_hub_rt.id

  network_details {
    id             = oci_core_vcn.hub_vcn.id
    type           = "VCN"
    route_table_id = oci_core_route_table.hub_vcn_ingress_rt.id
  }
}

//Attach DRG to Spoke VCN
resource "oci_core_drg_attachment" "spoke_drg_attachment" {
  drg_id             = oci_core_drg.drg.id
  display_name       = "Spoke-VCN-Attachment"
  drg_route_table_id = oci_core_drg_route_table.drg_spoke_rt.id

  network_details {
    id             = oci_core_vcn.spoke_vcn.id
    type           = "VCN"
  }
}