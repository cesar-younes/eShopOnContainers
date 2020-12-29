# Create resources role assignments 

// Allow aks to access network subnet
resource "azurerm_role_assignment" "ra_id_aks_snet" {
  scope                = azurerm_subnet.snet_core.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks_core.kubelet_identity.0.object_id
}

// Managed Identity Operator role for AKS to Node Resource Group
resource "azurerm_role_assignment" "all_mi_operator" {
  principal_id         = azurerm_kubernetes_cluster.aks_core.kubelet_identity.0.object_id
  scope                = data.azurerm_resource_group.aks_node_resource_group.id
  role_definition_name = "Managed Identity Operator"
}

// Allow aks to modify compute resources within aks node resource group
resource "azurerm_role_assignment" "vm_contributor" {
  principal_id         = azurerm_kubernetes_cluster.aks_core.kubelet_identity.0.object_id
  scope                = data.azurerm_resource_group.aks_node_resource_group.id
  role_definition_name = "Virtual Machine Contributor"
}

// managed identity operator role for AKS to AGIC Identity
resource "azurerm_role_assignment" "mi_ag_operator" {
  principal_id         = azurerm_kubernetes_cluster.aks_core.kubelet_identity.0.object_id
  scope                = azurerm_user_assigned_identity.id_agic.id
  role_definition_name = "Managed Identity Operator"
}

// Allow AGIC to modify application gateway configuration
resource "azurerm_role_assignment" "appgwcontributor" {
  principal_id         = azurerm_user_assigned_identity.id_agic.principal_id
  scope                = azurerm_application_gateway.network.id
  role_definition_name = "Contributor"
}

// Allow AGIC to inspect resources within core resource group
resource "azurerm_role_assignment" "ra_id_agic_rg_core" {
  principal_id         = azurerm_user_assigned_identity.id_agic.principal_id
  scope                = azurerm_resource_group.rg_core.id
  role_definition_name = "Reader"
}

// Managed Identity Operator Role for AGIC to AppGateway Managed Identity
resource "azurerm_role_assignment" "agic_app_gw_mi" {
  principal_id         = azurerm_user_assigned_identity.id_agic.principal_id
  scope                = azurerm_user_assigned_identity.id_gtwy.id
  role_definition_name = "Managed Identity Operator"
}

// Allow agic to read and modify network resources within aks node resource group
resource "azurerm_role_assignment" "ra_id_agic_rg_nodes" {
  principal_id         = azurerm_user_assigned_identity.id_agic.principal_id
  scope                = data.azurerm_resource_group.aks_node_resource_group.id
  role_definition_name = "Network Contributor"
}

// Allow agic to read and modify gateway subnet
resource "azurerm_role_assignment" "ra_id_agic_vnet" {
  principal_id         = azurerm_user_assigned_identity.id_agic.principal_id
  scope                = azurerm_subnet.snet_gtwy.id
  role_definition_name = "Network Contributor"
}

// Allow aks to pull containers from acr
resource "azurerm_role_assignment" "acr_reader" {
  principal_id                     = azurerm_kubernetes_cluster.aks_core.kubelet_identity.0.object_id
  scope                            = azurerm_container_registry.acr_core.id
  role_definition_name             = "AcrPull"
  skip_service_principal_aad_check = true
}


# Grant Key Vault reader access to the pod identity
resource "azurerm_role_assignment" "kv_podid_reader" {
  scope                = azurerm_key_vault.kv_core.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.id_pod.principal_id
}
# Grant Key Vault access to the pod identity
resource "azurerm_key_vault_access_policy" "kvac_podid" {
  key_vault_id = azurerm_key_vault.kv_core.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.id_pod.principal_id

  secret_permissions = [
    "get",
  ]

  key_permissions = [
    "get",
  ]
}
