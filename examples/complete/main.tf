module "network" {
  source                                  = "git@github.com:juanjojulian/terraform-azurerm-networking.git?ref=v0.9.0"
  resource_group_name                     = azurerm_resource_group.msdn-hub-westeurope-rg.name
  virtual_network_name                    = "msdn-hub-westeurope-vnet"
  location                                = "westeurope"
  # virtual_network_bgp_community           = "12076:20000"
  virtual_network_address_space           = ["192.168.0.0/24", "192.168.1.0/24"]
  # virtual_network_flow_timeout_in_minutes = 4
  virtual_network_dns_servers             = ["192.168.0.4", "192.168.0.5"]

  peerings = {
    msdn-spoke-westeurope-vnet = {
      remote_virtual_network_id = data.azurerm_virtual_network.msdn-spoke-westeurope-vnet.id
      # allow_virtual_network_access = true
      allow_forwarded_traffic = true
      allow_gateway_transit   = true
      # use_remote_gateways = false
    },
    msdn-spoke-northeurope-vnet = {
      remote_virtual_network_id = data.azurerm_virtual_network.msdn-spoke-northeurope-vnet.id
      # allow_virtual_network_access = true
      allow_forwarded_traffic = true
      allow_gateway_transit   = true
      # use_remote_gateways = false
    }
  }

  bastion = {
    AzureBastionSubnet = "192.168.0.64/26"
    # name                   = "bastion"
    # public_ip_name         = "bastion-ip-pip"
    # sku                    = "Basic"
    # copy_paste_enabled     = true
    # file_copy_enabled      = false
    # ip_connect_enabled     = false
    # scale_units            = 2
    # shareable_link_enabled = false
    # tunneling_enabled      = false
    tags = {
      environment = "development"
    }
  }

  subnets = {
    westeurope-ad = {
      address_prefixes = ["192.168.0.0/28"]
      # delegation                                = "Microsoft.Web/serverFarms"
      service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
      # service_endpoint_policy_ids               = []
      private_endpoint_network_policies_enabled     = false
      private_link_service_network_policies_enabled = true
      nat_gateway                                   = "module"
      route_table                                   = "module"
      network_security_group                        = "module"
    }
    westeurope-management = {
      address_prefixes = ["192.168.0.16/28"]
      # delegation                                    = ""
      # service_endpoints                             = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.ContainerRegistry", "Microsoft.Sql"]
      # service_endpoint_policy_ids                   = null
      # private_endpoint_network_policies_enabled     = false
      # private_link_service_network_policies_enabled = false
      nat_gateway                                   = "module"
      route_table                                   = "module"
      network_security_group                        = "module"
    }
    westeurope-sql-mi = {
      address_prefixes       = ["192.168.0.128/26"]
      delegation             = "Microsoft.Sql/managedInstances"
      network_security_group = "/subscriptions/XXX-XXXX-XXXX-XXXX/resourceGroups/msdn-hub-westeurope-rg/providers/Microsoft.Network/networkSecurityGroups/msdn-sqlmi-westeurope-vnet-nsg"
    }
  }

  nat_gateway = {
    name                    = null
    idle_timeout_in_minutes = 4
    sku_name                = "Standard"
    zones                   = []
    #public_ip               = 1
    public_ip_prefix = {
      first  = 31
      second = 31
    }
    tags = {
      environment = "development"
    }
  }

  route_table = {
    # name                          = "routeTable-rt"
    disable_bgp_route_propagation = true
    // Routes placed in routes.auto.tfvars for clarity.
    routes = var.routes
    tags = {
      environment = "development"
    }
  }

  network_security_group = {
    # name = null
    // NSG Rules placed in nsg_rules.auto.tfvars for clarity.
    rules = var.nsg_rules
    tags = {
      environment = "development"
    }
  }

  virtual_network_tags = {
    environment = "development"
  }
}