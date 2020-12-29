# Create aks pod indentity using helm provider

locals {
  helm_pod_identity_name    = "aad-pod-identity"
  helm_pod_identity_ns      = "podidentity"
  helm_pod_identity_repo    = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
  helm_pod_identity_version = "2.0.0"
  suffix_pod                = format(local.suffix_format, "pod")
}

// Identity for Pod Identity
resource "azurerm_user_assigned_identity" "id_pod" {
  name                = format("id%s", local.suffix_pod)
  resource_group_name = azurerm_resource_group.rg_core.name
  location            = azurerm_resource_group.rg_core.location
}

// Managed Identity Operator role for AKS to Pod Identity
resource "azurerm_role_assignment" "ra_id_aks_pod" {
  principal_id         = azurerm_kubernetes_cluster.aks_core.kubelet_identity.0.object_id
  scope                = azurerm_user_assigned_identity.id_pod.id
  role_definition_name = "Managed Identity Operator"
}

resource "kubernetes_namespace" "pod_identity" {
  metadata {
    name = local.helm_pod_identity_ns
  }
}

resource "helm_release" "aad_pod_id" {
  name       = local.helm_pod_identity_name
  repository = local.helm_pod_identity_repo
  chart      = "aad-pod-identity"
  version    = local.helm_pod_identity_version
  namespace  = kubernetes_namespace.pod_identity.metadata.0.name


  set {
    name  = "azureIdentities[0].enabled"
    value = true
  }

  set {
    name  = "azureIdentities[0].type"
    value = 0
  }

  set {
    name  = "azureIdentities[0].namespace"
    value = kubernetes_namespace.pod_identity.metadata.0.name
  }

  set {
    name  = "azureIdentities[0].name"
    value = "eshop-identity"
  }

  set {
    name  = "azureIdentities[0].resourceID"
    value = azurerm_user_assigned_identity.id_pod.id
  }

  set {
    name  = "azureIdentities[0].clientID"
    value = azurerm_user_assigned_identity.id_pod.client_id
  }

  set {
    name  = "azureIdentities[0].binding.selector"
    value = "eshop-identity"
  }

  set {
    name  = "azureIdentities[0].binding.name"
    value = "eshop-identity-binding"
  }

  depends_on = [kubernetes_namespace.pod_identity, azurerm_user_assigned_identity.id_pod]
}
