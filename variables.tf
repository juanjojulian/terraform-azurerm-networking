//Common variables
variable "resource_group_name" {
  description = "The name of the resource group in which to create the virtual network."
  type        = string
}

//azurerm_virtual_network variables
variable "virtual_network_name" {
  description = "The name of the virtual network. Changing this forces a new resource to be created."
  type        = string
}

variable "virtual_network_address_space" {
  description = "The address space that is used the virtual network."
  type        = list(string)
}

variable "virtual_network_location" {
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
  type        = string
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
  # validation {
  #   condition = (
  #     var.virtual_network_flow_timeout_in_minutes >= 4 &&
  #     var.virtual_network_flow_timeout_in_minutes <= 30
  #   )
  #   error_message = "Possible values for virtual_network_flow_timeout_in_minutes are between 4 and 30 minutes."
  # }
}

variable "virtual_network_tags" {
  description = "Map of tags that will be applied to the virtual network resource"
  type        = map(string)
  default     = null
}

//azurerm_subnet variables
variable "subnets" {
  description = "Map defining the subnets to be deployed, the key is the name of the subnet while the value is a list of address spaces"
  type        = map(list(string))
  default     = null
  validation {
    condition     = alltrue([for key, value in var.subnets : length(value) > 0 && length(value) < 2])
    error_message = "Sorry, Azure doesn't support yet multiple address spaces for subnets, please provide a list with only one element"
  }
}

variable "subnet_delegations" {
  description = "Map of subnet names (keys) and subnet delegations (values), please respect subnet delegations formatting as per az network vnet subnet list-available-delegations"
  type        = map(string)
  default     = {}
}

variable "subnet_service_endpoints" {
  type    = map(list(string))
  default = {}
}

variable "subnet_service_endpoint_policy_ids" {
  description = "Map of subnet names (key) and list of IDs (value) of Service Endpoint Policies to associate with the subnet."
  type        = map(list(string))
  default     = {}
}

variable "subnet_private_endpoint_network_policies_enabled" {
  description = "Enable or Disable network policies for the private endpoint on the subnet"
  type        = map(bool)
  default     = {}
}

variable "subnet_private_link_service_network_policies_enabled" {
  description = "Enable or Disable network policies for the private link service on the subnet."
  type        = map(bool)
  default     = {}
}



//This variable has to be kept updated with the output of `az network vnet subnet list-available-delegations --location westeurope | jq 'to_entries | map( {(.value.name) : .value.actions } ) | add'`
//Reason https://github.com/terraform-providers/terraform-provider-azurerm/issues/5975
variable "subnet_delegations_actions" {
  type = map(list(string))
  default = {
    "Microsoft.Web.serverFarms" : [
      "Microsoft.Network/virtualNetworks/subnets/action"
    ],
    "Microsoft.ContainerInstance.containerGroups" : [
      "Microsoft.Network/virtualNetworks/subnets/action"
    ],
    "Microsoft.Netapp.volumes" : [
      "Microsoft.Network/networkinterfaces/*",
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.HardwareSecurityModules.dedicatedHSMs" : [
      "Microsoft.Network/networkinterfaces/*",
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.ServiceFabricMesh.networks" : [
      "Microsoft.Network/virtualNetworks/subnets/action"
    ],
    "Microsoft.Logic.integrationServiceEnvironments" : [
      "Microsoft.Network/virtualNetworks/subnets/action"
    ],
    "Microsoft.Batch.batchAccounts" : [
      "Microsoft.Network/virtualNetworks/subnets/action"
    ],
    "Microsoft.Sql.managedInstances" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
      "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
    ],
    "Microsoft.Web.hostingEnvironments" : [
      "Microsoft.Network/virtualNetworks/subnets/action"
    ],
    "Microsoft.BareMetal.CrayServers" : [
      "Microsoft.Network/networkinterfaces/*",
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.Databricks.workspaces" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
      "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
    ],
    "Microsoft.BareMetal.AzureHostedService" : [
      "Microsoft.Network/networkinterfaces/*",
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.BareMetal.AzureVMware" : [
      "Microsoft.Network/networkinterfaces/*",
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.StreamAnalytics.streamingJobs" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.DBforPostgreSQL.serversv2" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.AzureCosmosDB.clusters" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.MachineLearningServices.workspaces" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.DBforPostgreSQL.singleServers" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.DBforPostgreSQL.flexibleServers" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.DBforMySQL.serversv2" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.DBforMySQL.flexibleServers" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.ApiManagement.service" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"
    ],
    "Microsoft.Synapse.workspaces" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.PowerPlatform.vnetaccesslinks" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.Network.dnsResolvers" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.Kusto.clusters" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
      "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
    ],
    "Microsoft.DelegatedNetwork.controller" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.ContainerService.managedClusters" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.PowerPlatform.enterprisePolicies" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.StoragePool.diskPools" : [
      "Microsoft.Network/virtualNetworks/read"
    ],
    "Microsoft.DocumentDB.cassandraClusters" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.Apollo.npu" : [
      "Microsoft.Network/networkinterfaces/*",
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.AVS.PrivateClouds" : [
      "Microsoft.Network/networkinterfaces/*"
    ],
    "Microsoft.Orbital.orbitalGateways" : [
      "Microsoft.Network/publicIPAddresses/join/action",
      "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Network/virtualNetworks/read",
      "Microsoft.Network/publicIPAddresses/read"
    ],
    "Microsoft.Singularity.accounts.jobs" : [
      "Microsoft.Network/networkinterfaces/*",
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.Singularity.accounts.models" : [
      "Microsoft.Network/networkinterfaces/*",
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.Singularity.accounts.npu" : [
      "Microsoft.Network/networkinterfaces/*",
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.AISupercomputer.accounts.jobs" : [
      "Microsoft.Network/networkinterfaces/*",
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.AISupercomputer.accounts.models" : [
      "Microsoft.Network/networkinterfaces/*",
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.AISupercomputer.accounts.npu" : [
      "Microsoft.Network/networkinterfaces/*",
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.LabServices.labplans" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.Fidalgo.networkSettings" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.DevCenter.networkConnection" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "NGINX.NGINXPLUS.nginxDeployments" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.CloudTest.pools" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.CloudTest.hostedpools" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.CloudTest.images" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.Codespaces.plans" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "PaloAltoNetworks.Cloudngfw.firewalls" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Qumulo.Storage.fileSystems" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.App.testClients" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.App.environments" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ],
    "Microsoft.ServiceNetworking.trafficControllers" : [
      "Microsoft.Network/virtualNetworks/subnets/join/action"
    ]
  }
}



