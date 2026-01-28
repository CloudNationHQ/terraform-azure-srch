resource "azurerm_search_service" "this" {
  resource_group_name = coalesce(
    lookup(var.config, "resource_group_name", null),
    var.resource_group_name
  )

  location = coalesce(
    lookup(var.config, "location", null),
    var.location
  )

  name                                     = var.config.name
  sku                                      = var.config.sku
  allowed_ips                              = var.config.allowed_ips
  authentication_failure_mode              = var.config.authentication_failure_mode
  customer_managed_key_enforcement_enabled = var.config.customer_managed_key_enforcement_enabled
  hosting_mode                             = var.config.hosting_mode
  local_authentication_enabled             = var.config.local_authentication_enabled
  network_rule_bypass_option               = var.config.network_rule_bypass_option
  partition_count                          = var.config.partition_count
  public_network_access_enabled            = var.config.public_network_access_enabled
  replica_count                            = var.config.replica_count
  semantic_search_sku                      = var.config.semantic_search_sku

  tags = coalesce(
    var.config.tags, var.tags
  )

  dynamic "identity" {
    for_each = var.config.identity != null ? [var.config.identity] : []

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }
}

resource "azurerm_search_shared_private_link_service" "this" {
  for_each = coalesce(
    var.config.shared_private_link_services, {}
  )

  name = coalesce(
    each.value.name, each.key
  )

  search_service_id  = azurerm_search_service.this.id
  subresource_name   = each.value.subresource_name
  target_resource_id = each.value.target_resource_id
  request_message    = each.value.request_message
}
