module "create_bastion" {
    source = "../modules/bastion"
    compartment_ocid        = "${var.compartment_ocid}"
    AD                      = "${var.AD}"
    availability_domain     = ["${data.template_file.deployment_ad.*.rendered}"]
    bastion_hostname_prefix = "${var.env_prefix}-bastion" //${substr(var.region, 3, 3)}"
    bastion_image           = "${data.oci_core_images.InstanceImageOCID.images.0.id}"
    bastion_instance_shape  = "${var.bastion_instance_shape}"
    bastion_subnet          = ["${module.create_bastion_subnet.subnetid}"]
    bastion_ssh_public_key  = "${var.bastion_ssh_public_key}"
}

module "create_app" {
    source  = "../modules/compute"

    compartment_ocid                = "${var.compartment_ocid}"
    AD                              = "${var.AD}"
    availability_domain             = ["${data.template_file.deployment_ad.*.rendered}"]
    fault_domain                    = ["${sort(data.template_file.deployment_fd.*.rendered)}"]
    compute_instance_count          = "${var.app_instance_count}"
    compute_hostname_prefix         = "${var.env_prefix}-app" //${substr(var.region, 3, 3)}"
    compute_image                   = "${data.oci_core_images.InstanceImageOCID.images.0.id}"
    compute_instance_shape          = "${var.app_instance_shape}"
    compute_subnet                  = ["${module.create_appnet_subnet.subnetid}"]
    compute_ssh_public_key          = "${var.ssh_public_key}"
    compute_ssh_private_key         = "${var.ssh_private_key}"
    bastion_ssh_private_key         = "${var.bastion_ssh_private_key}"
    bastion_public_ip               = "${module.create_bastion.Bastion_Public_IPs[0]}"
    compute_instance_listen_port    = "${var.app_instance_listen_port}"
    fss_instance_prefix             = "${var.env_prefix}-fss" //${substr(var.region, 3, 3)}"
    fss_subnet                      = ["${module.create_fssnet_subnet.subnetid}"]
    fss_primary_mount_path          = "${var.fss_primary_mount_path}"
    fss_limit_size_in_gb            = "${var.fss_limit_size_in_gb}"
    compute_instance_user           = "${var.compute_instance_user}"
    bastion_user                    = "${var.bastion_user}"
    compute_boot_volume_size_in_gb  = "${var.compute_boot_volume_size_in_gb}"
    timezone                        = "${var.timezone}"
}

module "create_web" {
    source = "../modules/instance"

    enable_module = "${var.enable_web_module}"
    compartment_ocid = "${var.compartment_ocid}"
    AD = "${var.AD}"
    availability_domain = ["${data.template_file.deployment_ad.*.rendered}"]
    fault_domain = ["${sort(data.template_file.deployment_fd.*.rendered)}"]
    compute_instance_count = "${var.web_instance_count}"
    compute_hostname_prefix = "${var.env_prefix}-web"
    compute_image = "${data.oci_core_images.InstanceImageOCID.images.0.id}"
    compute_instance_shape = "${var.web_instance_shape}"
    compute_subnet = ["${module.create_appnet_subnet.subnetid}"]
    compute_ssh_public_key = "${var.ssh_public_key}"
    compute_boot_volume_size_in_gb = "${var.compute_boot_volume_size_in_gb}"
    assign_public_ip = "false"
}

module "create_tools" {
    source = "../modules/instance"

    enable_module = "${var.enable_tools_module}"
    compartment_ocid = "${var.compartment_ocid}"
    AD = "${var.AD}"
    availability_domain = ["${data.template_file.deployment_ad.*.rendered}"]
    fault_domain = ["${sort(data.template_file.deployment_fd.*.rendered)}"]
    compute_instance_count = "${var.tools_instance_count}"
    compute_hostname_prefix = "${var.env_prefix}-tools"
    compute_image = "${data.oci_core_images.InstanceImageOCID.images.0.id}"
    compute_instance_shape = "${var.tools_instance_shape}"
    compute_subnet = ["${module.create_appnet_subnet.subnetid}"]
    compute_ssh_public_key = "${var.ssh_public_key}"
    compute_boot_volume_size_in_gb = "${var.compute_boot_volume_size_in_gb}"
    assign_public_ip = "false"
}

module "create_elastic_search" {
    source = "../modules/instance"

    enable_module = "${var.enable_es_module}"
    compartment_ocid = "${var.compartment_ocid}"
    AD = "${var.AD}"
    availability_domain = ["${data.template_file.deployment_ad.*.rendered}"]
    fault_domain = ["${sort(data.template_file.deployment_fd.*.rendered)}"]
    compute_instance_count = "${var.es_instance_count}"
    compute_hostname_prefix = "${var.env_prefix}-elastic-search"
    compute_image = "${data.oci_core_images.InstanceImageOCID.images.0.id}"
    compute_instance_shape = "${var.es_instance_shape}"
    compute_subnet = ["${module.create_appnet_subnet.subnetid}"]
    compute_ssh_public_key = "${var.ssh_public_key}"
    compute_boot_volume_size_in_gb = "${var.compute_boot_volume_size_in_gb}"
    assign_public_ip = "false"
}

/*
module "create_db" {
    source  = "../modules/dbsystem"

    compartment_ocid      = "${var.compartment_ocid}"
    AD                    = "${var.AD}"
    availability_domain   = ["${data.template_file.deployment_ad.*.rendered}"]
    db_edition            = "${var.db_edition}"
    db_instance_shape     = "${var.db_instance_shape}"
    db_node_count         = "${var.db_node_count}"
    db_hostname_prefix    = "${var.env_prefix}-db" //${substr(var.region, 3, 3)}"
    db_size_in_gb         = "${var.db_size_in_gb}"
    db_license_model      = "${var.db_license_model}"
    db_subnet             = ["${module.create_dbnet_subnet.subnetid}"]
    db_ssh_public_key     = "${var.ssh_public_key}"
    db_admin_password     = "${var.db_admin_password}"
    db_name               = "${var.db_name}"
    db_characterset       = "${var.db_characterset}"
    db_nls_characterset   = "${var.db_nls_characterset}"
    db_version            = "${var.db_version}"
    db_pdb_name           = "${var.db_pdb_name}"
}*/

module "create_public_lb" {
    source  = "../modules/loadbalancer"

    compartment_ocid              = "${var.compartment_ocid}"
    AD                            = "${var.AD}"
    availability_domain           = ["${data.template_file.deployment_ad.*.rendered}"]
    load_balancer_shape           = "${var.load_balancer_shape}"
    load_balancer_subnet          = ["${module.create_lbsubnetpub_subnet.subnetid}"]
    load_balancer_name            = "${var.env_prefix}-publb" //${substr(var.region, 3, 3)}"
    load_balancer_hostname        = "${var.public_load_balancer_hostname}"
    load_balancer_listen_port     = "${var.load_balancer_listen_port}"
    compute_instance_listen_port  = "${var.web_instance_listen_port}"
    compute_instance_count        = "${var.web_instance_count}"
    be_ip_addresses               = ["${module.create_web.AppsPrvIPs}"]
    load_balancer_private         = "false"
}

module "create_private_lb" {
    source  = "../modules/loadbalancer"

    compartment_ocid              = "${var.compartment_ocid}"
    AD                            = "${var.AD}"
    availability_domain           = ["${data.template_file.deployment_ad.*.rendered}"]
    load_balancer_shape           = "${var.load_balancer_shape}"
    load_balancer_subnet          = ["${module.create_lbsubnetpriv_subnet.subnetid}"]
    load_balancer_name            = "${var.env_prefix}-prilb" //${substr(var.region, 3, 3)}"
    load_balancer_hostname        = "${var.private_load_balancer_hostname}"
    load_balancer_listen_port     = "${var.load_balancer_listen_port}"
    compute_instance_listen_port  = "${var.web_instance_listen_port}"
    compute_instance_count        = "${var.web_instance_count}"
    be_ip_addresses               = ["${module.create_web.AppsPrvIPs}"]
    load_balancer_private         = "true"
}

module "create_autoscale_apps" {
    source = "../modules/autoscaling"

    enable_autoscaling_pools = "${var.enable_autoscaling_pools}"
    displayName = "${var.autoscale_displayName}-apps"
    compartment_ocid = "${var.compartment_ocid}"
    AD = ["${data.template_file.deployment_ad.*.rendered}"]
    instance_shape = "${var.app_instance_shape}"
    instance_image_ocid = "${data.oci_core_images.InstanceImageOCID.images.0.id}"
    subNet_ocid = "${module.create_appnet_subnet.subnetid}"
    initialCapacity = "${var.initialCapacity}"
    maxCapacity = "${var.maxCapacity}"
    minCapacity = "${var.minCapacity}"
    scaleUpCPUthreshold = "${var.scaleUpCPUthreshold}"
    scaleInCPUthreshold = "${var.scaleInCPUthreshold}"
    backend_set_name = ""
    load_balancer_id = ""
    port = ""
    compute_ssh_public_key = "${var.ssh_public_key}"
    assign_public_ip = "false"
}

module "create_waas_policy" {
    source = "../modules/waas"

    enable_waas = "${var.enable_waas}"
    compartment_ocid = "${var.compartment_ocid}"
    public_load_balancer_hostname = "${var.public_load_balancer_hostname}"
    waas_policy_display_name = "${var.waas_policy_display_name}"
    URI = "${module.create_public_lb.public_ip}"
    public_allow_url = "${var.public_allow_url}"
    whitelist = ["${var.whitelist}"]
}