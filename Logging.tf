resource "oci_logging_log_group" "log_group" {
    compartment_id = oci_identity_compartment.demo.id
    display_name = "DemoLoggingGroup"
}

resource "oci_logging_log" "NFW_Log" {
    display_name = "Demo_NetworkFirewall_Log"
    log_group_id = oci_logging_log_group.log_group.id
    log_type = "SERVICE"
    configuration {
        source {
            category = "trafficlog"
            resource = oci_network_firewall_network_firewall.network_firewall.id
            service = "ocinetworkfirewall"
            source_type = "OCISERVICE"
        }
        compartment_id = oci_identity_compartment.demo.id
    }
    is_enabled = true
    retention_duration = 90
}