# Create user assigned identities for app gateway and app gateway ingress controller

// identity for application gateway
resource "azurerm_user_assigned_identity" "id_gtwy" {
  name                = format("id%s", local.suffix_gtwy)
  resource_group_name = azurerm_resource_group.rg_core.name
  location            = var.location
}

// identity for AGIC
resource "azurerm_user_assigned_identity" "id_agic" {
  name                = format("id%s", local.suffix_agic)
  resource_group_name = azurerm_resource_group.rg_core.name
  location            = azurerm_resource_group.rg_core.location
}