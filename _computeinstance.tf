variable "ssh_public_key" {}
variable "ubuntu_20_04_seoul_ocid" {}

resource "oci_core_instance" "test_instance" {
  #Required
  availability_domain = var.availability_domain
  compartment_id = var.compartment_ocid
  shape = "VM.Standard.E2.1"

  create_vnic_details {
    assign_public_ip = true
    subnet_id = oci_core_subnet.app_subnet.id
  }
  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }
  source_details {
    #Required
    source_id = var.ubuntu_20_04_seoul_ocid
    source_type = "image"
  }
}