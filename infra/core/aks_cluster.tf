# Create AKS cluster and Kubernetes Namespace

resource "azurerm_kubernetes_cluster" "aks_core" {
  name                = "aks${local.suffix}"
  location            = azurerm_resource_group.rg_core.location
  resource_group_name = azurerm_resource_group.rg_core.name
  tags                = var.tags
  dns_prefix          = "aks${local.suffix}"
  kubernetes_version  = "1.18.10"

  default_node_pool {
    name                = "default"
    node_count          = "2"
    vm_size             = "Standard_DS2_v2"
    tags                = var.tags
    vnet_subnet_id      = azurerm_subnet.snet_core.id
    enable_auto_scaling = true
    max_count           = 5
    min_count           = 2
  }

  identity {
    type = "SystemAssigned"
  }

  addon_profile {
    http_application_routing {
      enabled = false
    }
    kube_dashboard {
      enabled = false
    }
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.log_ws_core.id
    }
  }
}

resource "kubernetes_namespace" "eshop" {
  metadata {
    name = local.eshop_ns
    labels = {
      "istio-injection" = "enabled"
    }
  }
}

resource "kubernetes_config_map" "eshopconfigmap" {
  metadata {
    name      = "eshop-svc-properties"
    namespace = local.eshop_ns
  }

  data = {
    ENV_REGISTRY = azurerm_container_registry.acr_core.name
    ENV_KEYVAULT = format("https://%s.vault.azure.net/", azurerm_key_vault.kv_core.name)
  }

  depends_on = [kubernetes_namespace.eshop]
}
