# data "azurerm_subnet" "frontend_subnet1" {
#   name                 = var.name
#   virtual_network_name = var.virtual_network_name
#   resource_group_name  = var.resource_group_name
# }


# output "frontend_id" {
#   value = data.azurerm_subnet.frontend_subnet1.id
# }
# output "backend_id" {
#   value = data.azurerm_subnet.frontend_subnet1.id
# }