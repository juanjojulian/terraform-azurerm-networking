//Common variables
variable "resource_group_name" {
  description = "The name of the resource group in which to create the virtual network. This module will NOT create a resource group."
  type        = string
}

variable "location" {
  description = "The location/region where all resources will be created. Changing this forces a new resource to be created."
  type        = string
}

//azurerm_route_table variables
variable "route_table" {
  description = "Map of azurerm_route_table options, if not null a new azurerm_route_table will be created"
  type = object({
    name                          = optional(string)
    disable_bgp_route_propagation = optional(bool, false)
    routes                        = optional(map(map(string)))
    tags                          = optional(map(string), null)
  })
  default = null
}

//azurerm_nat_gateway variables
variable "nat_gateway" {
  description = "Map of azurerm_nat_gateway options, if not null a new azurerm_nat_gateway will be created"
  type = object({
    name                    = optional(string)
    idle_timeout_in_minutes = optional(number, 4)
    sku_name                = optional(string, "Standard")
    zones                   = optional(list(string), null)
    tags                    = optional(map(string), null)
    public_ip               = optional(number)
    public_ip_prefix        = optional(map(number))
  })
  default = null
}

//azurerm_network_security_group variables
variable "network_security_group" {
  description = "Map of azurerm_network_security_group options, if not null a new azurerm_network_security_group will be created"
  type = object({
    name = optional(string)
    tags = optional(map(string), null)
  })
  default = null
}
variable "nsg_rules" {
  description = "List of azurerm_network_security_rule"
  type = list(object({
    access                                     = string
    direction                                  = string
    name                                       = string
    priority                                   = number
    protocol                                   = string
    description                                = optional(string, null)
    destination_address_prefix                 = optional(string)
    destination_address_prefixes               = optional(list(string))
    destination_application_security_group_ids = optional(list(string))
    destination_port_range                     = optional(string)
    destination_port_ranges                    = optional(list(string))
    source_address_prefix                      = optional(string)
    source_address_prefixes                    = optional(list(string))
    source_application_security_group_ids      = optional(list(string))
    source_port_range                          = optional(string, "*")
    source_port_ranges                         = optional(list(string))
  }))
  default = null
}

//azurerm_virtual_network variables
variable "virtual_network_name" {
  description = "The name of the virtual network. Changing this forces a new resource to be created."
  type        = string
}

variable "virtual_network_address_space" {
  description = "The address space used by the virtual network."
  type        = list(string)
}

variable "virtual_network_bgp_community" {
  description = "The BGP community attribute in format <as-number>:<community-value>."
  type        = string
  default     = null
}

variable "virtual_network_ddos_protection_plan" {
  description = "Service that provides DDoS mitigation, requires the ID of the plan"
  type        = string
  default     = null

}

variable "virtual_network_dns_servers" {
  description = "List of IP addresses of DNS servers"
  type        = list(string)
  default     = []
}

variable "virtual_network_edge_zone" {
  description = "Specifies the Edge Zone within the Azure Region where this Virtual Network should exist. Changing this forces a new Virtual Network to be created."
  type        = string
  default     = null
}

variable "virtual_network_flow_timeout_in_minutes" {
  description = "The flow timeout in minutes for the Virtual Network, which is used to enable connection tracking for intra-VM flows. Possible values are between 4 and 30 minutes."
  type        = number
  default     = null
  validation {
    condition = (
      var.virtual_network_flow_timeout_in_minutes == null ||
      (coalesce(var.virtual_network_flow_timeout_in_minutes, 0) >= 4 &&
      coalesce(var.virtual_network_flow_timeout_in_minutes, 40) <= 30)
    )
    error_message = "Possible values for virtual_network_flow_timeout_in_minutes are: null or a number between 4 and 30 minutes."
  }
}

variable "virtual_network_tags" {
  description = "Map of tags that will be applied to the virtual network resource"
  type        = map(string)
  default     = null
}

// azurerm_virtual_network_peering variables
variable "peerings" {
  description = "Map of peerings, the key is the name of the peering"
  type = map(object({
    remote_virtual_network_id    = string
    allow_virtual_network_access = optional(bool, true)
    allow_forwarded_traffic      = optional(bool, false)
    allow_gateway_transit        = optional(bool, false)
    use_remote_gateways          = optional(bool, false)
  }))
  default = null
}

// azurerm_bastion_host and associated resources variables
variable "bastion" {
  description = "Bastion to be attached to the vnet and its options, if not null a new Azure Bastion plus a Bastion Subnet will be created."
  type = object({
    AzureBastionSubnet     = string
    name                   = optional(string)
    public_ip_name         = optional(string)
    sku                    = optional(string, "Basic")
    copy_paste_enabled     = optional(bool, true)
    file_copy_enabled      = optional(bool, false)
    ip_connect_enabled     = optional(bool, false)
    scale_units            = optional(number, 2)
    shareable_link_enabled = optional(bool, false)
    tunneling_enabled      = optional(bool, false)
    tags                   = optional(map(string), null)
  })
  default = null
}

//azurerm_subnet variables
variable "subnets" {
  description = "Map defining the subnets to be deployed, the key is the name of the subnet while the value is a list of address spaces"
  type = map(object({
    address_prefixes                              = list(string)
    delegation                                    = optional(string, "")
    service_endpoints                             = optional(list(string), [])
    service_endpoint_policy_ids                   = optional(list(string), null)
    private_endpoint_network_policies_enabled     = optional(bool, true)
    private_link_service_network_policies_enabled = optional(bool, true)
    nat_gateway                                   = optional(string, null)
    route_table                                   = optional(string, null)
    network_security_group                        = optional(string, null)
  }))
  validation {
    condition     = alltrue([for key, value in var.subnets : length(value.address_prefixes) > 0 && length(value.address_prefixes) < 2])
    error_message = "Sorry, Azure doesn't support yet multiple address spaces for subnets, please provide a list with only one element"
  }
}


//Unfortunately this variable has to be kept updated with the output of `az network vnet subnet list-available-delegations --location westeurope | jq 'to_entries | map( {(.value.serviceName) : .value.actions } ) | add'`
//Reason https://github.com/terraform-providers/terraform-provider-azurerm/issues/5975
variable "subnet_delegations_actions" {
  type = map(list(string))
  default = {
    "Microsoft.Web/serverFarms" : [
      "Microsoft.Network/virtualNetworks/subnets/action"
    ],
    "Microsoft.ContainerInstance/containerGroups" : [
      "Microsoft.Network/virtualNetworks/subnets/action"
    ],
    "Microsoft.Netapp/volumes" : [
      "Microsoft.Network/networkinterfaces/*",
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.HardwareSecurityModules/dedicatedHSMs" : [
      "Microsoft.Network/networkinterfaces/*",
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.ServiceFabricMesh/networks" : [
      "Microsoft.Network/virtualNetworks/subnets/action"
    ],
    "Microsoft.Logic/integrationServiceEnvironments" : [
      "Microsoft.Network/virtualNetworks/subnets/action"
    ],
    "Microsoft.Batch/batchAccounts" : [
      "Microsoft.Network/virtualNetworks/subnets/action"
    ],
    "Microsoft.Sql/managedInstances" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
      "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
    ],
    "Microsoft.Web/hostingEnvironments" : [
      "Microsoft.Network/virtualNetworks/subnets/action"
    ],
    "Microsoft.BareMetal/CrayServers" : [
      "Microsoft.Network/networkinterfaces/*",
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.Databricks/workspaces" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
      "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
    ],
    "Microsoft.BareMetal/AzureHostedService" : [
      "Microsoft.Network/networkinterfaces/*",
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.BareMetal/AzureVMware" : [
      "Microsoft.Network/networkinterfaces/*",
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.StreamAnalytics/streamingJobs" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.DBforPostgreSQL/serversv2" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.AzureCosmosDB/clusters" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.MachineLearningServices/workspaces" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.DBforPostgreSQL/singleServers" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.DBforPostgreSQL/flexibleServers" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.DBforMySQL/serversv2" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.DBforMySQL/flexibleServers" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.DBforMySQL/servers" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.ApiManagement/service" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"
    ],
    "Microsoft.Synapse/workspaces" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.PowerPlatform/vnetaccesslinks" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.Network/dnsResolvers" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.Kusto/clusters" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
      "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
    ],
    "Microsoft.DelegatedNetwork/controller" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.ContainerService/managedClusters" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.PowerPlatform/enterprisePolicies" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.StoragePool/diskPools" : [
      "Microsoft.Network/virtualNetworks/read"
    ],
    "Microsoft.DocumentDB/cassandraClusters" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.Apollo/npu" : [
      "Microsoft.Network/networkinterfaces/*",
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.AVS/PrivateClouds" : [
      "Microsoft.Network/networkinterfaces/*"
    ],
    "Microsoft.Orbital/orbitalGateways" : [
      "Microsoft.Network/publicIPAddresses/join/action",
      "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Network/virtualNetworks/read",
      "Microsoft.Network/publicIPAddresses/read"
    ],
    "Microsoft.Singularity/accounts/networks" : [
      "Microsoft.Network/networkinterfaces/*",
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.Singularity/accounts/npu" : [
      "Microsoft.Network/networkinterfaces/*",
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.LabServices/labplans" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.Fidalgo/networkSettings" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.DevCenter/networkConnection" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "NGINX.NGINXPLUS/nginxDeployments" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.CloudTest/pools" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.CloudTest/hostedpools" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.CloudTest/images" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.Codespaces/plans" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "PaloAltoNetworks.Cloudngfw/firewalls" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Qumulo.Storage/fileSystems" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.App/testClients" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.App/environments" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.ServiceNetworking/trafficControllers" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "GitHub.Network/networkSettings" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.Network/networkWatchers" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ]
  }
}