
resource "azurerm_public_ip" "udacity" {
    name = "${var.prefix}-public-ip"
    location = azurerm_resource_group.udacity.location
    resource_group_name = azurerm_resource_group.udacity.name
    allocation_method = "Dynamic"

    tags = {
      "project" = "udacity-exam-1"
    }
}

resource "azurerm_lb" "udacity" {
    name = "${var.prefix}-lb"
    location = azurerm_resource_group.udacity.location
    resource_group_name = azurerm_resource_group.udacity.name

    frontend_ip_configuration {
        name = "PublicIPAddress"
        public_ip_address_id = azurerm_public_ip.udacity.id
    }


}

resource "azurerm_lb_backend_address_pool" "udacity" {
    loadbalancer_id = azurerm_lb.udacity.id
    name = "BackEndAddressPool"
}

