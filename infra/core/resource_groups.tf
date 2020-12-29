# Create and declare existing resource group

resource "azurerm_resource_group" "rg_core" {
  name     = "rg${local.suffix}"
  location = var.location
  tags     = var.tags
}

data "azurerm_resource_group" "aks_node_resource_group" {
  name = azurerm_kubernetes_cluster.aks_core.node_resource_group
}
