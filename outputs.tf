//azurerm_virtual_network outputs
output "virtual_network_id" {
  description = "The virtual Network Configuration ID."
  value       = azurerm_virtual_network.virtual_network.id
}

output "virtual_network_name" {
  description = "The name of the virtual network."
  value       = azurerm_virtual_network.virtual_network.name
}

output "resource_group_name" {
  description = "The name of the resource group in which to create the virtual network."
  value       = azurerm_virtual_network.virtual_network.resource_group_name
}

output "virtual_network_location" {
  description = "The location/region where the virtual network is created."
  value       = azurerm_virtual_network.virtual_network.location
}

output "virtual_network_address_space" {
  description = "The list of address spaces used by the virtual network."
  value       = azurerm_virtual_network.virtual_network.address_space
}

output "virtual_network_guid" {
  description = "The GUID of the virtual network."
  value       = azurerm_virtual_network.virtual_network.guid
}

//azurerm_subnet outputs
output "subnet_id" {
  description = "Outputs a map in the form: {subnet_name = subnet_id}"
  value = {
    for subnet in azurerm_subnet.subnet :
    subnet.name => subnet.id
  }
}
output "subnet_name" {
  description = "Outputs the list of subnet names"
  value       = [for subnet in azurerm_subnet.subnet : subnet.name]
}

output "subnet_address_prefixes" {
  description = "Ouputs a maps in the form: [subnet_name = subnet_address_prefixes]"
  value = {
    for subnet in azurerm_subnet.subnet :
    subnet.name => subnet.address_prefixes
  }
}