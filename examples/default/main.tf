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

module "search" {
  source  = "cloudnationhq/srch/azure"
  version = "~> 1.0"

  config = {
    name                = module.naming.search_service.name_unique
    resource_group_name = module.rg.groups.demo.name
    location            = module.rg.groups.demo.location
    sku                 = "standard"
  }
}
