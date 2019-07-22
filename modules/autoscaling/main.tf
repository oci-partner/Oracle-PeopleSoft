resource "oci_core_instance_configuration" "EBSInstanceConfiguration" {
    count = "${var.enable_autoscaling_pools == "true" ? 1 : 0}"
    compartment_id = "${var.compartment_ocid}"
    display_name   = "${var.displayName}-ic"

    instance_details {
        instance_type = "compute"

        launch_details {
            compartment_id = "${var.compartment_ocid}"
            ipxe_script    = "ipxeScript"
            shape          = "${var.instance_shape}"
            display_name   = "EBS-instanceconfiguration-ld"

            create_vnic_details {
                assign_public_ip       = "${var.assign_public_ip}"
                display_name           = "EBS-instanceconfiguration-vnic"
                skip_source_dest_check = "false"
            }

            metadata {
                ssh_authorized_keys = "${trimspace(file("${var.compute_ssh_public_key}"))}"
                //user_data           = "${base64encode(data.template_file.bootstrap.rendered)}"
            }  

            source_details {
                source_type = "image"
                image_id    = "${var.instance_image_ocid}"
            }
        }
    }
}
resource "oci_core_instance_pool" "EBSInstancePool" {
    count = "${var.enable_autoscaling_pools == "true" ? length(var.AD) : 0}"
    compartment_id            = "${var.compartment_ocid}"
    //instance_configuration_id = "${oci_core_instance_configuration.EBSInstanceConfiguration.id}"
    instance_configuration_id = "${element(oci_core_instance_configuration.EBSInstanceConfiguration.*.id, 1)}"
    size                      = "${var.initialCapacity}"
    state                     = "RUNNING"
    display_name              = "${var.displayName}-instancepool-ad${count.index + 1}"
    
    placement_configurations {
        availability_domain = "${element(var.AD, count.index)}"
        primary_subnet_id   = "${var.subNet_ocid}"
    }
}

resource "oci_autoscaling_auto_scaling_configuration" "EBSAutoScalingConfiguration" {
    count = "${var.enable_autoscaling_pools == "true" ? length(var.AD) : 0}"
    auto_scaling_resources {
        id = "${element(oci_core_instance_pool.EBSInstancePool.*.id, count.index)}"
        type = "instancePool"
    }
    compartment_id = "${var.compartment_ocid}"
    policies {
        capacity {
            initial = "${var.initialCapacity}"
            max = "${var.maxCapacity}"
            min = "${var.minCapacity}"
        }
        policy_type = "threshold"
        rules {
            action {
                type = "CHANGE_COUNT_BY"
                value = "1"
            }
            metric {
                metric_type = "CPU_UTILIZATION"
                threshold {
                    operator = "GTE"
                    value = "${var.scaleUpCPUthreshold}"
                }
            }
            display_name = "${var.displayName}-scaleout-ad${count.index + 1}"
        }
        rules {
            action {
                type = "CHANGE_COUNT_BY"
                value = "-1"
            }
            metric {
                metric_type = "CPU_UTILIZATION"
                threshold {
                    operator = "LTE"
                    value = "${var.scaleInCPUthreshold}"
                }
            }
            display_name = "${var.displayName}-scalein-ad${count.index + 1}"
        }
        display_name = "${var.displayName}-policy-ad${count.index + 1}"
    }
    cool_down_in_seconds = "300"
    display_name = "${var.displayName}-autoscaling-ad${count.index + 1}"
    is_enabled = "true"
}