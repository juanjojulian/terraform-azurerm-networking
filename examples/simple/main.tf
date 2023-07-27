module "network" {
  source                                  = "git@github.com:juanjojulian/terraform-azurerm-networking.git?ref=v0.9.0"
  resource_group_name                     = azurerm_resource_group.msdn-simple-westeurope-rg.name
  virtual_network_name                    = "msdn-simple-westeurope-vnet"
  location                                = "westeurope"
  virtual_network_address_space           = ["192.168.0.0/24"]
  subnets = {
    westeurope-app = {
      address_prefixes = ["192.168.0.0/28"]
    }
    westeurope-management = {
      address_prefixes = ["192.168.0.16/28"]
    }
  }
}