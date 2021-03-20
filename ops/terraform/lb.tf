resource "azurerm_public_ip" "udacity" {
    name = "${var.prefix}-public-ip"
    location = azurerm_resource_group.udacity.location
    resource_group_name = azurerm_resource_group.udacity.name
    allocation_method = "Dynamic"
    domain_name_label = "pmu-udacity-test"

    tags = {
      "project" = var.project
    }
}

output "lb_ip_address" {
    value = azurerm_public_ip.udacity.ip_address
    description = "public IP address of LB"
  
}

output "lb_fqdn" {
    value = azurerm_public_ip.udacity.fqdn
    description = "public fqdn of LB"
  
}


resource "azurerm_lb" "udacity" {
    name = "${var.prefix}-lb"
    location = azurerm_resource_group.udacity.location
    resource_group_name = azurerm_resource_group.udacity.name

    frontend_ip_configuration {
        name = "PublicIPAddress"
        public_ip_address_id = azurerm_public_ip.udacity.id
    }

    tags = {
      "project" = var.project
    }

}

resource "azurerm_lb_backend_address_pool" "udacity" {
    loadbalancer_id = azurerm_lb.udacity.id
    name = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "udacity" {
    name = "${var.prefix}-lb-probe" 
    resource_group_name = azurerm_resource_group.udacity.name
    port = 80
    protocol = "tcp"
    interval_in_seconds = 60
    number_of_probes = 2
    loadbalancer_id = azurerm_lb.udacity.id
}

resource "azurerm_lb_rule" "udacity" {
    name = "${var.prefix}-lb-rule" 
    resource_group_name = azurerm_resource_group.udacity.name
    backend_address_pool_id = azurerm_lb_backend_address_pool.udacity.id
    probe_id = azurerm_lb_probe.udacity.id
    protocol = "tcp"
    backend_port = 81
    frontend_port = 80
    idle_timeout_in_minutes = 15
    frontend_ip_configuration_name = "PublicIPAddress"
    loadbalancer_id = azurerm_lb.udacity.id
  
}
