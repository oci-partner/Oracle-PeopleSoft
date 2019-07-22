variable "enable_module" {}
variable "compartment_ocid" {}
variable "compute_instance_count" {}
variable "compute_instance_shape" {}
variable "compute_hostname_prefix" {}
variable "compute_image" {}
variable "compute_subnet" {
  type        = "list"
}
variable "availability_domain" {
  type        = "list"
}
variable "fault_domain" {
  type        = "list"
}
variable "AD" {
  type        = "list"
}
variable "timeout" {
  default     = "20m"
}
variable "compute_boot_volume_size_in_gb" {}
variable "compute_ssh_public_key" {}
variable "assign_public_ip" {}
