# Create log analytics and app insights

resource "azurerm_log_analytics_workspace" "log_ws_core" {
  name                = "log${local.suffix}"
  location            = azurerm_resource_group.rg_core.location
  resource_group_name = azurerm_resource_group.rg_core.name
  sku                 = "PerGB2018"
  tags                = var.tags
}

resource "azurerm_log_analytics_solution" "log_sln_core" {
  location              = azurerm_resource_group.rg_core.location
  resource_group_name   = azurerm_resource_group.rg_core.name
  workspace_resource_id = azurerm_log_analytics_workspace.log_ws_core.id
  workspace_name        = azurerm_log_analytics_workspace.log_ws_core.name
  solution_name         = "ContainerInsights"

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

resource "azurerm_application_insights" "ai_core" {
  name                = "ai${local.suffix}"
  location            = azurerm_resource_group.rg_core.location
  resource_group_name = azurerm_resource_group.rg_core.name
  application_type    = "web"
  tags                = var.tags
}
