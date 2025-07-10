resource "azurerm_public_ip" "pip1" {
  name                = var.public_ip
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = var.allocation_method
}
# output "public_id" {
#   value = azurerm_public_ip.pip1.id
# }