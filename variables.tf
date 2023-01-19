variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_api_key_path" {}
variable "region" {}
variable "rootCompartment" {}
variable "onprem_vcn_cidr" {
    default = "172.0.0.0/24"
}
variable "onprem_vpn_sub_cidr" {
    default = "172.0.0.0/25"
}
variable "onprem_wl_sub_cidr" {
    default = "172.0.0.128/25"
}
variable "multicloud_vcn_cidr" {
    default = "192.168.0.0/24"
}
variable "multicloud_vpn_sub_cidr" {
    default = "192.168.0.0/25"
}
variable "multicloud_wl_sub_cidr" {
    default = "192.168.0.128/25"
}
variable "hub_cidr" {
    default = "10.0.0.0/24"
}
variable "spoke_cidr" {
    default = "10.0.1.0/24"
}
variable public_key_path {}
variable private_key_path {}