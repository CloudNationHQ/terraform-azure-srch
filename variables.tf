variable "search_service" {
  description = "Configuration for the Azure Search service and its shared private link services."
  type = object({
    name                                     = string
    location                                 = optional(string)
    resource_group_name                      = optional(string)
    sku                                      = string
    allowed_ips                              = optional(set(string))
    authentication_failure_mode              = optional(string)
    customer_managed_key_enforcement_enabled = optional(bool)
    hosting_mode                             = optional(string)
    identity = optional(object({
      type         = string
      identity_ids = optional(set(string))
    }))
    local_authentication_enabled  = optional(bool)
    network_rule_bypass_option    = optional(string)
    partition_count               = optional(number)
    public_network_access_enabled = optional(bool)
    replica_count                 = optional(number)
    semantic_search_sku           = optional(string)
    tags                          = optional(map(string))
    shared_private_link_services = optional(map(object({
      name               = optional(string)
      subresource_name   = string
      target_resource_id = string
      request_message    = optional(string)
    })), {})
  })

  validation {
    condition     = var.search_service.location != null || var.location != null
    error_message = "location must be provided either in the object or as a separate variable."
  }

  validation {
    condition     = var.search_service.resource_group_name != null || var.resource_group_name != null
    error_message = "resource group name must be provided either in the object or as a separate variable."
  }
}

variable "location" {
  description = "Default Azure region."
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "Default resource group."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to resources when not overridden."
  type        = map(string)
  default     = {}
}
