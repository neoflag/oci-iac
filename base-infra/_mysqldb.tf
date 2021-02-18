variable "mysql_db_system_admin_password" {}
variable "mysql_db_system_admin_username" {}

resource "oci_mysql_mysql_db_system" "test_mysql_db_system" {
  admin_password = var.mysql_db_system_admin_password
  admin_username = var.mysql_db_system_admin_username
  availability_domain = var.availability_domain
  compartment_id = var.compartment_ocid
  shape_name = "MySQL.VM.Standard.E3.1.16GB"
  subnet_id = oci_core_subnet.db_subnet.id
  data_storage_size_in_gb = 50
}