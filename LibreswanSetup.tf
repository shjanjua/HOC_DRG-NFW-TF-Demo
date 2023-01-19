resource "null_resource" "onprem-libreswan-config" {
  depends_on = [local_file.ansible-libreswan-vars]

  // Ansible integration
  provisioner "remote-exec" {
    inline = ["echo About to run Ansible on LIBRESWAN and waiting!"]

    connection {
      host        = "${oci_core_instance.onprem_libreswan.public_ip}"
      type        = "ssh"
      user        = "opc"
      private_key = file(var.private_key_path)
    }
  }

  provisioner "local-exec" {
    command = "sleep 30; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u opc -i '${oci_core_instance.onprem_libreswan.public_ip},' --private-key '${var.private_key_path}' ./ansible/onprem-libreswan.yml"
  }
}  

resource "null_resource" "multicloud-libreswan-config" {
  depends_on = [local_file.ansible-libreswan-vars]

  // Ansible integration
  provisioner "remote-exec" {
    inline = ["echo About to run Ansible on LIBRESWAN and waiting!"]

    connection {
      host        = "${oci_core_instance.multicloud_libreswan.public_ip}"
      type        = "ssh"
      user        = "opc"
      private_key = file(var.private_key_path)
    }
  }

  provisioner "local-exec" {
    command = "sleep 30; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u opc -i '${oci_core_instance.multicloud_libreswan.public_ip},' --private-key '${var.private_key_path}' ./ansible/multicloud-libreswan.yml"
  }
}  