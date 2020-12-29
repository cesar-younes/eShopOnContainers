# Create ACR 

resource "azurerm_container_registry" "acr_core" {
  name                     = var.acr
  resource_group_name      = azurerm_resource_group.rg_core.name
  location                 = var.location
  sku                      = "Basic"
  admin_enabled            = false
}