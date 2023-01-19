// Create IPSEC CPE for OnPrem Connection
resource "oci_core_cpe" "onprem_cpe" {
  compartment_id = oci_identity_compartment.demo.id
  display_name        = "OnPrem-CPE"
  ip_address          = oci_core_instance.onprem_libreswan.public_ip
  cpe_device_shape_id = data.oci_core_cpe_device_shape.oci_ipsec_cpe_device_shape.id
}

// Create IPSEC connection for OnPrem Connection
resource "oci_core_ipsec" "onprem_ipsec_connection" {
  compartment_id = oci_identity_compartment.demo.id
  cpe_id         = oci_core_cpe.onprem_cpe.id
  drg_id         = oci_core_drg.drg.id
  static_routes  = [oci_core_vcn.onprem_vcn.cidr_block]

  cpe_local_identifier      = oci_core_instance.onprem_libreswan.public_ip
  cpe_local_identifier_type = "IP_ADDRESS"
  display_name = "OnPrem-IPSec"
}

// Create IPSEC connection management for OnPrem IPSec tunnel a
resource "oci_core_ipsec_connection_tunnel_management" "onprem_ipsec_tunnel_management_a" {
  ipsec_id  = oci_core_ipsec.onprem_ipsec_connection.id
  tunnel_id = data.oci_core_ipsec_connection_tunnels.onprem_ipsec_tunnels.ip_sec_connection_tunnels[0].id
  depends_on = [data.oci_core_ipsec_connections.onprem_ipsec_connections]

   bgp_session_info {
        customer_interface_ip = "10.10.10.1/30"
        oracle_interface_ip = "10.10.10.2/30"
    }

  display_name  = "OnPrem-IPSec-tunnel-a"
  routing       = "STATIC"
  ike_version   = "V1"
}

// Create IPSEC connection management for OnPrem IPSec tunnel b
resource "oci_core_ipsec_connection_tunnel_management" "onprem_ipsec_connection_tunnel_management-b" {
  ipsec_id  = oci_core_ipsec.onprem_ipsec_connection.id
  tunnel_id = data.oci_core_ipsec_connection_tunnels.onprem_ipsec_tunnels.ip_sec_connection_tunnels[1].id
  depends_on = [data.oci_core_ipsec_connections.onprem_ipsec_connections]

     bgp_session_info {
        customer_interface_ip = "10.10.10.5/30"
        oracle_interface_ip = "10.10.10.6/30"
    }

  display_name  = "OnPrem-IPSec-tunnel-b"
  routing       = "STATIC"
  ike_version   = "V1"
}

//Update DRG IPSec attachment to assign DRG Route Table to the attachment
resource "oci_core_drg_attachment_management" "onprem_ipsec_attachment_tunnel_a" {
  attachment_type = "IPSEC_TUNNEL"
  compartment_id = oci_identity_compartment.demo.id
  network_id = data.oci_core_ipsec_connection_tunnels.onprem_ipsec_tunnels.ip_sec_connection_tunnels.0.id
  drg_id = oci_core_drg.drg.id
  display_name = "drg-ipsec-onprem-attachment-tunnel-a"
  drg_route_table_id = oci_core_drg_route_table.drg_onprem_ipsec_rt.id
}

//Update DRG IPSec attachment to assign DRG Route Table to the attachment
resource "oci_core_drg_attachment_management" "onprem_ipsec_attachment_tunnel_b" {
  attachment_type = "IPSEC_TUNNEL"
  compartment_id = oci_identity_compartment.demo.id
  network_id = data.oci_core_ipsec_connection_tunnels.onprem_ipsec_tunnels.ip_sec_connection_tunnels.1.id
  drg_id = oci_core_drg.drg.id
  display_name = "drg-ipsec-onprem-attachment-tunnel-b"
  drg_route_table_id = oci_core_drg_route_table.drg_onprem_ipsec_rt.id
}

// Create IPSEC CPE for Multicloud
resource "oci_core_cpe" "multicloud_cpe" {
  compartment_id = oci_identity_compartment.demo.id
  display_name        = "Multicloud-CPE"
  ip_address          = oci_core_instance.multicloud_libreswan.public_ip
  cpe_device_shape_id = data.oci_core_cpe_device_shape.oci_ipsec_cpe_device_shape.id
}
// Create IPSEC connection for Multicloud 
resource "oci_core_ipsec" "multicloud_ipsec_connection" {
  #Required
  compartment_id = oci_identity_compartment.demo.id
  cpe_id         = oci_core_cpe.multicloud_cpe.id
  drg_id         = oci_core_drg.drg.id
  static_routes  = [oci_core_vcn.multicloud_vcn.cidr_block]

  cpe_local_identifier      = oci_core_instance.multicloud_libreswan.public_ip
  cpe_local_identifier_type = "IP_ADDRESS"
  display_name = "Multicloud-IPSec"
}

// Create IPSEC connection management for Multicloud IPSec tunnel a
resource "oci_core_ipsec_connection_tunnel_management" "multicloud_ipsec_tunnel_management_a" {
  ipsec_id  = oci_core_ipsec.multicloud_ipsec_connection.id
  tunnel_id = data.oci_core_ipsec_connection_tunnels.multicloud_ipsec_tunnels.ip_sec_connection_tunnels[0].id
  depends_on = [data.oci_core_ipsec_connections.multicloud_ipsec_connections]

   bgp_session_info {
        customer_interface_ip = "10.10.20.1/30"
        oracle_interface_ip = "10.10.20.2/30"
    }

  display_name  = "Multicloud-IPSec-tunnel-a"
  routing       = "STATIC"
  ike_version   = "V1"
}

// Create IPSEC connection management for Multicloud IPSec tunnel b
resource "oci_core_ipsec_connection_tunnel_management" "multicloud_ipsec_connection_tunnel_management_b" {
  ipsec_id  = oci_core_ipsec.multicloud_ipsec_connection.id
  tunnel_id = data.oci_core_ipsec_connection_tunnels.multicloud_ipsec_tunnels.ip_sec_connection_tunnels[1].id
  depends_on = [data.oci_core_ipsec_connections.multicloud_ipsec_connections]

     bgp_session_info {
        customer_interface_ip = "10.10.20.5/30"
        oracle_interface_ip = "10.10.20.5/30"
    }

  display_name  = "Multicloud-IPSec-tunnel-b"
  routing       = "STATIC"
  ike_version   = "V1"
}

//Update DRG IPSec attachment to assign DRG Route Table to the attachment
resource "oci_core_drg_attachment_management" "multicloud_ipsec_attachment_tunnel_a" {
  attachment_type = "IPSEC_TUNNEL"
  compartment_id = oci_identity_compartment.demo.id
  network_id = data.oci_core_ipsec_connection_tunnels.multicloud_ipsec_tunnels.ip_sec_connection_tunnels.0.id
  drg_id = oci_core_drg.drg.id
  display_name = "drg-ipsec-multicloud-attachment-tunnel-a"
  drg_route_table_id = oci_core_drg_route_table.drg_multicloud_ipsec_rt.id
}

//Update DRG IPSec attachment to assign DRG Route Table to the attachment
resource "oci_core_drg_attachment_management" "multicloud_ipsec_attachment_tunnel_b" {
  attachment_type = "IPSEC_TUNNEL"
  compartment_id = oci_identity_compartment.demo.id
  network_id = data.oci_core_ipsec_connection_tunnels.multicloud_ipsec_tunnels.ip_sec_connection_tunnels.1.id
  drg_id = oci_core_drg.drg.id
  display_name = "drg-ipsec-multicloud-attachment-tunnel-b"
  drg_route_table_id = oci_core_drg_route_table.drg_multicloud_ipsec_rt.id
}