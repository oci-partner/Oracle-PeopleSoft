resource "oci_core_route_table" "bastion_rt" {
    #Required
    compartment_id = "${var.compartment_ocid}"
    route_rules {
        #Required
        network_entity_id = "${module.create_network.igw_id}"

        #Optional
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
    }
    vcn_id = "${module.create_network.vcnid}"

    #Optional
    display_name = "${var.bastion_displayname_rt}"
}
resource "oci_core_route_table" "database_rt" {
    #Required
    compartment_id = "${var.compartment_ocid}"
    route_rules {
        #Required
        network_entity_id = "${module.create_network.natgtw_id}"
        #Optional
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
    }

    route_rules {
        destination_type = "SERVICE_CIDR_BLOCK"
        destination = "${lookup(data.oci_core_services.object_storage.services[0], "cidr_block")}"
        network_entity_id = "${module.create_network.svcgtw_id}"
    }
    vcn_id = "${module.create_network.vcnid}"
    #Optional
    display_name = "${var.database_displayname_rt}"
}
resource "oci_core_route_table" "app_rt" {
    #Required
    compartment_id = "${var.compartment_ocid}"
    route_rules {
        #Required
        network_entity_id = "${module.create_network.natgtw_id}"
        #Optional
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
    }

    vcn_id = "${module.create_network.vcnid}"
    #Optional
    display_name = "${var.app_displayname_rt}"
}
resource "oci_core_route_table" "fss_rt" {
    #Required
    compartment_id = "${var.compartment_ocid}"
    route_rules {
        #Required
        network_entity_id = "${module.create_network.natgtw_id}"
        #Optional
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
    }

    vcn_id = "${module.create_network.vcnid}"
    #Optional
    display_name = "${var.fss_displayname_rt}"
}
resource "oci_core_route_table" "drg_rt" {
    #Required
    compartment_id = "${var.compartment_ocid}"
    route_rules {
        #Required
        network_entity_id = "${module.create_network.drggtw_id}"
        #Optional
        destination = "${var.onpremises_network_cidr_block}"
        destination_type = "CIDR_BLOCK"
    }

    vcn_id = "${module.create_network.vcnid}"
    #Optional
    display_name = "${var.drg_displayname_rt}"
}