data "oci_core_private_ips" "firewall_private_ip" {
  subnet_id = oci_core_subnet.hub_sub.id

  filter {
    name   = "display_name"
    values = [oci_network_firewall_network_firewall.network_firewall.display_name]
  }

  depends_on = [
    oci_network_firewall_network_firewall.network_firewall
  ]
}

data "oci_core_private_ips" "onprem_libreswan_private_ip" {
  subnet_id = oci_core_subnet.onprem_vpn_sub.id

  filter {
    name   = "display_name"
    values = [oci_core_instance.onprem_libreswan.display_name]
  }

  depends_on = [
    oci_core_instance.onprem_libreswan
  ]
}

data "oci_core_private_ips" "multicloud_libreswan_private_ip" {
  subnet_id = oci_core_subnet.multicloud_vpn_sub.id

  filter {
    name   = "display_name"
    values = [oci_core_instance.multicloud_libreswan.display_name]
    //values = ["oci-network-firewall-demo"]
  }

  depends_on = [
    oci_core_instance.multicloud_libreswan
  ]
}

data "oci_core_cpe_device_shapes" "oci_ipsec_cpe_device_shapes" {
}

data "oci_core_cpe_device_shape" "oci_ipsec_cpe_device_shape" {
  cpe_device_shape_id = data.oci_core_cpe_device_shapes.oci_ipsec_cpe_device_shapes.cpe_device_shapes[1].cpe_device_shape_id
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = oci_identity_compartment.demo.id
}

data "oci_core_images" "os" {
  compartment_id           = oci_identity_compartment.demo.id
  operating_system = "Oracle Linux"
  operating_system_version = "8"

  shape                    = "VM.Standard.E4.Flex"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

data "oci_core_ipsec_config" "onprem_ipsec_config" {
    ipsec_id = oci_core_ipsec.onprem_ipsec_connection.id
}

data "oci_core_ipsec_config" "multicloud_ipsec_config" {
    ipsec_id = oci_core_ipsec.multicloud_ipsec_connection.id
}

data "oci_core_ipsec_connections" "onprem_ipsec_connections" {
  compartment_id = oci_identity_compartment.demo.id

  cpe_id         = oci_core_cpe.onprem_cpe.id
  drg_id         = oci_core_drg.drg.id
}

data "oci_core_ipsec_connection_tunnels" "onprem_ipsec_tunnels" {
  ipsec_id = oci_core_ipsec.onprem_ipsec_connection.id
}

data "oci_core_ipsec_connection_tunnel" "onprem_ipsec_tunnel_a" {
  ipsec_id  = oci_core_ipsec.onprem_ipsec_connection.id
  tunnel_id = data.oci_core_ipsec_connection_tunnels.onprem_ipsec_tunnels.ip_sec_connection_tunnels[0].id
}

data "oci_core_ipsec_connection_tunnel" "onprem_ipsec_tunnel_b" {
  ipsec_id  = oci_core_ipsec.onprem_ipsec_connection.id
  tunnel_id = data.oci_core_ipsec_connection_tunnels.onprem_ipsec_tunnels.ip_sec_connection_tunnels[1].id
}

data "oci_core_ipsec_connection_tunnels" "multicloud_ipsec_tunnels" {
  ipsec_id = oci_core_ipsec.multicloud_ipsec_connection.id
}

data "oci_core_ipsec_connection_tunnel" "multicloud_ipsec_tunnel_a" {
  ipsec_id  = oci_core_ipsec.onprem_ipsec_connection.id
  tunnel_id = data.oci_core_ipsec_connection_tunnels.multicloud_ipsec_tunnels.ip_sec_connection_tunnels[0].id
}

data "oci_core_ipsec_connection_tunnel" "multicloud_ipsec_tunnel_b" {
  ipsec_id  = oci_core_ipsec.onprem_ipsec_connection.id
  tunnel_id = data.oci_core_ipsec_connection_tunnels.multicloud_ipsec_tunnels.ip_sec_connection_tunnels[1].id
}

data "oci_core_ipsec_connections" "multicloud_ipsec_connections" {
  compartment_id = oci_identity_compartment.demo.id

  cpe_id         = oci_core_cpe.multicloud_cpe.id
  drg_id         = oci_core_drg.drg.id
}