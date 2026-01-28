output "search_service" {
  description = "The Azure Search service resource."
  value       = azurerm_search_service.this
}

output "shared_private_link_services" {
  description = "Shared private link services created for the search service."
  value       = azurerm_search_shared_private_link_service.this
}
