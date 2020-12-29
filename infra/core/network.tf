# Create networking

resource "azurerm_virtual_network" "vnet_core" {
  name                = "vnet${local.suffix}"
  location            = azurerm_resource_group.rg_core.location
  resource_group_name = azurerm_resource_group.rg_core.name
  address_space       = ["10.1.0.0/16"]
  tags                = var.tags
}

resource "azurerm_subnet" "snet_core" {
  name                 = "snet${local.suffix}"
  resource_group_name  = azurerm_virtual_network.vnet_core.resource_group_name
  address_prefixes     = ["10.1.0.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet_core.name
  service_endpoints    = ["Microsoft.Storage"]
}

resource "azurerm_subnet" "snet_gtwy" {
  name                 = format("snet%s", local.suffix_gtwy)
  resource_group_name  = azurerm_virtual_network.vnet_core.resource_group_name
  address_prefixes     = ["10.1.1.0/26"]
  virtual_network_name = azurerm_virtual_network.vnet_core.name
}
