variable "compartment_ocid" {}
variable "availability_domain" {}

resource "oci_core_instance_pool" "demotest_instance_pool" {
  compartment_id = var.compartment_ocid
  instance_configuration_id = "ocid1.instanceconfiguration.oc1.ap-seoul-1.aaaaaaaadvpk457opu4r56dulzqfrrltugsfi67wzveskp6n3ck7vrzwuysq"
  
  placement_configurations {
    availability_domain = var.availability_domain
    primary_subnet_id = "ocid1.subnet.oc1.ap-seoul-1.aaaaaaaasftmvug6hm2mxnvjn3r4scwidury3abakqbls7e2ett6e663ornq"
  }
  size = 1

  display_name = "demotest_instance_pool"
  load_balancers {
    backend_set_name = "BS-Wordpress"
    load_balancer_id = "ocid1.loadbalancer.oc1.ap-seoul-1.aaaaaaaabwdzpcqollovjdqtkj5yxdgxnfpo24mmyi6uuynf2wr5g5sublyq"
    port = 80
    vnic_selection = "PrimaryVnic"
  }
}