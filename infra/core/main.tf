# Core module terraform main 

locals {
  suffix_format                      = "-${var.app}%s-${var.env}"
  suffix                             = format(local.suffix_format, "")
  suffix_gtwy                        = format(local.suffix_format, "-gtwy")
  suffix_agic                        = format(local.suffix_format, "-agic")
  agw_name                           = format("agw%s", local.suffix_gtwy)
  agw_gateway_ip_config_name         = format("%s-gwip", local.agw_name)
  agw_http_frontend_port_name        = "http"
  agw_frontend_ip_config_name        = format("%s-feip", local.agw_name)
  agw_backend_address_pool_name      = format("%s-beap", local.agw_name)
  agw_backend_http_setting_name      = format("%s-http", local.agw_name)
  agw_http_listener_name             = format("%s-lstnr-http", local.agw_name)
  agw_http_request_routing_rule_name = format("%s-rqrt-http", local.agw_name)
  eshop_ns                            = "eshop"
}

data "azurerm_client_config" "current" {}
