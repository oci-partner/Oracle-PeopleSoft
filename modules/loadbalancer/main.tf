# Load Balancer
resource "oci_load_balancer" "lb" {
  shape          = "${var.load_balancer_shape}"
  compartment_id = "${var.compartment_ocid}"
  subnet_ids     = ["${element(var.load_balancer_subnet, count.index)}"]
  display_name   = "${var.load_balancer_name}-ad${element(var.AD,count.index)}"
  is_private     = "${var.load_balancer_private}"
}

# Load Balancer Backendset
resource "oci_load_balancer_backend_set" "backendsets" {
  name             = "${var.load_balancer_name}-${element(var.AD,count.index)}-bes"
  load_balancer_id = "${oci_load_balancer.lb.id}"
  policy           = "ROUND_ROBIN"

  health_checker {
    port                = "${var.compute_instance_listen_port}"
    protocol            = "HTTP"
    response_body_regex = ".*"
    url_path            = "/"
  }

  session_persistence_configuration {
    cookie_name      = "*"
    disable_fallback = "true"
  }
}

# Load Balancer Backend
resource "oci_load_balancer_backend" "backend" {
  count            = "${length(var.AD) * var.compute_instance_count}"
  load_balancer_id = "${oci_load_balancer.lb.id}"
  backendset_name  = "${oci_load_balancer_backend_set.backendsets.name}"
  ip_address       = "${element(var.be_ip_addresses, count.index)}"
  port             = "${var.compute_instance_listen_port}"
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}

# Load Balancer Hostname
resource "oci_load_balancer_hostname" "hostname" {
  hostname         = "${var.load_balancer_hostname}"
  load_balancer_id = "${oci_load_balancer.lb.id}"
  name             = "${var.load_balancer_hostname}"
}

# Load Balancer Listener
resource "oci_load_balancer_listener" "lb-listener" {
  load_balancer_id         = "${oci_load_balancer.lb.id}"
  name                     = "${var.load_balancer_name}-lsnr"
  default_backend_set_name = "${oci_load_balancer_backend_set.backendsets.name}"
  hostname_names           = ["${oci_load_balancer_hostname.hostname.name}"]
  port                     = "${var.load_balancer_listen_port}"
  protocol                 = "HTTP"

  connection_configuration {
    idle_timeout_in_seconds = "2"
  }
}
