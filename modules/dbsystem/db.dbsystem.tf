resource "oci_database_db_system" "database" {
    #Required
    count = "${length(var.availability_domain)}"

    availability_domain = "${element(var.availability_domain, count.index)}"
    compartment_id = "${var.compartment_ocid}"
    cpu_core_count = "${lookup(data.oci_database_db_system_shapes.db_system_shapes.db_system_shapes[0], "minimum_core_count")}"
    database_edition = "${var.db_edition}"
    db_home {
        #Required
        database {
            #Required
            db_name = "${var.db_name}"
            db_workload = "${var.db_workload}"
            admin_password = "${var.db_admin_password}"
            character_set = "${var.db_characterset}"
            ncharacter_set = "${var.db_nls_characterset}"
            pdb_name = "${var.db_pdb_name}"
            #Optional
            #backup_id = "${oci_database_backup.test_backup.id}"
            #backup_tde_password = "${var.db_system_db_home_database_backup_tde_password}"
            #db_backup_config {

                #Optional
                #auto_backup_enabled = "${var.db_system_db_home_database_db_backup_config_auto_backup_enabled}"
                #recovery_window_in_days = "${var.db_system_db_home_database_db_backup_config_recovery_window_in_days}"
            #}
            #defined_tags = "${var.db_system_db_home_database_defined_tags}"
            #freeform_tags = "${var.db_system_db_home_database_freeform_tags}"
        }

        #Optional
        db_version = "${var.db_version}"
        display_name = "${var.db_name}"
    }
    shape = "${var.db_instance_shape}"
    node_count = "${var.db_node_count}"
    data_storage_size_in_gb = "${var.db_size_in_gb}"
    license_model = "${var.db_license_model}"
    disk_redundancy = "${var.db_disk_redundancy}"
    subnet_id = "${element(var.db_subnet, count.index)}"
    ssh_public_keys = ["${trimspace(file("${var.db_ssh_public_key}"))}"]
    display_name = "${var.db_hostname_prefix}${element(var.AD,count.index)}${count.index + 1}"
    hostname = "${var.db_hostname_prefix}${element(var.AD,count.index)}${count.index + 1}"

    #Optional
    #backup_subnet_id = "${oci_database_backup_subnet.test_backup_subnet.id}"
    #cluster_name = "${var.db_system_cluster_name}"
    #data_storage_percentage = "${var.db_system_data_storage_percentage}"
    #defined_tags = {"Operations.CostCenter"= "42"}
    #domain = "${var.db_system_domain}"
    #fault_domains = "${var.db_system_fault_domains}"
    #freeform_tags = {"Department"= "Finance"}
    #source = "${var.db_system_source}"
    #sparse_diskgroup = "${var.db_system_sparse_diskgroup}"
    #time_zone = "${var.db_system_time_zone}"
}