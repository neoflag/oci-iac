resource "oci_file_storage_file_system" "wordpress_file_system" {

    availability_domain = var.availability_domain
    compartment_id = var.compartment_ocid
    display_name = "FS-wordpress"
}

resource "oci_file_storage_export_set" "wordpress_export_set" {
    mount_target_id = oci_file_storage_mount_target.wordpress_mount_target.id
}

resource "oci_file_storage_export" "wordpress_export" {
    export_set_id = oci_file_storage_export_set.wordpress_export_set.id
    file_system_id = oci_file_storage_file_system.wordpress_file_system.id
    path = "/FS-wordpress"
}

resource "oci_file_storage_mount_target" "wordpress_mount_target" {
    availability_domain = var.availability_domain
    compartment_id = var.compartment_ocid
    subnet_id = oci_core_subnet.app_subnet.id
    display_name = "MT-wordpress"
}
