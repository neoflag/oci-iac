variable "compartment_ocid" {}
variable "availability_domain" {}

resource "oci_core_vcn" "vcn_demotest" {
  cidr_block     = "10.0.0.0/16"
  dns_label      = "vcn02060902"
  compartment_id = var.compartment_ocid
  display_name   = "vcn02060902"
}

resource "oci_core_security_list" "lb_security_list" {
  compartment_id = var.compartment_ocid
  vcn_id = oci_core_vcn.vcn_demotest.id

  display_name = "LB Security List"
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol = "All"
    stateless = false
  }

  ingress_security_rules {
    protocol = "6"
    source = "0.0.0.0/0"
    stateless = false
    tcp_options {
      min=80
      max=80
    }
  }

  ingress_security_rules {
    protocol = "6"
    source = "0.0.0.0/0"
    stateless = false
    tcp_options {
      min=443
      max=443
    }
  }
}

resource "oci_core_security_list" "db_security_list" {
  compartment_id = var.compartment_ocid
  vcn_id = oci_core_vcn.vcn_demotest.id

  display_name = "DB Security List"
  egress_security_rules {
    destination = "10.0.0.0/16"
    protocol = "All"
    stateless = false
  }

  ingress_security_rules {
    protocol = "6"
    source = "10.0.0.0/16"
    stateless = false
    tcp_options {
      min=3306
      max=3306
    }
  }
}

resource "oci_core_security_list" "app_security_list" {
  compartment_id = var.compartment_ocid
  vcn_id = oci_core_vcn.vcn_demotest.id

  display_name = "APP Security List"
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol = "All"
    stateless = false
  }

  ingress_security_rules {
    protocol = "6"
    source = "0.0.0.0/0"
    stateless = false
    tcp_options {
      min=22
      max=22
    }
  }

  ingress_security_rules {
    protocol = "1"
    source = "0.0.0.0/0"
    stateless = false
    icmp_options {
      type = 3
      code = 4
    }
  }

  ingress_security_rules {
    protocol = "1"
    source = "10.0.0.0/16"
    stateless = false
    icmp_options {
      type = 3
    }
  }

  ingress_security_rules {
    protocol = "6"
    source = "10.0.0.0/16"
    stateless = false
  }

  ingress_security_rules {
    protocol = "6"
    source = "10.0.10.0/24"
    stateless = false
  }


  ingress_security_rules {
    protocol = "6"
    source = "0.0.0.0/0"
    stateless = false
    tcp_options {
      min=80
      max=80
    }
  }

  ingress_security_rules {
    protocol = "6"
    source = "0.0.0.0/0"
    stateless = false
    tcp_options {
      min=443
      max=443
    }
  }

  ingress_security_rules {
    protocol = "17"
    source = "10.0.0.0/16"
    stateless = false
    udp_options {
      min=2048
      max=2048
    }
  }

  ingress_security_rules {
    protocol = "17"
    source = "10.0.0.0/16"
    stateless = false
    udp_options {
      min=111
      max=111
    }
  }
}

resource "oci_core_dhcp_options" "default_dhcp_options" {
  compartment_id = var.compartment_ocid
  vcn_id = oci_core_vcn.vcn_demotest.id

  options {
    type = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }

  options {
    type = "SearchDomain"
    search_domain_names = [ "vcn02060902.oraclevcn.com" ]
  }

  display_name = "Default DHCP Options"
}

resource "oci_core_internet_gateway" "default_internet_gateway" {
  compartment_id = var.compartment_ocid
  vcn_id = oci_core_vcn.vcn_demotest.id
  display_name = "Internet Gateway vcn"
}

resource "oci_core_route_table" "default_route_table" {
  compartment_id = var.compartment_ocid
  vcn_id = oci_core_vcn.vcn_demotest.id
  display_name = "Default Route Table"

  route_rules {
    network_entity_id = oci_core_internet_gateway.default_internet_gateway.id
    destination = "0.0.0.0/0"
  }
}

resource "oci_core_subnet" "lb_subnet" {
  cidr_block = "10.0.10.0/24"
  compartment_id = var.compartment_ocid
  vcn_id = oci_core_vcn.vcn_demotest.id

  dhcp_options_id = oci_core_dhcp_options.default_dhcp_options.id
  display_name = "LB Subnet"
  dns_label = "lbsubnet"
  route_table_id = oci_core_route_table.default_route_table.id
  security_list_ids = [oci_core_security_list.lb_security_list.id]
}

resource "oci_core_subnet" "app_subnet" {
  cidr_block = "10.0.1.0/24"
  compartment_id = var.compartment_ocid
  vcn_id = oci_core_vcn.vcn_demotest.id

  dhcp_options_id = oci_core_dhcp_options.default_dhcp_options.id
  display_name = "APP Subnet"
  dns_label = "appsubnet"
  route_table_id = oci_core_route_table.default_route_table.id
  security_list_ids = [oci_core_security_list.app_security_list.id]
}


resource "oci_core_subnet" "db_subnet" {
  cidr_block = "10.0.2.0/24"
  compartment_id = var.compartment_ocid
  vcn_id = oci_core_vcn.vcn_demotest.id

  dhcp_options_id = oci_core_dhcp_options.default_dhcp_options.id
  display_name = "DB Subnet"
  dns_label = "dbsubnet"
  route_table_id = oci_core_route_table.default_route_table.id
  security_list_ids = [oci_core_security_list.db_security_list.id]
  prohibit_public_ip_on_vnic = true
}

output "vcn_ocid" {
  value = [oci_core_vcn.vcn_demotest.id]
}
