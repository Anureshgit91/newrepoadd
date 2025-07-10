# data "azurerm_public_ip" "pip13" {
#   name                = var.publicip
#   resource_group_name = var.resource_group_name
# }

# output "public_id" {
#   value = data.azurerm_public_ip.pip13.id
# }