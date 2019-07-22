resource "oci_core_vcn" "ebsvcn" {
    #Required
    cidr_block = "${var.vcn_cidr}"
    compartment_id = "${var.compartment_ocid}"
    #Optional
    display_name = "${var.vcn_displayname}"
    dns_label = "${var.vcn_displayname}"
}

# Internet Gateway
resource "oci_core_internet_gateway" "igateway" {
    #Required
    compartment_id = "${var.compartment_ocid}"
    vcn_id = "${oci_core_vcn.ebsvcn.id}"
    #Optional
    enabled = "true"
    display_name = "${var.int_gateway_displayname}"
}

# NAT (Network Address Translation) Gateway
resource "oci_core_nat_gateway" "natgateway" {
    #Required
    compartment_id = "${var.compartment_ocid}"
    vcn_id = "${oci_core_vcn.ebsvcn.id}"
    #Optional
    block_traffic = "false"
    display_name = "${var.nat_gateway_displayname}"
}


# Service Gateway
resource "oci_core_service_gateway" "servicegateway" {
    #Required
    compartment_id = "${var.compartment_ocid}"
    services {
        #Required
        service_id = "${lookup(data.oci_core_services.object_storage.services[0], "id")}"
    }
    vcn_id = "${oci_core_vcn.ebsvcn.id}"

    #Optional
    display_name = "${var.srv_gateway_displayname}"
}

# Dynamic Routing Gateway (DRG)
resource "oci_core_drg" "drg" {
    #Required
    compartment_id = "${var.compartment_ocid}"
    #Optional
    display_name = "${var.drg_displayname}"
}

resource "oci_core_drg_attachment" "drg_attachment" {
    #Required
    drg_id = "${oci_core_drg.drg.id}"
    vcn_id = "${oci_core_vcn.ebsvcn.id}"

    #Optional
    display_name = "${var.drg_att_displayname}"
    #route_table_id = "${oci_core_route_table.test_route_table.id}"
}