# Declare resources re-useable ids and names as output

output "identity_principal_id" {
  value = azurerm_user_assigned_identity.id_pod.principal_id
}
output "aks_core_name" {
  value = azurerm_kubernetes_cluster.aks_core.name
}

output "rg_core_name" {
  value = azurerm_kubernetes_cluster.aks_core.resource_group_name
}

output "vnet_core_subnet_id" {
  value = azurerm_subnet.snet_core.id
}

output "kv_core_id" {
  value = azurerm_key_vault.kv_core.id
}

output "kvac_id_current" {
  value = azurerm_key_vault_access_policy.kvac_id_current
}