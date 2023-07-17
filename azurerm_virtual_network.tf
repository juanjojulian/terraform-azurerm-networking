resource "azurerm_virtual_network" "virtual_network" {
  name                    = var.virtual_network_name
  resource_group_name     = var.resource_group_name
  address_space           = var.virtual_network_address_space
  location                = var.location
  bgp_community           = var.virtual_network_bgp_community
  dns_servers             = var.virtual_network_dns_servers
  edge_zone               = var.virtual_network_edge_zone
  flow_timeout_in_minutes = var.virtual_network_flow_timeout_in_minutes
  tags                    = var.virtual_network_tags
  dynamic "ddos_protection_plan" {
    for_each = var.virtual_network_ddos_protection_plan != null ? [1] : []
    content {
      enable = true
      id     = var.virtual_network_ddos_protection_plan
    }
  }
}