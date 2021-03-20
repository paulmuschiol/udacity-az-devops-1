  
resource "azurerm_availability_set" "udacity" {
    name = "${var.prefix}-availability-set"
    location = azurerm_resource_group.udacity.location
    resource_group_name = azurerm_resource_group.udacity.name

    tags = {
      "project" = var.project
    }
}

resource "azurerm_managed_disk" "udacity-data" {
    count = var.count_instances
    name = "datadisk_${count.index}"
    location = azurerm_resource_group.udacity.location
    resource_group_name = azurerm_resource_group.udacity.name
    storage_account_type = "Standard_LRS"
    create_option = "Empty"
    disk_size_gb = "2"

    tags = {
      "project" = "udacity-exam-1"
    }  
}


resource "azurerm_network_interface" "udacity-vm-nic" {
    count = var.count_instances
    name = "udacity-vm-nic-${count.index}"
    location = azurerm_resource_group.udacity.location
    resource_group_name = azurerm_resource_group.udacity.name
    ip_configuration {
      name = "internal_config"
      subnet_id = azurerm_subnet.internal-net.id
      private_ip_address_allocation = "dynamic"

    }
    tags = {
      "project" = var.project
    } 
}

resource "azurerm_linux_virtual_machine" "udacity" {
    count = var.count_instances
    name = "vm-udacity-${count.index}"
    location = azurerm_resource_group.udacity.location
    resource_group_name = azurerm_resource_group.udacity.name
    size = "Standard_B1s"
    availability_set_id = azurerm_availability_set.udacity.id
    network_interface_ids = [ element(azurerm_network_interface.udacity-vm-nic.*.id, count.index) ]
    disable_password_authentication = true
    source_image_id = var.image_id
    admin_username = "azureuser"

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
        name = "osdisk_${count.index}"
    }

    admin_ssh_key {
        public_key = file("~/.ssh/id_rsa.pub")
        username = "azureuser"
    }

    

    tags = {
      "project" = var.project
      "project-vm" = "${var.project}-vm-${count.index}"
    }
}

resource "azurerm_virtual_machine_data_disk_attachment" "udacity" {
    count = var.count_instances
    managed_disk_id = element(azurerm_managed_disk.udacity-data.*.id, count.index)
    virtual_machine_id = element(azurerm_linux_virtual_machine.udacity.*.id, count.index)
    lun = "10"
    caching = "None"
  
}

resource "azurerm_network_interface_backend_address_pool_association" "udacity" {
    count = var.count_instances
    network_interface_id = element(azurerm_network_interface.udacity-vm-nic.*.id, count.index)
    ip_configuration_name = "internal_config"
    backend_address_pool_id = azurerm_lb_backend_address_pool.udacity.id
  
}
