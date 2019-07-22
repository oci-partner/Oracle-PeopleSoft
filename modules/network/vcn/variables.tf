variable "compartment_ocid" {}
variable "vcn_cidr" {}
variable "vcn_displayname" {}
variable "int_gateway_displayname" {}
variable "nat_gateway_displayname" {}
variable "srv_gateway_displayname" {}
variable "drg_displayname" {}
variable "drg_att_displayname" {}
data "oci_core_services" "object_storage" {
	filter {
		name = "name"
		values = [".*Object.*Storage"]
		regex = true
	}
}

