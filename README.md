# Using DRG to route certain traffic through centralized Network Firewall (and other traffic direct to Spoke)

This repository contains Terraform code and Ansible playbooks to deploy an advanced networking solution in Oracle Cloud Infrastructure (OCI), as described in the [High on Cloud blog post](https://highoncloud.co.uk/advanced-networking-drg/). This solution uses a Dynamic Routing Gateway (DRG) to route traffic through a centralized Network Firewall, while also enabling direct routing to a spoke VCN. It also demonstrates how to integrate on-premises and multicloud environments with OCI.

## Overview

The infrastructure deployed by this code includes:

*   **Compartments:**  A dedicated compartment for the demo resources.
*   **Virtual Cloud Networks (VCNs):**
    *   Hub VCN:  Hosts the Network Firewall and serves as the central point for routing traffic.
    *   Spoke VCN:  Represents a typical application environment.
    *   On-Premises VCN: Simulates an on-premises network.
    *   Multicloud VCN: Simulates a network in another cloud provider.
*   **Compute Instances:**
    *   On-Premises and Multicloud Libreswan VMs:  Simulate Customer-Premises Equipment (CPE) devices for establishing IPSec tunnels.
    *   On-Premises and Multicloud Workload VMs: Simulate workloads in the on-premises and multicloud environments.
    *   Spoke VM: A workload in the Spoke VCN.
*   **Dynamic Routing Gateway (DRG):**  A virtual router that provides a single point of entry and exit for network traffic.
*   **Network Firewall:**  A centralized firewall to inspect and control network traffic.
*   **IPSec Tunnels:**  Secure connections between OCI and the on-premises and multicloud environments.
*   **Logging:** Configured to capture traffic logs from the Network Firewall.

## Architecture Diagram

![image](https://github.com/user-attachments/assets/3306d62a-3ae8-4f70-b2c3-bfdab9f3ca3f)


## Files

*   `README.md`: This file.
*   `Compartments.tf`:  Defines the compartment used for the demo.
*   `Compute.tf`:  Creates the compute instances (VMs) for the solution.
*   `DRG.tf`: Configures the DRG, route tables, and attachments.
*   `Data.tf`:  Defines data sources used to retrieve information about existing OCI resources.
*   `IPSec.tf`:  Creates the IPSec connections, CPEs, and tunnel configurations.
*   `LibreswanSetup.tf`:  Uses `null_resource` and `local-exec` to trigger Ansible playbooks on the Libreswan VMs.
*   `Logging.tf`:  Sets up logging for the Network Firewall.
*   `Network.tf`:  Defines the VCNs, subnets, route tables, and other networking resources.
*   `NetworkFirewall.tf`: Deploys the Network Firewall and its policy.
*   `Output.tf`:  Prints the public and private IPs of the deployed VMs.
*   `ansible-vars.tf`: Creates a local file (`ansible-libreswan-vars.yml`) containing Terraform output values that are used by the Ansible playbooks.
*   `variables.tf`: Defines the input variables for the Terraform configuration.
*   `ansible/`: Contains the Ansible playbooks and related files.
    *   `ansible/multicloud-libreswan.j2`: Jinja2 template for the Multicloud Libreswan configuration file.
    *   `ansible/multicloud-libreswan.yml`: Ansible playbook to configure the Multicloud Libreswan instance.
    *   `ansible/multicloud_libreswan_secrets.j2`: Jinja2 template for the Multicloud Libreswan secrets file.
    *   `ansible/onprem-libreswan.j2`: Jinja2 template for the On-Premises Libreswan configuration file.
    *   `ansible/onprem-libreswan.yml`: Ansible playbook to configure the On-Premises Libreswan instance.
    *   `ansible/onprem_libreswan_secrets.j2`: Jinja2 template for the On-Premises Libreswan secrets file.
    *   `ansible/vpn_vars/`: Contains variable files specific to the VPN configurations.
        *   `ansible/vpn_vars/multicloud-tunnel.yml`: Variables for the Multicloud IPSec tunnel configuration.
        *   `ansible/vpn_vars/onprem-tunnel.yml`: Variables for the On-Premises IPSec tunnel configuration.

## Prerequisites

*   An Oracle Cloud Infrastructure account.
*   The OCI CLI installed and configured.
*   Terraform installed.
*   Ansible installed.
*   A public SSH key and corresponding private key.  The public key will be injected into the compute instances for SSH access.

## Usage

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/shjanjua/HOC_DRG-NFW-TF-Demo
    cd HOC_DRG-NFW-TF-Demo
    ```

2.  **Configure Terraform variables:**

    *   Create a `terraform.tfvars` file and populate it with the required variables.  See `variables.tf` for a list of variables.  Example:

        ```terraform
        tenancy_ocid         = "ocid1.tenancy.oc1..."
        user_ocid            = "ocid1.user.oc1..."
        fingerprint          = "xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx"
        private_api_key_path = "/path/to/your/oci_api_key.pem"
        region               = "us-phoenix-1"
        rootCompartment      = "ocid1.compartment.oc1..."
        public_key_path      = "/path/to/your/public_ssh_key.pub"
        private_key_path     = "/path/to/your/private_ssh_key"
        ```

    *   **Important:**  Replace the placeholder values with your actual OCI credentials and paths.

3.  **(Optional) Customize Ansible variables:**

    *   The Ansible playbooks use variables defined in `ansible/vpn_vars/` and `ansible-libreswan-vars.yml`. Review and customize these files as needed, particularly the IPSec tunnel parameters and CIDR blocks.

4.  **Initialize Terraform:**

    ```bash
    terraform init
    ```

5.  **Create the infrastructure:**

    ```bash
    terraform apply
    ```

    *   Review the plan and confirm the creation of the resources.

6.  **Access the VMs:**

    *   After the infrastructure is created, the public IPs of the VMs will be displayed in the Terraform output.  Use SSH to connect to the VMs.

## Configuration Notes

*   **Security Lists:** The provided configuration uses permissive security lists for demonstration purposes.  In a production environment, you should restrict access to specific ports and protocols.
*   **Libreswan Configuration:** The Ansible playbooks configure basic IPSec tunnels using Libreswan.  You may need to adjust the configuration based on your specific on-premises or multicloud environment.
*   **Network Firewall Policy:** The Network Firewall policy allows all traffic.  You should customize the policy to meet your security requirements.
*   **BGP:** The IPSec tunnels are configured with static routing. To use BGP dynamic routing, update the IPSec tunnel configuration and the Ansible playbooks accordingly.

## Troubleshooting

*   **Terraform apply fails:** Check your OCI credentials, permissions, and resource limits.
*   **IPSec tunnels not connecting:**  Verify the IPSec configuration on both the OCI side and the on-premises/multicloud side.  Check the Libreswan logs for errors.
*   **Network connectivity issues:**  Review the route tables, security lists, and Network Firewall policy.
