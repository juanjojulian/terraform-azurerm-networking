resource "azurerm_subnet" "subnet" {
  for_each             = var.subnets
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = each.value

  #delegation block will only be created if the subnet name is included in var.subnet_delegations map variable
  dynamic "delegation" {
    for_each = contains(keys(var.subnet_delegations), each.key) ? [1] : []
    content {
      name = "${each.key}-delegation"
      service_delegation {
        name    = var.subnet_delegations[each.key]
        actions = var.subnet_delegations_actions[var.subnet_delegations[each.key]]
      }
    }
  }


  #Service Enpoints will only be created if subnet name is included in the subnet_service_endpoints map
  service_endpoints = contains(keys(var.subnet_service_endpoints), each.key) ? var.subnet_service_endpoints[each.key] : []

  service_endpoint_policy_ids = contains(keys(var.subnet_service_endpoint_policy_ids), each.key) ? var.subnet_service_endpoint_policy_ids[each.key] : null

  private_endpoint_network_policies_enabled     = contains(keys(var.subnet_private_endpoint_network_policies_enabled), each.key) ? var.subnet_private_endpoint_network_policies_enabled[each.key] : true
  private_link_service_network_policies_enabled = contains(keys(var.subnet_private_link_service_network_policies_enabled), each.key) ? var.subnet_private_link_service_network_policies_enabled[each.key] : true
}