resource "azurerm_nat_gateway" "nat_gateway" {
  count                   = var.nat_gateway == {} || var.nat_gateway == null ? 0 : 1
  name                    = coalesce(var.nat_gateway.name, "${azurerm_virtual_network.virtual_network.name}-ng")
  location                = azurerm_virtual_network.virtual_network.location
  resource_group_name     = var.resource_group_name
  sku_name                = var.nat_gateway.sku_name
  idle_timeout_in_minutes = var.nat_gateway.idle_timeout_in_minutes
  zones                   = var.nat_gateway.zones
  tags                    = var.nat_gateway.tags
}
resource "azurerm_subnet_nat_gateway_association" "module_nat_gateway_association" {
  for_each       = { for key, value in var.subnets : key => value if try(value.nat_gateway, null) == "module" && length(azurerm_nat_gateway.nat_gateway) > 0 }
  subnet_id      = azurerm_subnet.subnet[each.key].id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway[0].id
}
resource "azurerm_subnet_nat_gateway_association" "external_nat_gateway_association" {
  for_each       = { for key, value in var.subnets : key => value if try(value.nat_gateway, "") != "module" && try(value.nat_gateway, "") != null }
  subnet_id      = azurerm_subnet.subnet[each.key].id
  nat_gateway_id = each.value.nat_gateway
}

resource "azurerm_public_ip_prefix" "public_ip_prefix" {
  for_each            = try(var.nat_gateway.public_ip_prefix, {}) == {} || try(var.nat_gateway.public_ip_prefix, null) == null ? {} : var.nat_gateway.public_ip_prefix
  name                = "${azurerm_nat_gateway.nat_gateway[0].name}-${each.key}-ippre"
  location            = azurerm_virtual_network.virtual_network.location
  resource_group_name = var.resource_group_name
  prefix_length       = each.value
  zones               = var.nat_gateway.zones
}
resource "azurerm_nat_gateway_public_ip_prefix_association" "nat_gateway_public_ip_prefix_association" {
  for_each            = try(var.nat_gateway.public_ip_prefix, {}) != {} && try(var.nat_gateway.public_ip_prefix, null) != null ? var.nat_gateway.public_ip_prefix : {}
  nat_gateway_id      = azurerm_nat_gateway.nat_gateway[0].id
  public_ip_prefix_id = azurerm_public_ip_prefix.public_ip_prefix[each.key].id
}

resource "azurerm_public_ip" "public_ip" {
  count               = try(var.nat_gateway.public_ip, {}) != {} && try(var.nat_gateway.public_ip, null) != null ? var.nat_gateway.public_ip : 0
  name                = "${azurerm_nat_gateway.nat_gateway[0].name}-pip-${count.index}"
  location            = azurerm_virtual_network.virtual_network.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}
resource "azurerm_nat_gateway_public_ip_association" "nat_gateway_public_ip_association" {
  count                = try(var.nat_gateway.public_ip, {}) != {} && try(var.nat_gateway.public_ip, null) != null ? var.nat_gateway.public_ip : 0
  nat_gateway_id       = azurerm_nat_gateway.nat_gateway[0].id
  public_ip_address_id = azurerm_public_ip.public_ip[count.index].id
}