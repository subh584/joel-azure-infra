

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "network" {
  name                = "testnetwork1"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.testdev1.location}"
  resource_group_name = "${azurerm_resource_group.testdev1.name}"

  tags {
          environment = "Terraform Demo for Azure"
      }
}

# Create subnet
resource "azurerm_subnet" "testSubnet1" {
    name                 = "testSubnet1"
    resource_group_name  = "${azurerm_resource_group.testdev1.name}"
    virtual_network_name = "${azurerm_virtual_network.network.name}"
    address_prefix       = "10.0.2.0/24"
}

# Create public IPs
resource "azurerm_public_ip" "publicip" {
    name                         = "myPublicIP"
    location                     = "westindia"
    resource_group_name          = "${azurerm_resource_group.testdev1.name}"
    public_ip_address_allocation = "dynamic"

    tags {
        environment = "Terraform Demo for Azure"
    }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "testNetworkSecurityGroup" {
    name                = "testNetworkSecurityGroup1"
    location            = "westindia"
    resource_group_name = "${azurerm_resource_group.testdev1.name}"

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags {
        environment = "Terraform Demo for Azure"
    }
}

# Create network interface
resource "azurerm_network_interface" "testnic" {
    name                = "myNIC"
    location            = "westindia"
    resource_group_name = "${azurerm_resource_group.testdev1.name}"
    network_security_group_id = "${azurerm_network_security_group.testNetworkSecurityGroup.id}"

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = "${azurerm_subnet.testSubnet1.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id          = "${azurerm_public_ip.publicip.id}"
    }

    tags {
        environment = "Terraform Demo for Azure"
    }
}


# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = "${azurerm_resource_group.testdev1.name}"
    }

    byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "teststorageaccount" {
    name                = "diag${random_id.randomId.hex}"
    resource_group_name = "${azurerm_resource_group.testdev1.name}"
    location            = "westindia"
    account_replication_type = "LRS"
    account_tier = "Standard"

    tags {
        environment = "Terraform Demo for Azure"
    }
}
