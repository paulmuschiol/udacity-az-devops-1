resource "azurerm_virtual_network" "udacity" {
    name = "${var.prefix}-vnet"
    address_space = [ "10.0.0.0/22" ]
    location = azurerm_resource_group.udacity.location
    resource_group_name = azurerm_resource_group.udacity.name

    tags = {
      "project" = var.project
    }
  
}

resource "azurerm_subnet" "internal-net" {
    name = "internal"
    resource_group_name = azurerm_resource_group.udacity.name
    virtual_network_name = azurerm_virtual_network.udacity.name
    address_prefixes = ["10.0.2.0/24"]

}


resource "azurerm_network_security_group" "udacity" {
    name = "${var.prefix}-network-config"
    location = azurerm_resource_group.udacity.location
    resource_group_name = azurerm_resource_group.udacity.name
    security_rule = []

    tags = {
      "project" = var.project
    }
  
}
resource "azurerm_network_security_rule" "nsr-in-http" {
    name = "InboundHttp"
    network_security_group_name = azurerm_network_security_group.udacity.name
    resource_group_name = azurerm_resource_group.udacity.name
    priority = 500
    protocol = "Tcp"
    direction = "Inbound"
    access = "Allow"
    source_port_range = "*"
    destination_port_range = "81"
    source_address_prefix = "*"
    destination_address_prefix = "10.0.2.0/24"

}

resource "azurerm_network_security_rule" "nsr-in-internal" {
    name = "InboundInternal"
    network_security_group_name = azurerm_network_security_group.udacity.name
    resource_group_name = azurerm_resource_group.udacity.name
    priority = 510
    protocol = "Tcp"
    direction = "Inbound"
    access = "Allow"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "10.0.2.0/24"
    destination_address_prefix = "10.0.2.0/24"

}

resource "azurerm_network_security_rule" "nsr-out-internal" {
    name = "OutboundInternal"
    network_security_group_name = azurerm_network_security_group.udacity.name
    resource_group_name = azurerm_resource_group.udacity.name
    priority = 520
    protocol = "Tcp"
    direction = "Outbound"
    access = "Allow"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "10.0.2.0/24"
    destination_address_prefix = "10.0.2.0/24"

}

resource "azurerm_subnet_network_security_group_association" "udacity" {
    subnet_id = azurerm_subnet.internal-net.id
    network_security_group_id = azurerm_network_security_group.udacity.id
  
}