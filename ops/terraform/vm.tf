  
resource "azurerm_availability_set" "udacity" {
    name = "${var.prefix}-availability-set"
    location = azurerm_resource_group.udacity.location
    resource_group_name = azurerm_resource_group.udacity.name
}

resource "azurerm_managed_disk" "udacity" {
    count = var.count_instances
    name = "datadisk_${count.index}"
    location = azurerm_resource_group.udacity.location
    resource_group_name = azurerm_resource_group.udacity.name
    storage_account_type = "Standard_LRS"
    create_option = "Empty"
    disk_size_gb = 2

  
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
}

resource "azurerm_linux_virtual_machine" "udacity" {
    count = var.count_instances
    name = "vm-udacity-${count.index}"
    location = azurerm_resource_group.udacity.location
    resource_group_name = azurerm_resource_group.udacity.name
    size = "Standard_B2s"
    availability_set_id = azurerm_availability_set.udacity.id
    network_interface_ids = [ element(azurerm_network_interface.udacity-vm-nic.*.id, count.index) ]
    admin_username = "adminuser"

    admin_ssh_key {
        username = "adminuser"
        public_key = file("~/.ssh/id_rsa.pub")
    }

    source_image_reference {

    }

    os_disk {
        name = "osdisk-${count.index}"
        storage_account_type = "Standard_LRS"
        caching = "ReadWrite"
    }


    tags = {
      "project" = "udacity-exam-1"
      "project-vm" = "udacity-exam-1-${count.index}"
    }
}

resource "azurerm_virtual_machine_data_disk_attachment" "datadiskattachment" {
    count = var.count_instances
    managed_disk_id = element(azurerm_managed_disk.udacity.*.id, count.index)
    virtual_machine_id = element(azurerm_linux_virtual_machine.udacity.*.id, count.index)
    lun = "10"
    caching = "ReadWrite"
}

resource "azurerm_network_interface_backend_address_pool_association" "udacity" {
    count = var.count_instances
    network_interface_id = element(azurerm_network_interface.udacity-vm-nic.*.id, count.index)
    ip_configuration_name = "ipconfig1"
    backend_address_pool_id = azurerm_lb_backend_address_pool.udacity.id
  
}
