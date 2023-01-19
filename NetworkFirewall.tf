//Create Policy for Network Firewall
resource "oci_network_firewall_network_firewall_policy" "network_firewall_policy" {
    compartment_id = oci_identity_compartment.demo.id
    display_name = "Demo-Network-Firewall-Policy"
    security_rules {
        action = "ALLOW"
        condition {}
        name = "Allow-All-Traffic"
    }
}

//Create Network Firewall
resource "oci_network_firewall_network_firewall" "network_firewall" {
    compartment_id = oci_identity_compartment.demo.id
    network_firewall_policy_id = oci_network_firewall_network_firewall_policy.network_firewall_policy.id
    subnet_id = oci_core_subnet.hub_sub.id
    display_name = "Demo-Network-Firewall"
}