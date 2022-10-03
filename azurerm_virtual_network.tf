resource "azurerm_virtual_network" "virtual_network" {
  name                    = var.virtual_network_name
  resource_group_name     = var.resource_group_name
  address_space           = var.virtual_network_address_space
  location                = var.virtual_network_location
  bgp_community           = var.virtual_network_bgp_community
  ddos_protection_plan    = var.virtual_network_ddos_protection_plan
  dns_servers             = var.virtual_network_dns_servers
  edge_zone               = var.virtual_network_edge_zone
  flow_timeout_in_minutes = var.virtual_network_flow_timeout_in_minutes
  tags                    = var.virtual_network_tags
}