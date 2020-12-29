# Create app gateway ingress controller using helm provider

locals {
  helm_agic_name    = "agic"
  helm_agic_ns      = "agic"
  helm_agic_repo    = "https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/"
  helm_agic_version = "1.2.0"
}

resource "kubernetes_namespace" "agic" {
  metadata {
    name = local.helm_agic_ns
  }
}

resource "helm_release" "agic" {
  name       = local.helm_agic_name
  repository = local.helm_agic_repo
  chart      = "ingress-azure"
  version    = local.helm_agic_version
  namespace  = kubernetes_namespace.agic.metadata.0.name


  set {
    name  = "appgw.subscriptionId"
    value = data.azurerm_client_config.current.subscription_id
  }

  set {
    name  = "appgw.resourceGroup"
    value = azurerm_resource_group.rg_core.name
  }

  set {
    name  = "appgw.name"
    value = azurerm_application_gateway.network.name
  }

  set {
    name  = "armAuth.identityResourceID"
    value = azurerm_user_assigned_identity.id_agic.id
  }

  set {
    name  = "armAuth.identityClientID"
    value = azurerm_user_assigned_identity.id_agic.client_id
  }

  set {
    name  = "armAuth.type"
    value = "aadPodIdentity"
  }

  set {
    name  = "appgw.shared"
    value = false
  }

  set {
    name  = "appgw.usePrivateIP"
    value = false
  }

  set {
    name  = "rbac.enabled"
    value = true
  }

  set {
    name  = "verbosityLevel"
    value = 5
  }
}