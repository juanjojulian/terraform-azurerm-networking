resource "azurerm_route_table" "route_table" {
  count                         = var.route_table == {} || var.route_table == null ? 0 : 1
  name                          = coalesce(var.route_table.name, "${azurerm_virtual_network.virtual_network.name}-rt")
  location                      = azurerm_virtual_network.virtual_network.location
  resource_group_name           = var.resource_group_name
  disable_bgp_route_propagation = var.route_table.disable_bgp_route_propagation

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

resource "azurerm_route" "route" {
  for_each               = try(var.route_table.routes, {}) != {} && try(var.route_table.routes, null) != null ? var.route_table.routes : {}
  name                   = each.key
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.route_table[0].name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_in_ip_address
}