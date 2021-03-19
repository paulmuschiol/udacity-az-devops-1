

resource "azurerm_virtual_network" "udacity" {
    name = "${var.prefix}-vnet"
    address_space = [ "10.0.0.0/22" ]
    location = azurerm_resource_group.udacity.location
    resource_group_name = azurerm_resource_group.udacity.name

    tags = {
      "project" = "udacity-exam-1"
    }
  
}

resource "azurerm_subnet" "internal-net" {
    name = "internal"
    resource_group_name = azurerm_resource_group.udacity.location
    virtual_network_name = azurerm_virtual_network.udacity.name
    address_prefixes = ["10.0.2.0/24"]

}

resource "azurerm_network_security_group" "udacity" {
    name = "${var.prefix}-network-config"
    location = azurerm_resource_group.udacity.location
    resource_group_name = azurerm_resource_group.udacity.name
    security_rule = []

    tags = {
      "project" = "udacity-exam-1"
    }
  
}

resource "azurerm_network_security_rule" "in-allow" {
    name = "Intra-Subnet-Connection-Inbound"
    network_security_group_name = azurerm_network_security_group.udacity.name
    resource_group_name = azurerm_resource_group.udacity.name
    priority = 500
    protocol = "Tcp"
    direction = "Inbound"
    access = "Allow"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "*"
    destination_address_prefix = "*"

}

resource "azurerm_network_security_rule" "out-allow" {
    name = "Intra-Subnet-Connection-Outbound"
    network_security_group_name = azurerm_network_security_group.udacity.name
    resource_group_name = azurerm_resource_group.udacity.name
    priority = 510
    protocol = "Tcp"
    direction = "Outbound"
    access = "Allow"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "*"
    destination_address_prefix = "*"

}

resource "azurerm_network_security_rule" "in-deny" {
    name = "Deny All Inbound"
    network_security_group_name = azurerm_network_security_group.udacity.name
    resource_group_name = azurerm_resource_group.udacity.name
    priority = 100
    protocol = "Tcp"
    direction = "Inbound"
    access = "Deny"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "*"
    destination_address_prefix = "*"

}

