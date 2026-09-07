resource "azurerm_search_service" "this" {
  resource_group_name = coalesce(
    var.search_service.resource_group_name,
    var.resource_group_name
  )

  location = coalesce(
    var.search_service.location,
    var.location
  )

  name                                     = var.search_service.name
  sku                                      = var.search_service.sku
  allowed_ips                              = var.search_service.allowed_ips
  authentication_failure_mode              = var.search_service.authentication_failure_mode
  customer_managed_key_enforcement_enabled = var.search_service.customer_managed_key_enforcement_enabled
  hosting_mode                             = var.search_service.hosting_mode
  local_authentication_enabled             = var.search_service.local_authentication_enabled
  network_rule_bypass_option               = var.search_service.network_rule_bypass_option
  partition_count                          = var.search_service.partition_count
  public_network_access_enabled            = var.search_service.public_network_access_enabled
  replica_count                            = var.search_service.replica_count
  semantic_search_sku                      = var.search_service.semantic_search_sku

  tags = coalesce(
    var.search_service.tags, var.tags
  )

  dynamic "identity" {
    for_each = var.search_service.identity != null ? { "this" = var.search_service.identity } : {}

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }
}

resource "azurerm_search_shared_private_link_service" "this" {
  for_each = var.search_service.shared_private_link_services

  name = coalesce(
    each.value.name, each.key
  )

  search_service_id  = azurerm_search_service.this.id
  subresource_name   = each.value.subresource_name
  target_resource_id = each.value.target_resource_id
  request_message    = each.value.request_message
}
