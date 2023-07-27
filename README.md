# terraform-azurerm-networking

This Terraform module deploys a Virtual Network in Azure and some optional associated resources including:

- One or more Subnets.
- One NAT Gateway.
- One Bastion Host.
- One Network Security Group and NSG Rules.
- One Route Table and Routes.
- One or more VNET Peerings.

You can choose to make use of the associated resource (NSG, Nat Gateway or Route Table) deployed by the module or make use of an external one by using the keyword "module" instead of the resource ID.

### Please check the "examples" directory for more information.


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.25.0, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.25.0, < 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_bastion_host.bastion](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/bastion_host) | resource |
| [azurerm_nat_gateway.nat_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway) | resource |
| [azurerm_nat_gateway_public_ip_association.nat_gateway_public_ip_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway_public_ip_association) | resource |
| [azurerm_nat_gateway_public_ip_prefix_association.nat_gateway_public_ip_prefix_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway_public_ip_prefix_association) | resource |
| [azurerm_network_security_group.network_security_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.network_security_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_public_ip.bastion-ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip_prefix.public_ip_prefix](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip_prefix) | resource |
| [azurerm_route.route](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [azurerm_route_table.route_table](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_subnet.AzureBastionSubnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_nat_gateway_association.external_nat_gateway_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_nat_gateway_association) | resource |
| [azurerm_subnet_nat_gateway_association.module_nat_gateway_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_nat_gateway_association) | resource |
| [azurerm_subnet_network_security_group_association.external_network_security_group_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_network_security_group_association.module_network_security_group_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_route_table_association.external_route_table_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_subnet_route_table_association.module_route_table_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_virtual_network.virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network_peering.peering](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bastion"></a> [bastion](#input\_bastion) | Bastion to be attached to the vnet and its options, if not null a new Azure Bastion plus a Bastion Subnet will be created. | <pre>object({<br>    AzureBastionSubnet     = string<br>    name                   = optional(string)<br>    public_ip_name         = optional(string)<br>    sku                    = optional(string, "Basic")<br>    copy_paste_enabled     = optional(bool, true)<br>    file_copy_enabled      = optional(bool, false)<br>    ip_connect_enabled     = optional(bool, false)<br>    scale_units            = optional(number, 2)<br>    shareable_link_enabled = optional(bool, false)<br>    tunneling_enabled      = optional(bool, false)<br>    tags                   = optional(map(string), null)<br>  })</pre> | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The location/region where all resources will be created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_nat_gateway"></a> [nat\_gateway](#input\_nat\_gateway) | Map of azurerm\_nat\_gateway options, if not null a new azurerm\_nat\_gateway will be created | <pre>object({<br>    name                    = optional(string)<br>    idle_timeout_in_minutes = optional(number, 4)<br>    sku_name                = optional(string, "Standard")<br>    zones                   = optional(list(string), null)<br>    tags                    = optional(map(string), null)<br>    public_ip               = optional(number)<br>    public_ip_prefix        = optional(map(number))<br>  })</pre> | `null` | no |
| <a name="input_network_security_group"></a> [network\_security\_group](#input\_network\_security\_group) | Map of azurerm\_network\_security\_group options, if not null a new azurerm\_network\_security\_group will be created | <pre>object({<br>    name = optional(string)<br>    tags = optional(map(string), null)<br>    rules = optional(list(object({<br>      access                                     = string<br>      direction                                  = string<br>      name                                       = string<br>      priority                                   = number<br>      protocol                                   = string<br>      description                                = optional(string, null)<br>      destination_address_prefix                 = optional(string, null)<br>      destination_address_prefixes               = optional(list(string))<br>      destination_application_security_group_ids = optional(list(string))<br>      destination_port_range                     = optional(string, null)<br>      destination_port_ranges                    = optional(list(string))<br>      source_address_prefix                      = optional(string, "*")<br>      source_address_prefixes                    = optional(list(string), null)<br>      source_application_security_group_ids      = optional(list(string), null)<br>      source_port_range                          = optional(string, null)<br>      source_port_ranges                         = optional(list(string), null)<br>    })), null)<br>  })</pre> | `null` | no |
| <a name="input_peerings"></a> [peerings](#input\_peerings) | Map of peerings, the key is the name of the peering | <pre>map(object({<br>    remote_virtual_network_id    = string<br>    allow_virtual_network_access = optional(bool, true)<br>    allow_forwarded_traffic      = optional(bool, false) //This one is true by default in Azure Portal but false in azurerm, not nice.<br>    allow_gateway_transit        = optional(bool, false)<br>    use_remote_gateways          = optional(bool, false)<br>  }))</pre> | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the virtual network. This module will NOT create a resource group. | `string` | n/a | yes |
| <a name="input_route_table"></a> [route\_table](#input\_route\_table) | Map of azurerm\_route\_table options, if not null a new azurerm\_route\_table will be created | <pre>object({<br>    name                          = optional(string)<br>    disable_bgp_route_propagation = optional(bool, false)<br>    routes                        = optional(map(map(string)))<br>    tags                          = optional(map(string), null)<br>  })</pre> | `null` | no |
| <a name="input_subnet_delegations_actions"></a> [subnet\_delegations\_actions](#input\_subnet\_delegations\_actions) | Unfortunately this variable has to be kept updated with the output of `az network vnet subnet list-available-delegations --location westeurope | jq 'to_entries | map( {(.value.serviceName) : .value.actions } ) | add'` Reason https://github.com/terraform-providers/terraform-provider-azurerm/issues/5975 | `map(list(string))` | <pre>{<br>  "GitHub.Network/networkSettings": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.AVS/PrivateClouds": [<br>    "Microsoft.Network/networkinterfaces/*"<br>  ],<br>  "Microsoft.ApiManagement/service": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action",<br>    "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"<br>  ],<br>  "Microsoft.Apollo/npu": [<br>    "Microsoft.Network/networkinterfaces/*",<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.App/environments": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.App/testClients": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.AzureCosmosDB/clusters": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.BareMetal/AzureHostedService": [<br>    "Microsoft.Network/networkinterfaces/*",<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.BareMetal/AzureVMware": [<br>    "Microsoft.Network/networkinterfaces/*",<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.BareMetal/CrayServers": [<br>    "Microsoft.Network/networkinterfaces/*",<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.Batch/batchAccounts": [<br>    "Microsoft.Network/virtualNetworks/subnets/action"<br>  ],<br>  "Microsoft.CloudTest/hostedpools": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.CloudTest/images": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.CloudTest/pools": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.Codespaces/plans": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.ContainerInstance/containerGroups": [<br>    "Microsoft.Network/virtualNetworks/subnets/action"<br>  ],<br>  "Microsoft.ContainerService/managedClusters": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.DBforMySQL/flexibleServers": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.DBforMySQL/servers": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.DBforMySQL/serversv2": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.DBforPostgreSQL/flexibleServers": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.DBforPostgreSQL/serversv2": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.DBforPostgreSQL/singleServers": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.Databricks/workspaces": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action",<br>    "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",<br>    "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"<br>  ],<br>  "Microsoft.DelegatedNetwork/controller": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.DevCenter/networkConnection": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.DocumentDB/cassandraClusters": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.Fidalgo/networkSettings": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.HardwareSecurityModules/dedicatedHSMs": [<br>    "Microsoft.Network/networkinterfaces/*",<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.Kusto/clusters": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action",<br>    "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",<br>    "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"<br>  ],<br>  "Microsoft.LabServices/labplans": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.Logic/integrationServiceEnvironments": [<br>    "Microsoft.Network/virtualNetworks/subnets/action"<br>  ],<br>  "Microsoft.MachineLearningServices/workspaces": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.Netapp/volumes": [<br>    "Microsoft.Network/networkinterfaces/*",<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.Network/dnsResolvers": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.Network/networkWatchers": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.Orbital/orbitalGateways": [<br>    "Microsoft.Network/publicIPAddresses/join/action",<br>    "Microsoft.Network/virtualNetworks/subnets/join/action",<br>    "Microsoft.Network/virtualNetworks/read",<br>    "Microsoft.Network/publicIPAddresses/read"<br>  ],<br>  "Microsoft.PowerPlatform/enterprisePolicies": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.PowerPlatform/vnetaccesslinks": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.ServiceFabricMesh/networks": [<br>    "Microsoft.Network/virtualNetworks/subnets/action"<br>  ],<br>  "Microsoft.ServiceNetworking/trafficControllers": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.Singularity/accounts/networks": [<br>    "Microsoft.Network/networkinterfaces/*",<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.Singularity/accounts/npu": [<br>    "Microsoft.Network/networkinterfaces/*",<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.Sql/managedInstances": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action",<br>    "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",<br>    "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"<br>  ],<br>  "Microsoft.StoragePool/diskPools": [<br>    "Microsoft.Network/virtualNetworks/read"<br>  ],<br>  "Microsoft.StreamAnalytics/streamingJobs": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.Synapse/workspaces": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Microsoft.Web/hostingEnvironments": [<br>    "Microsoft.Network/virtualNetworks/subnets/action"<br>  ],<br>  "Microsoft.Web/serverFarms": [<br>    "Microsoft.Network/virtualNetworks/subnets/action"<br>  ],<br>  "NGINX.NGINXPLUS/nginxDeployments": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "PaloAltoNetworks.Cloudngfw/firewalls": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ],<br>  "Qumulo.Storage/fileSystems": [<br>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br>  ]<br>}</pre> | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Map defining the subnets to be deployed, the key is the name of the subnet while the value is a list of address spaces | <pre>map(object({<br>    address_prefixes                              = list(string)<br>    delegation                                    = optional(string, "")<br>    service_endpoints                             = optional(list(string), [])<br>    service_endpoint_policy_ids                   = optional(list(string), null)<br>    private_endpoint_network_policies_enabled     = optional(bool, true)<br>    private_link_service_network_policies_enabled = optional(bool, true)<br>    nat_gateway                                   = optional(string, null)<br>    route_table                                   = optional(string, null)<br>    network_security_group                        = optional(string, null)<br>  }))</pre> | n/a | yes |
| <a name="input_virtual_network_address_space"></a> [virtual\_network\_address\_space](#input\_virtual\_network\_address\_space) | The address space used by the virtual network. | `list(string)` | n/a | yes |
| <a name="input_virtual_network_bgp_community"></a> [virtual\_network\_bgp\_community](#input\_virtual\_network\_bgp\_community) | The BGP community attribute in format <as-number>:<community-value>. | `string` | `null` | no |
| <a name="input_virtual_network_ddos_protection_plan"></a> [virtual\_network\_ddos\_protection\_plan](#input\_virtual\_network\_ddos\_protection\_plan) | Service that provides DDoS mitigation, requires the ID of the plan | `string` | `null` | no |
| <a name="input_virtual_network_dns_servers"></a> [virtual\_network\_dns\_servers](#input\_virtual\_network\_dns\_servers) | List of IP addresses of DNS servers | `list(string)` | `[]` | no |
| <a name="input_virtual_network_edge_zone"></a> [virtual\_network\_edge\_zone](#input\_virtual\_network\_edge\_zone) | Specifies the Edge Zone within the Azure Region where this Virtual Network should exist. Changing this forces a new Virtual Network to be created. | `string` | `null` | no |
| <a name="input_virtual_network_flow_timeout_in_minutes"></a> [virtual\_network\_flow\_timeout\_in\_minutes](#input\_virtual\_network\_flow\_timeout\_in\_minutes) | The flow timeout in minutes for the Virtual Network, which is used to enable connection tracking for intra-VM flows. Possible values are between 4 and 30 minutes. | `number` | `null` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | The name of the virtual network. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_virtual_network_tags"></a> [virtual\_network\_tags](#input\_virtual\_network\_tags) | Map of tags that will be applied to the virtual network resource | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nat_gateway_id"></a> [nat\_gateway\_id](#output\_nat\_gateway\_id) | Outputs the ID for azurerm\_nat\_gateway |
| <a name="output_nat_gateway_resource_guid"></a> [nat\_gateway\_resource\_guid](#output\_nat\_gateway\_resource\_guid) | Outputs the GUID for azurerm\_nat\_gateway |
| <a name="output_network_security_group_id"></a> [network\_security\_group\_id](#output\_network\_security\_group\_id) | Outputs the ID for azurerm\_network\_security\_group |
| <a name="output_network_security_rule_id"></a> [network\_security\_rule\_id](#output\_network\_security\_rule\_id) | Outputs the list of azurerm\_network\_security\_rule ids |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the resource group in which to create the virtual network. |
| <a name="output_route_table_id"></a> [route\_table\_id](#output\_route\_table\_id) | Outputs the ID for azurerm\_route\_table |
| <a name="output_route_table_subnets"></a> [route\_table\_subnets](#output\_route\_table\_subnets) | Outputs the collection of subnets associated with the route table. |
| <a name="output_subnet_address_prefixes"></a> [subnet\_address\_prefixes](#output\_subnet\_address\_prefixes) | Ouputs a maps in the form: [subnet\_name = subnet\_address\_prefixes] |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | Outputs a map in the form: {subnet\_name = subnet\_id} |
| <a name="output_subnet_name"></a> [subnet\_name](#output\_subnet\_name) | Outputs the list of subnet names |
| <a name="output_virtual_network_address_space"></a> [virtual\_network\_address\_space](#output\_virtual\_network\_address\_space) | The list of address spaces used by the virtual network. |
| <a name="output_virtual_network_guid"></a> [virtual\_network\_guid](#output\_virtual\_network\_guid) | The GUID of the virtual network. |
| <a name="output_virtual_network_id"></a> [virtual\_network\_id](#output\_virtual\_network\_id) | The virtual Network Configuration ID. |
| <a name="output_virtual_network_location"></a> [virtual\_network\_location](#output\_virtual\_network\_location) | The location/region where the virtual network is created. |
| <a name="output_virtual_network_name"></a> [virtual\_network\_name](#output\_virtual\_network\_name) | The name of the virtual network. |