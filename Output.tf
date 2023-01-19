output "Spoke_VM_IPs" {
    value = {
        public_ip = oci_core_instance.spoke.public_ip
        private_ip = oci_core_instance.spoke.private_ip
    }
}

output "OnPrem_Workload_VM_IPs" {
    value = {
        public_ip = oci_core_instance.onprem_workload_vm.public_ip
        private_ip = oci_core_instance.onprem_workload_vm.private_ip
    }
}

output "Multicloud_Workload_VM_IPs" {
    value = {
        public_ip = oci_core_instance.multicloud_workload_vm.public_ip
        private_ip = oci_core_instance.multicloud_workload_vm.private_ip
    }
}