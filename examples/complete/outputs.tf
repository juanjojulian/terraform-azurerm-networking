//azurerm_virtual_network outputs
output "virtual_network_id" {
  description = "The virtual Network Configuration ID."
  value       = module.network.virtual_network_id
}

output "virtual_network_name" {
  description = "The name of the virtual network."
  value       = module.network.virtual_network_name
}

output "resource_group_name" {
  description = "The name of the resource group in which to create the virtual network."
  value       = module.network.resource_group_name
}

output "virtual_network_location" {
  description = "The location/region where the virtual network is created."
  value       = module.network.virtual_network_location
}

output "virtual_network_address_space" {
  description = "The list of address spaces used by the virtual network."
  value       = module.network.virtual_network_address_space
}

output "virtual_network_guid" {
  description = "The GUID of the virtual network."
  value       = module.network.virtual_network_guid
}

//azurerm_subnet outputs
output "subnet_id" {
  description = "Outputs a map in the form: {subnet_name = subnet_id}"
  value       = module.network.subnet_id
}
output "subnet_name" {
  description = "Outputs the list of subnet names"
  value       = module.network.subnet_name
}

output "subnet_address_prefixes" {
  description = "Ouputs a maps in the form: [subnet_name = subnet_address_prefixes]"
  value       = module.network.subnet_address_prefixes
}

//azurerm_nat_gateway
output "nat_gateway_id" {
  description = "Outputs the ID for azurerm_nat_gateway"
  value       = module.network.nat_gateway_id
}
output "nat_gateway_resource_guid" {
  description = "Outputs the GUID for azurerm_nat_gateway"
  value       = module.network.nat_gateway_resource_guid
}

//azurerm_route_table
output "route_table_id" {
  description = "Outputs the ID for azurerm_route_table"
  value       = module.network.route_table_id
}
output "route_table_subnets" {
  description = "Outputs The collection of Subnets associated with the route table."
  value       = module.network.route_table_subnets
}

//azurerm_network_security_group
output "network_security_group_id" {
  description = "Outputs the ID for azurerm_network_security_group"
  value       = module.network.network_security_group_id
}
output "network_security_rule_id" {
  description = "Outputs the list of azurerm_network_security_rule ids"
  value       = module.network.network_security_rule_id
}