// Data to configure peerings
data "azurerm_virtual_network" "msdn-spoke-westeurope-vnet" {
  name                = "msdn-spoke-westeurope-vnet"
  resource_group_name = "msdn-spoke-westeurope-rg"
}

data "azurerm_virtual_network" "msdn-spoke-northeurope-vnet" {
  name                = "msdn-spoke-northeurope-vnet"
  resource_group_name = "msdn-spoke-northeurope-rg"
}