variable "compartment_ocid" {
    description = "Compartment name"
}
variable "availability_domain" {
    type        = "list"
}
variable "AD" {
    type= "list"
}
# Load Balancer variables
variable load_balancer_subnet {
    type        = "list"
}
variable load_balancer_name {}
variable load_balancer_shape {}
variable load_balancer_private {}
variable be_ip_addresses {
    type        = "list"
}
variable load_balancer_hostname {}
variable compute_instance_listen_port {}
variable load_balancer_listen_port {}
variable compute_instance_count {}