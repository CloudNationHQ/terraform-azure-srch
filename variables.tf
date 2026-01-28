variable "config" {
  description = "Configuration for the Azure Search service and its shared private link services."
  type = object({
    name                                     = string
    location                                 = optional(string)
    resource_group_name                      = optional(string)
    sku                                      = string
    allowed_ips                              = optional(set(string))
    authentication_failure_mode              = optional(string)
    customer_managed_key_enforcement_enabled = optional(bool, false)
    hosting_mode                             = optional(string, "Default")
    identity = optional(object({
      type         = string
      identity_ids = optional(set(string))
    }))
    local_authentication_enabled  = optional(bool, true)
    network_rule_bypass_option    = optional(string, "None")
    partition_count               = optional(number, 1)
    public_network_access_enabled = optional(bool, true)
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
    condition = !(
      var.config.local_authentication_enabled == false &&
      var.config.authentication_failure_mode != null &&
      var.config.authentication_failure_mode != ""
    )
    error_message = "`authentication_failure_mode` cannot be set when `local_authentication_enabled` is false."
  }

  validation {
    condition     = var.config.location != null || var.location != null
    error_message = "location must be provided either in the object or as a separate variable."
  }

  validation {
    condition     = var.config.resource_group_name != null || var.resource_group_name != null
    error_message = "resource group name must be provided either in the object or as a separate variable."
  }

  validation {
    condition     = !(lower(var.config.sku) == "free" && var.config.semantic_search_sku != null && var.config.semantic_search_sku != "")
    error_message = "`semantic_search_sku` cannot be set when `sku` is `free`."
  }

  validation {
    condition     = !(lower(var.config.hosting_mode) == "highdensity" && lower(var.config.sku) != "standard3")
    error_message = "`hosting_mode` can only be `HighDensity` when `sku` is `standard3`."
  }

  validation {
    condition = (
      lower(var.config.sku) != "free" ||
      (var.config.partition_count == null ? 1 : var.config.partition_count) <= 1
    )
    error_message = "`partition_count` cannot be greater than 1 when `sku` is `free`."
  }

  validation {
    condition = (
      lower(var.config.sku) != "basic" ||
      (var.config.partition_count == null ? 1 : var.config.partition_count) <= 3
    )
    error_message = "`partition_count` cannot be greater than 3 when `sku` is `basic`."
  }

  validation {
    condition = !(
      lower(var.config.sku) == "standard3" &&
      lower(var.config.hosting_mode) == "highdensity" &&
      (var.config.partition_count == null ? 1 : var.config.partition_count) > 3
    )
    error_message = "`partition_count` cannot be greater than 3 when `sku` is `standard3` and `hosting_mode` is `HighDensity`."
  }

  validation {
    condition = (
      var.config.replica_count == null ||
      (
        (var.config.replica_count >= 1) &&
        (
          (lower(var.config.sku) == "free" && var.config.replica_count <= 1) ||
          (lower(var.config.sku) == "basic" && var.config.replica_count <= 3) ||
          (lower(var.config.sku) != "free" && lower(var.config.sku) != "basic" && var.config.replica_count <= 12)
        )
      )
    )
    error_message = "`replica_count` must be 1 for `free`, 1-3 for `basic`, or 1-12 for other SKUs."
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
