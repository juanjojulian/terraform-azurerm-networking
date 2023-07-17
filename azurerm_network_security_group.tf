resource "azurerm_network_security_group" "network_security_group" {
  count               = var.network_security_group == {} || var.network_security_group == null ? 0 : 1
  name                = coalesce(var.network_security_group.name, "${azurerm_virtual_network.virtual_network.name}-nsg")
  location            = azurerm_virtual_network.virtual_network.location
  resource_group_name = var.resource_group_name
  tags                = var.network_security_group.tags
}

resource "azurerm_subnet_network_security_group_association" "module_network_security_group_association" {
  for_each                  = { for key, value in var.subnets : key => value if try(value.network_security_group, null) == "module" && length(azurerm_network_security_group.network_security_group) > 0 }
  subnet_id                 = azurerm_subnet.subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.network_security_group[0].id
}
resource "azurerm_subnet_network_security_group_association" "external_network_security_group_association" {
  for_each                  = { for key, value in var.subnets : key => value if try(value.network_security_group, "") != "module" && try(value.network_security_group, "") != null }
  subnet_id                 = azurerm_subnet.subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.network_security_group[0].id
}

resource "azurerm_network_security_rule" "network_security_rule" {
  for_each                                   = (var.nsg_rules != null && var.network_security_group != null) ? { for value in var.nsg_rules : value.name => value } : {}
  access                                     = each.value.access
  direction                                  = each.value.direction
  name                                       = each.value.name
  network_security_group_name                = azurerm_network_security_group.network_security_group[0].name
  priority                                   = each.value.priority
  protocol                                   = each.value.protocol
  resource_group_name                        = var.resource_group_name
  description                                = each.value.description
  destination_address_prefix                 = lookup(each.value, "destination_application_security_group_ids", null) == null && lookup(each.value, "destination_address_prefixes", null) == null ? lookup(each.value, "destination_address_prefix", "*") : null
  destination_address_prefixes               = lookup(each.value, "destination_application_security_group_ids", null) == null ? lookup(each.value, "destination_address_prefixes", null) : null
  destination_application_security_group_ids = lookup(each.value, "destination_application_security_group_ids", null)
  destination_port_range                     = each.value.destination_port_range
  destination_port_ranges                    = lookup(each.value, "destination_port_range", null) == null ? each.value.destination_port_ranges : null
  source_address_prefix                      = lookup(each.value, "source_application_security_group_ids", null) == null && lookup(each.value, "source_address_prefixes", null) == null ? lookup(each.value, "source_address_prefix", "*") : null
  source_address_prefixes                    = lookup(each.value, "source_application_security_group_ids", null) == null ? lookup(each.value, "source_address_prefixes", null) : null
  source_application_security_group_ids      = lookup(each.value, "source_application_security_group_ids", null)
  source_port_range                          = lookup(each.value, "source_port_range", "*") == "*" ? "*" : null
  source_port_ranges                         = lookup(each.value, "source_port_range", "*") == "*" ? null : [for port in split(",", each.value.source_port_range) : trimspace(port)]
}