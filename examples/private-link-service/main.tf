module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.26"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "westeurope"
    }
  }
}

module "storage" {
  source  = "cloudnationhq/sa/azure"
  version = "~> 4.0"

  storage = {
    name                     = module.naming.storage_account.name_unique
    location                 = module.rg.groups.demo.location
    resource_group_name      = module.rg.groups.demo.name
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

module "search" {
  source  = "cloudnationhq/srch/azure"
  version = "~> 1.0"

  config = {
    name                = module.naming.search_service.name_unique
    resource_group_name = module.rg.groups.demo.name
    location            = module.rg.groups.demo.location
    sku                 = "standard"

    shared_private_link_services = {
      blob = {
        subresource_name   = "blob"
        target_resource_id = module.storage.account.id
        request_message    = "Please approve blob private link for search."
      }
    }
  }
}
