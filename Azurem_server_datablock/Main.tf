# data "azurerm_mssql_server" "datasql" {
#   name                = var.name
#   resource_group_name = var.resource_group_name
# }

# output "server_id" {
#   value = data.azurerm_mssql_server.datasql.id
# }