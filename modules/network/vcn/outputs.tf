output "vcnid" {
  value = "${oci_core_vcn.ebsvcn.id}"
}
output "default_dhcp_id" {
  description = "ocid of default DHCP options"
  value = "${oci_core_vcn.ebsvcn.default_dhcp_options_id}"
}

output "igw_id" {
  value = "${oci_core_internet_gateway.igateway.id}"
}

output "natgtw_id" {
  value = "${oci_core_nat_gateway.natgateway.id}"
}
output "svcgtw_id" {
  value = "${oci_core_service_gateway.servicegateway.id}"
}

output "drggtw_id" {
  value = "${oci_core_drg.drg.id}"
}
