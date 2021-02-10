resource "oci_load_balancer_load_balancer" "demotest_load_balancer" {
  compartment_id = var.compartment_ocid
  display_name = "demotest_load_balancer"
  shape = "Flexible"
  subnet_ids = [oci_core_subnet.lb_subnet.id]
}


resource "oci_load_balancer_certificate" "demotest_certificate" {
  certificate_name = "demotest_certificate"
  load_balancer_id = oci_load_balancer_load_balancer.demotest_load_balancer.id
}

resource "oci_load_balancer_listener" "demotest_listener" {
  default_backend_set_name = "BS-Wordpress"
  load_balancer_id = oci_load_balancer_load_balancer.demotest_load_balancer.id
  name = "demotest_listener"
  port = "80"
  protocol = "http"
}

resource "oci_load_balancer_backend_set" "demotest_backend_set" {
  health_checker {
    protocol = "http"
  }
  load_balancer_id = oci_load_balancer_load_balancer.demotest_load_balancer.id
  name = "BS-Wordpress"

  policy = "weight"
}