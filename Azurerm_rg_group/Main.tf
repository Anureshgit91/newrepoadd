resource "azurerm_resource_group" "name" {
    name = var.resource_group
    location=var.location
  }