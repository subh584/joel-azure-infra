
# Create a resource group
resource "azurerm_resource_group" "testdev1" {
  name     = "testdev1"
  location = "West India"

  tags {
        environment = "Terraform Demo for Azure"
    }
}
