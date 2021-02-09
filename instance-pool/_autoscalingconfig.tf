resource "oci_autoscaling_auto_scaling_configuration" "demotest_autoscaling_configuration" {
  #Required
  auto_scaling_resources {
    id = oci_core_instance_pool.demotest_instance_pool.id
    type = "instancePool"
  }
  compartment_id = var.compartment_ocid
  policies {
    capacity {

      #Optional
      initial = 2
      max = 3
      min = 2
    }
    policy_type = "threshold"
    display_name = "wordpress_autoconf_policy"

    is_enabled = true
    rules {
      action {
        type  = "CHANGE_COUNT_BY"
        value = "1"
      }
      display_name = "wordpress_increase_rule"
      metric {

        #Optional
        metric_type = "CPU_UTILIZATION"
        threshold {
          #Optional
          operator = "GT"
          value = 80
        }
      }
    }

    rules {
      action {
        type  = "CHANGE_COUNT_BY"
        value = "-1"
      }
      display_name = "wordpress_increase_rule"
      metric {

        #Optional
        metric_type = "CPU_UTILIZATION"
        threshold {
          #Optional
          operator = "GT"
          value = 50
        }
      }
    }
  }
}