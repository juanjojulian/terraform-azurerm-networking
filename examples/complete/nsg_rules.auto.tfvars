nsg_rules = [
  {
    name                                       = "Rule1"
    access                                     = "Allow"
    direction                                  = "Inbound"
    priority                                   = "101"
    protocol                                   = "Tcp"
    source_address_prefix                      = "*"
    destination_application_security_group_ids = ["/subscriptions/XXX-XXX-XXX-XXX/resourceGroups/msdn-compute-ad-westeurope-rg/providers/Microsoft.Network/applicationSecurityGroups/msdn-ad-westeurope-asg"]
    destination_port_ranges                    = ["53", "88", "135", "139", "389", "445", "464", "636", "3268", "3269", "5722", "9389", "49152-65535"]
    description                                = "Allow TCP access from any to HUB Active Directory App Security Group"
  },
  {
    name                         = "Rule2"
    access                       = "Allow"
    direction                    = "Inbound"
    priority                     = "102"
    protocol                     = "Udp"
    source_address_prefix        = "*"
    destination_address_prefixes = ["192.168.0.0/28"]
    destination_port_ranges      = ["53", "67", "88", "123", "137", "138", "389", "445", "464", "2535", "49152-65535"]
    description                  = "Allow UDP access from any to HUB Active Directory subnet"
  },
  {
    name                       = "Rule_AzureLoadBalancer"
    access                     = "Allow"
    direction                  = "Inbound"
    priority                   = "4095"
    protocol                   = "*"
    destination_port_range     = "*"
    destination_address_prefix = "VirtualNetwork"
    source_address_prefix      = "AzureLoadBalancer"
    description                = "Allow Azure Services connectivity"
  },
  {
    name                       = "Rule_Deny"
    access                     = "Deny"
    direction                  = "Inbound"
    priority                   = "4096"
    protocol                   = "*"
    destination_port_range     = "*"
    destination_address_prefix = "VirtualNetwork"
    source_address_prefix      = "VirtualNetwork"
    description                = "Deny non permitted VirtualNetwork connectivity"
  }
]