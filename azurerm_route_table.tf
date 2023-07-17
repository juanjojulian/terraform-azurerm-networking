resource "azurerm_route_table" "route_table" {
  count                         = var.route_table == {} || var.route_table == null ? 0 : 1
  name                          = coalesce(var.route_table.name, "${azurerm_virtual_network.virtual_network.name}-rt")
  location                      = azurerm_virtual_network.virtual_network.location
  resource_group_name           = var.resource_group_name
  disable_bgp_route_propagation = var.route_table.disable_bgp_route_propagation

  dynamic "route" {
    for_each = var.route_table.routes != "" && var.route_table.routes != null ? var.route_table.routes : {}
    content {
      name                   = route.key
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = route.value.next_hop_in_ip_address
    }
  }

  tags = var.route_table.tags
}

resource "azurerm_subnet_route_table_association" "module_route_table_association" {
  for_each       = { for key, value in var.subnets : key => value if try(value.route_table, null) == "module" && length(azurerm_route_table.route_table) > 0 }
  subnet_id      = azurerm_subnet.subnet[each.key].id
  route_table_id = azurerm_route_table.route_table[0].id
}
resource "azurerm_subnet_route_table_association" "external_route_table_association" {
  for_each       = { for key, value in var.subnets : key => value if try(value.route_table, "") != "module" && try(value.route_table, "") != null }
  subnet_id      = azurerm_subnet.subnet[each.key].id
  route_table_id = each.value.route_table
}