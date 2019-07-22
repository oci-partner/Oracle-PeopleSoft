output "AppsPrvIPs" {
  description = "Application private IPs"
  value       = ["${oci_core_instance.compute.*.private_ip}"]
}
