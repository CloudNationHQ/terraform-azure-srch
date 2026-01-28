# Search Service

This terraform module simplifies the process of creating and managing azure search services.

## Features

Creates Azure Search services with configurable networking and authentication options.

Supports managed identities for the search service.

Provides optional shared private link service configuration for private connectivity.

Includes validations aligned with azure search service constraints.

Utilization of terratest for robust validation.

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 4.0)

## Resources

The following resources are used by this module:

- [azurerm_search_service.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/search_service) (resource)
- [azurerm_search_shared_private_link_service.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/search_shared_private_link_service) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_config"></a> [config](#input\_config)

Description: Configuration for the Azure Search service and its shared private link services.

Type:

```hcl
object({
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
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_location"></a> [location](#input\_location)

Description: Default Azure region.

Type: `string`

Default: `null`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: Default resource group.

Type: `string`

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Tags to apply to resources when not overridden.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_search_service"></a> [search\_service](#output\_search\_service)

Description: The Azure Search service resource.

### <a name="output_shared_private_link_services"></a> [shared\_private\_link\_services](#output\_shared\_private\_link\_services)

Description: Shared private link services created for the search service.
<!-- END_TF_DOCS -->

## Goals

For more information, please see our [goals and non-goals](./GOALS.md).

## Testing

For more information, please see our testing [guidelines](./TESTING.md)

## Notes

Using a dedicated module, we've developed a naming convention for resources that's based on specific regular expressions for each type, ensuring correct abbreviations and offering flexibility with multiple prefixes and suffixes.

Full examples detailing all usages, along with integrations with dependency modules, are located in the examples directory.

To update the module's documentation run `make doc`

## Contributors

We welcome contributions from the community! Whether it's reporting a bug, suggesting a new feature, or submitting a pull request, your input is highly valued.

For more information, please see our contribution [guidelines](./CONTRIBUTING.md). <br><br>

<a href="https://github.com/cloudnationhq/terraform-azure-srch/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=cloudnationhq/terraform-azure-srch" />
</a>

## License

MIT Licensed. See [LICENSE](https://github.com/cloudnationhq/terraform-azure-srch/blob/main/LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/azure/search/)
- [Rest Api](https://learn.microsoft.com/rest/api/searchservice/)
- [Rest Api Specs](https://github.com/Azure/azure-rest-api-specs/tree/main/specification/search)
