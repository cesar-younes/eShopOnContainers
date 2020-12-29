# Create app gateway

resource "azurerm_public_ip" "ip_gtwy" {
  name                = format("ip%s", local.suffix_gtwy)
  location            = azurerm_resource_group.rg_core.location
  resource_group_name = azurerm_resource_group.rg_core.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_application_gateway" "network" {
  name                = local.agw_name
  resource_group_name = azurerm_resource_group.rg_core.name
  location            = azurerm_resource_group.rg_core.location
  tags                = var.tags

  identity {
    identity_ids = [
      azurerm_user_assigned_identity.id_gtwy.id
    ]
  }

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = local.agw_gateway_ip_config_name
    subnet_id = azurerm_subnet.snet_gtwy.id
  }

  frontend_ip_configuration {
    name                 = local.agw_frontend_ip_config_name
    public_ip_address_id = azurerm_public_ip.ip_gtwy.id
  }

  // AGIC will replace all the following settings once its deployed
  // This includes ports, address pools, http settings, listeners, and request routes
  // Therefore do not expect these to remain after deployment
  // These are only being defined because its the minimum configuration required
  // to create application gateway
  frontend_port {
    name = local.agw_http_frontend_port_name
    port = 80
  }

  backend_address_pool {
    name = local.agw_backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.agw_backend_http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  http_listener {
    name                           = local.agw_http_listener_name
    frontend_ip_configuration_name = local.agw_frontend_ip_config_name
    frontend_port_name             = local.agw_http_frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.agw_http_request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.agw_http_listener_name
    backend_address_pool_name  = local.agw_backend_address_pool_name
    backend_http_settings_name = local.agw_backend_http_setting_name
  }

  // Ensures that when terraform runs apply, it does not remove and replace
  // configuration added by AGIC. Since all these settings are managed
  // by AGIC do not update when drift or changes are discovered.
  lifecycle {
    ignore_changes = [
      ssl_certificate,
      request_routing_rule,
      http_listener,
      backend_http_settings,
      backend_address_pool,
      probe,
      tags,
      frontend_port,
      redirect_configuration,
      url_path_map
    ]
  }
}
