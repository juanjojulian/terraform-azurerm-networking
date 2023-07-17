resource "azurerm_subnet" "AzureBastionSubnet" {
  count                = var.bastion == {} || var.bastion == null ? 0 : 1
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = [var.bastion.AzureBastionSubnet]
}

resource "azurerm_public_ip" "bastion-ip" {
  count               = var.bastion == {} || var.bastion == null ? 0 : 1
  name                = coalesce(var.bastion.public_ip_name, "${azurerm_virtual_network.virtual_network.name}-bastion-pip")
  location            = azurerm_virtual_network.virtual_network.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.bastion.tags
}

resource "azurerm_bastion_host" "bastion" {
  count                  = var.bastion == {} || var.bastion == null ? 0 : 1
  name                   = coalesce(var.bastion.name, "${azurerm_virtual_network.virtual_network.name}-bas")
  location               = azurerm_virtual_network.virtual_network.location
  resource_group_name    = var.resource_group_name
  sku                    = var.bastion.sku
  copy_paste_enabled     = var.bastion.copy_paste_enabled
  file_copy_enabled      = var.bastion.file_copy_enabled
  ip_connect_enabled     = var.bastion.ip_connect_enabled
  scale_units            = var.bastion.scale_units
  shareable_link_enabled = var.bastion.shareable_link_enabled
  tunneling_enabled      = var.bastion.tunneling_enabled

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.AzureBastionSubnet[0].id
    public_ip_address_id = azurerm_public_ip.bastion-ip[0].id
  }

  tags = var.bastion.tags
}