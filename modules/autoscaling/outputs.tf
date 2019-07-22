output "EBSInstanceConfiguration_ocid" {
  value = "${oci_core_instance_configuration.EBSInstanceConfiguration.*.id}"
}