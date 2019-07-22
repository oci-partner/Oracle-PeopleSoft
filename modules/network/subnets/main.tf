resource "oci_core_subnet" "subnet" {
    #Required
    cidr_block = "${var.vcn_subnet_cidr}"
    compartment_id = "${var.compartment_ocid}"
    vcn_id = "${var.vcn_id}"
    #Optional
    availability_domain = ""
    #dhcp_options_id = "${oci_core_dhcp_options.test_dhcp_options.id}"
    display_name = "${var.subnet_display_name}"
    dns_label = "${var.subnet_dns_label}"
    prohibit_public_ip_on_vnic = "${var.private_subnet}"
    route_table_id = "${var.subnet_route_table_id}"
    security_list_ids = ["${var.subnet_security_list_ids}"]
}