# Create keyvault

resource "azurerm_key_vault" "kv_core" {
  name                        = "kv${local.suffix}"
  location                    = azurerm_resource_group.rg_core.location
  resource_group_name         = azurerm_resource_group.rg_core.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  tags                        = var.tags
}

resource "azurerm_key_vault_secret" "kv_app_insight_key" {
  name         = "appinsights-key"
  value        = azurerm_application_insights.ai_core.instrumentation_key
  key_vault_id = azurerm_key_vault.kv_core.id

  depends_on = [azurerm_key_vault_access_policy.kvac_id_current]
}

// Allow deployment user/spn to read and modify secrets
resource "azurerm_key_vault_access_policy" "kvac_id_current" {
  key_vault_id = azurerm_key_vault.kv_core.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "get",
    "list",
    "set",
    "delete"
  ]
}