# Virtual Cloud Network (VCN) variables
variable "vcn_subnet_cidr" {}
variable "compartment_ocid" {}
variable "vcn_id" {}
variable "subnet_display_name" {}
variable "subnet_dns_label" {}
variable "private_subnet" {}
variable "subnet_route_table_id" {}
variable "subnet_security_list_ids" {
    type = "list"
}