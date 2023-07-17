resource "azurerm_subnet" "subnet" {
  for_each             = var.subnets
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = each.value.address_prefixes

  dynamic "delegation" {
    for_each = each.value.delegation != "" && each.value.delegation != null ? [1] : []
    content {
      name = "${each.key}-delegation"
      service_delegation {
        name    = each.value.delegation
        actions = var.subnet_delegations_actions[each.value.delegation]
      }
    }
  }

  service_endpoints                             = try(length(each.value.service_endpoints) > 0, false) && each.value.service_endpoints != null ? each.value.service_endpoints : []
  service_endpoint_policy_ids                   = try(length(each.value.service_endpoint_policy_ids) > 0, false) && each.value.service_endpoint_policy_ids != null ? each.value.service_endpoint_policy_ids : null
  private_endpoint_network_policies_enabled     = try(each.value.private_endpoint_network_policies_enabled, true)
  private_link_service_network_policies_enabled = try(each.value.private_link_service_network_policies_enabled, true)
}