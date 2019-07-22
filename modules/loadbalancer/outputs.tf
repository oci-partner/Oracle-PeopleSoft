output "public_ip" {
  value = "${element(oci_load_balancer.lb.ip_addresses,1)}"
  //value = "${oci_load_balancer.lb.ip_addresses}"
}
output "load_balancer_ocid" {
  value = "${oci_load_balancer.lb.id}"
}
output "backendset_name" {
  value = "${oci_load_balancer_backend_set.backendsets.name}"
}

