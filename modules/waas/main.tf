resource "oci_waas_waas_policy" "ebs_waas_policy" {
  count = "${var.enable_waas == "true" ? 1 : 0}"
  #Required
  compartment_id = "${var.compartment_ocid}"
  domain         = "${var.public_load_balancer_hostname}"
  display_name   = "${var.waas_policy_display_name}"

  origins {
    label      = "primary"
    uri        = "${var.URI}"
    https_port = "443"
  }

  timeouts {
    create = "60m"
    delete = "60m"
    update = "60m"
  }

  waf_config {
    #Optional
    access_rules {
      #Required
      action = "ALLOW"

      criteria {
        #Required
        condition = "URL_IS"
        value     = "${var.public_allow_url}"
      }

      name = "allowrule"

      #Optional
      block_action                 = "SET_RESPONSE_CODE"
      block_error_page_code        = 403
      block_error_page_description = "blockErrorPageDescription"
      block_error_page_message     = "blockErrorPageMessage"
      block_response_code          = 403
    }

    address_rate_limiting {
      #Required
      is_enabled = true

      #Optional
      allowed_rate_per_address      = 10
      block_response_code           = 403
      max_delayed_count_per_address = 10
    }

    origin = "primary"

    protection_settings {
      #Optional
      allowed_http_methods               = ["OPTIONS", "HEAD"]
      block_action                       = "SET_RESPONSE_CODE"
      block_error_page_code              = 403
      block_error_page_description       = "blockErrorPageDescription"
      block_error_page_message           = "blockErrorPageMessage"
      block_response_code                = 403
      is_response_inspected              = false
      max_argument_count                 = 10
      max_name_length_per_argument       = 10
      max_response_size_in_ki_b          = 10
      max_total_name_length_of_arguments = 10
      media_types                        = ["application/plain", "application/json", "text/html"]
      recommendations_period_in_days     = 10
    }

    whitelists {
      #Required
      addresses = ["${var.whitelist}"]
      name      = "whitelist"
    }
  }
}