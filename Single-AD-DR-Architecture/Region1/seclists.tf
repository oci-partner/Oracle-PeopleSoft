resource "oci_core_security_list" "backupseclist" {
    #Required
    compartment_id = "${var.compartment_ocid}"
    vcn_id = "${module.create_network.vcnid}"
    #Optional
    display_name = "backupseclist"

    egress_security_rules {
        #Required
        destination_type = "SERVICE_CIDR_BLOCK"
        destination = "${lookup(data.oci_core_services.object_storage.services[0], "cidr_block")}"
        protocol = "6"
        stateless = "false"
        tcp_options {
            max = "443"
            min = "443"
        }
    }
}
resource "oci_core_security_list" "bastionseclist" {
    #Required
    compartment_id = "${var.compartment_ocid}"
    vcn_id = "${module.create_network.vcnid}"
    #Optional
    display_name = "bastionseclist"

    egress_security_rules {
        #Required
        destination = "0.0.0.0/0"
        protocol = "all"
        stateless = "false"
    }

    ingress_security_rules {
        #Required
        protocol = "6" // TCP number protocol
        source = "0.0.0.0/0"
        tcp_options {
            #Optional
            max = "22"
            min = "22"
        }
    }
}
resource "oci_core_security_list" "dbseclist" {
    #Required
    compartment_id = "${var.compartment_ocid}"
    vcn_id = "${module.create_network.vcnid}"
    #Optional
    display_name = "dbseclist"

    ingress_security_rules {
        protocol = "6" // TCP
        source = "${var.bastion_subnet_cidr_block}"
        tcp_options {
            min = "22"
            max = "22"
        }
    }

    ingress_security_rules {
        protocol = "6" // TCP
        source = "${var.app_subnet_cidr_block}"
        tcp_options {
            min = "1521"
            max = "1521"
        }
    }

    egress_security_rules {
        destination = "${var.app_subnet_cidr_block}"
        protocol = "6"
    }

    ingress_security_rules {
        source = "${var.database_subnet_cidr_block}"
        protocol = "6"
        tcp_options {
            max = "1521"
            min = "1521"
        }
    }

    ### HEXADATA LIST
    ingress_security_rules {
        source = "${var.database_subnet_cidr_block}"
        protocol = "6"
    }

    ingress_security_rules {
        source = "${var.database_subnet_cidr_block}"
        protocol = "1"
    }

    egress_security_rules {
        destination = "0.0.0.0/0"
        protocol = "6"
        stateless = "false"
    }

    egress_security_rules {
        destination = "0.0.0.0/0"
        protocol = "1"
        stateless = "false"
    }
}
resource "oci_core_security_list" "appseclist" {
    #Required
    compartment_id = "${var.compartment_ocid}"
    vcn_id = "${module.create_network.vcnid}"
    #Optional
    display_name = "appseclist"

    ingress_security_rules {
        protocol  = "6" // TCP
        source    = "${var.bastion_subnet_cidr_block}"
        tcp_options {
            max = "22"
            min = "22"
        }
    }

    ingress_security_rules {
        protocol = "6"
        source = "${var.bastion_subnet_cidr_block}"
        tcp_options {
            max = "${var.tools_instance_listen_port}"
            min = "${var.tools_instance_listen_port}"
        }
    }

    ingress_security_rules {
        protocol  = "6" // TCP
        source    = "${var.public_lb_subnet_cidr_block}"
        tcp_options {
            max = "${var.load_balancer_listen_port}"
            min = "${var.load_balancer_listen_port}"
        }
    }

    ingress_security_rules {
        protocol  = "6" // TCP
        source    = "${var.public_lb_subnet_cidr_block}"
        tcp_options {
            max = "8443"
            min = "8443"
        }
    }

    ingress_security_rules {
        protocol  = "6" // TCP
        source    = "${var.private_lb_subnet_cidr_block}"
        tcp_options {
            max = "${var.load_balancer_listen_port}"
            min = "${var.load_balancer_listen_port}"
        }
    }

    ingress_security_rules {
        protocol  = "6" // TCP
        source    = "${var.private_lb_subnet_cidr_block}"
        tcp_options {
            max = "8443"
            min = "8443"
        }
    }

    egress_security_rules {
        protocol = "6"
        destination = "0.0.0.0/0"
    }

    ingress_security_rules {
        protocol = "6"
        source = "${var.app_subnet_cidr_block}"
    }
}

resource "oci_core_security_list" "publbseclist" {
    #Required
    compartment_id = "${var.compartment_ocid}"
    vcn_id = "${module.create_network.vcnid}"
    #Optional
    display_name = "publbseclist"

    ingress_security_rules {
        source = "0.0.0.0/0"
        protocol = "6"

        tcp_options {
            max = "443"
            min = "443"
        }
    }

    ingress_security_rules {
        source = "0.0.0.0/0"
        protocol = "6"

        tcp_options {
            max = "8000"
            min = "8000"
        }
    }

    ingress_security_rules {
        source = "0.0.0.0/0"
        protocol = "6"

        tcp_options {
            max = "8448"
            min = "8448"
        }
    }

    egress_security_rules {
        destination = "${var.app_subnet_cidr_block}"
        protocol = "6"
        tcp_options {
            min = "${var.load_balancer_listen_port}"
            max = "${var.load_balancer_listen_port}"
        }
    }

    egress_security_rules {
        destination = "${var.app_subnet_cidr_block}"
        protocol = "6"
        tcp_options {
            min = "8448"
            max = "8448"
        }
    }
}
resource "oci_core_security_list" "privlbseclist" {
    #Required
    compartment_id = "${var.compartment_ocid}"
    vcn_id = "${module.create_network.vcnid}"
    #Optional
    display_name = "privlbseclist"

    ingress_security_rules {
        source = "${var.onpremises_network_cidr_block}"
        protocol = "6"
        stateless = "false"

        tcp_options {
            max = "443"
            min = "443"
        }
    }

    ingress_security_rules {
        source = "${var.onpremises_network_cidr_block}"
        protocol = "6"
        stateless = "false"

        tcp_options {
            max = "8888"
            min = "8888"
        }
    }

    egress_security_rules {
        destination = "${var.app_subnet_cidr_block}"
        protocol = "6"
        tcp_options {
            min = "${var.load_balancer_listen_port}"
            max = "${var.load_balancer_listen_port}"
        }
    }

    egress_security_rules {
        destination = "${var.app_subnet_cidr_block}"
        protocol = "6"
        tcp_options {
            min = "8448"
            max = "8448"
        }
    }
}
resource "oci_core_security_list" "fssseclist" {
    #Required
    compartment_id = "${var.compartment_ocid}"
    vcn_id = "${module.create_network.vcnid}"
    #Optional
    display_name = "fssseclist"

    ingress_security_rules {
        protocol  = "6" // TCP
        source    = "${var.app_subnet_cidr_block}"
        stateless = "false"

        tcp_options {
            max = "2050"
            min = "2048"
        }
    }

    ingress_security_rules {
        protocol  = "6" // TCP
        source    = "${var.app_subnet_cidr_block}"
        stateless = "false"

        tcp_options {
            max = "111"
            min = "111"
        }
    }

    ingress_security_rules {
        protocol  = "17" // UDP
        source    = "${var.app_subnet_cidr_block}"
        stateless = "false"

        udp_options {
            max = "2048"
            min = "2048"
        }
    }

    ingress_security_rules {
        protocol  = "17" // UDP
        source    = "${var.app_subnet_cidr_block}"
        stateless = "false"

        udp_options {
            max = "111"
            min = "111"
        }
    }

    egress_security_rules {
        #Required
        destination = "${var.app_subnet_cidr_block}"
        protocol = "6" // TCP
        stateless = "false"
        tcp_options {
            max = "2050"
            min = "2048"
        }
    }

    egress_security_rules {
        #Required
        destination = "${var.app_subnet_cidr_block}"
        protocol = "6" // TCP
        stateless = "false"
        tcp_options {
            max = "111"
            min = "111"
        }
    }

    egress_security_rules {
        #Required
        destination = "${var.app_subnet_cidr_block}"
        protocol = "17" // UDP
        stateless = "false"
        udp_options {
            max = "111"
            min = "111"
        }
    }
}