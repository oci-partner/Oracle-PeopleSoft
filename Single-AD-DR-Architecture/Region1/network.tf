module "create_network" {
  source = "../modules/network/vcn"
    
  compartment_ocid = "${var.compartment_ocid}"
  vcn_cidr = "${var.vcn_cidr}"
  vcn_displayname = "${var.vcn_displayname}"
  int_gateway_displayname = "${var.int_gateway_displayname}"
  nat_gateway_displayname = "${var.nat_gateway_displayname}"
  srv_gateway_displayname = "${var.srv_gateway_displayname}"
  drg_displayname = "${var.drg_displayname}"
  drg_att_displayname = "${var.drg_att_displayname}"
}
### SUBNETS
module "create_bastion_subnet" {
  source = "../modules/network/subnets"
  
  vcn_subnet_cidr = "${var.bastion_subnet_cidr_block}"
  compartment_ocid = "${var.compartment_ocid}"
  vcn_id = "${module.create_network.vcnid}"
  subnet_display_name = "bastionnet"
  subnet_dns_label = "bastionnet"
  private_subnet = "false"
  subnet_route_table_id = "${oci_core_route_table.bastion_rt.id}"
  subnet_security_list_ids = ["${oci_core_security_list.bastionseclist.id}"]
}
module "create_backupnet_subnet" {
  source = "../modules/network/subnets"

  vcn_subnet_cidr = "${var.backup_subnet_cidr_block}"
  compartment_ocid = "${var.compartment_ocid}"
  vcn_id = "${module.create_network.vcnid}"
  subnet_display_name = "backupnet"
  subnet_dns_label = "backupnet"
  private_subnet = "true"
  subnet_route_table_id = "${oci_core_route_table.database_rt.id}"
  subnet_security_list_ids = ["${oci_core_security_list.backupseclist.id}"]  
}
module "create_appnet_subnet" {
  source = "../modules/network/subnets"

  vcn_subnet_cidr = "${var.app_subnet_cidr_block}"
  compartment_ocid = "${var.compartment_ocid}"
  vcn_id = "${module.create_network.vcnid}"
  subnet_display_name = "appnet"
  subnet_dns_label = "appnet"
  private_subnet = "true"
  subnet_route_table_id = "${oci_core_route_table.app_rt.id}"
  subnet_security_list_ids = ["${oci_core_security_list.appseclist.id}"]  
}
module "create_lbsubnetpub_subnet" {
  source = "../modules/network/subnets"

  vcn_subnet_cidr = "${var.public_lb_subnet_cidr_block}"
  compartment_ocid = "${var.compartment_ocid}"
  vcn_id = "${module.create_network.vcnid}"
  subnet_display_name = "lbsubnetpub"
  subnet_dns_label = "lbsubnetpub"
  private_subnet = "false"
  subnet_route_table_id = "${oci_core_route_table.bastion_rt.id}"
  subnet_security_list_ids = ["${oci_core_security_list.publbseclist.id}"]  
}
module "create_lbsubnetpriv_subnet" {
  source = "../modules/network/subnets"

  vcn_subnet_cidr = "${var.private_lb_subnet_cidr_block}"
  compartment_ocid = "${var.compartment_ocid}"
  vcn_id = "${module.create_network.vcnid}"
  subnet_display_name = "lbsubnetpriv"
  subnet_dns_label = "lbsubnetpriv"
  private_subnet = "true"
  subnet_route_table_id = "${oci_core_route_table.drg_rt.id}"
  subnet_security_list_ids = ["${oci_core_security_list.privlbseclist.id}"]  
}
module "create_dbnet_subnet" {
  source = "../modules/network/subnets"

  vcn_subnet_cidr = "${var.database_subnet_cidr_block}"
  compartment_ocid = "${var.compartment_ocid}"
  vcn_id = "${module.create_network.vcnid}"
  subnet_display_name = "dbnet"
  subnet_dns_label = "dbnet"
  private_subnet = "true"
  subnet_route_table_id = "${oci_core_route_table.database_rt.id}"
  subnet_security_list_ids = ["${oci_core_security_list.dbseclist.id}"] 
}
module "create_fssnet_subnet" {
  source = "../modules/network/subnets"

  vcn_subnet_cidr = "${var.filestorage_subnet_cidr_block}"
  compartment_ocid = "${var.compartment_ocid}"
  vcn_id = "${module.create_network.vcnid}"
  subnet_display_name = "fssnet"
  subnet_dns_label = "fssnet"
  private_subnet = "true"
  subnet_route_table_id = "${oci_core_route_table.fss_rt.id}"
  subnet_security_list_ids = ["${oci_core_security_list.fssseclist.id}"]
}
