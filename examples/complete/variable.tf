variable "nsg_rules" {
  description = "list of NSG Rules maps to be applied in the module NSG"
  type = list(object({
    access                                     = string
    direction                                  = string
    name                                       = string
    priority                                   = number
    protocol                                   = string
    description                                = optional(string, null)
    destination_address_prefix                 = optional(string, null)
    destination_address_prefixes               = optional(list(string))
    destination_application_security_group_ids = optional(list(string))
    destination_port_range                     = optional(string, null)
    destination_port_ranges                    = optional(list(string))
    source_address_prefix                      = optional(string, "*")
    source_address_prefixes                    = optional(list(string), null)
    source_application_security_group_ids      = optional(list(string), null)
    source_port_range                          = optional(string, null)
    source_port_ranges                         = optional(list(string), null)
  }))
  default = null
}

variable "routes" {
  description = "map of routes to be applied in the module Route Table"
  type        = map(map(string))
  default     = null
}