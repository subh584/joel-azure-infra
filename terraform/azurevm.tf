
# Create VM

resource "azurerm_virtual_machine" "testvm1" {
    name                  = "mytestVM1"
    location              = "westindia"
    resource_group_name   = "${azurerm_resource_group.testdev1.name}"
    network_interface_ids = ["${azurerm_network_interface.testnic.id}"]
    vm_size               = "Standard_DS1_v2"

    storage_os_disk {
        name              = "myOsDisk1"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "myvmmachineAzure"
        admin_username = "azureuser23"
        admin_password   = "passwd@1"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    tags {
        environment = "Terraform Demo for Azure"
    }
}
