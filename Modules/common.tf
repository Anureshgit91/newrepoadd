module "resource_parent" {
  source         = "../Azurerm_rg_group"
  resource_group = "rg-todoapp"
  location       = "canadacentral"
}
module "Azurerm_vnet_parent" {
  depends_on          = [module.resource_parent]
  source              = "../Azurerm_vnet"
  name                = "vnet-todoapp"
  location            = "canadacentral"
  resource_group_name = "rg-todoapp"
  address_space       = ["10.92.0.0/16"]
}
module "azurerm_subnet_parent" {
  depends_on           = [module.Azurerm_vnet_parent]
  source               = "../Azurerm_subnet"
  name                 = "frontend_subnet_todoapp"
  resource_group_name  = "rg-todoapp"
  virtual_network_name = "vnet-todoapp"
  address_prefixes     = ["10.92.1.0/24"]

}
module "azurerm_backendsubnet_parent" {
  depends_on           = [module.Azurerm_vnet_parent]
  source               = "../Azurerm_subnet"
  name                 = "backend_subnet_todoapp"
  resource_group_name  = "rg-todoapp"
  virtual_network_name = "vnet-todoapp"
  address_prefixes     = ["10.92.2.0/24"]
}
module "azurerm_frontend_vm" {
  depends_on          = [module.azurerm_subnet_parent, module.frontend_public_pip]
  source              = "../Azurerm_vm"
  nic_name            = "nic_frontend"
  location            = "canadacentral"
  resource_group_name = "rg-todoapp"
  subnet1             = data.azurerm_subnet.frontend_subnet1.id
  vm_name             = "frontend-vm"
  Publisher           = "canonical"
  offer               = "0001-com-ubuntu-server-jammy"
  sku                 = "22_04-lts"
  computer_name       = "vmcomputer"
  admin_username      = "frontend_vm_user"
  admin_password      = "Frontend@123$"
  os_name             = "myosdisk2"
  vm_size             = "Standard_F2s_v2"
  sql_version         = "latest"
  public_ip_id        = data.azurerm_public_ip.pip13.id
}
module "azurerm_backend_vm" {
  depends_on          = [module.azurerm_backendsubnet_parent]
  source              = "../Azurerm_vm"
  nic_name            = "nic_backend"
  location            = "canadacentral"
  resource_group_name = "rg-todoapp"
  subnet1             = data.azurerm_subnet.backend_subnet1.id
  vm_name             = "backend-vm"
  Publisher           = "canonical"
  offer               = "0001-com-ubuntu-server-focal"
  sku                 = "20_04-lts"
  computer_name       = "vmcomputer1"
  admin_username      = "backend_vm_user"
  admin_password      = "backend@123$"
  os_name             = "myosdisk1"
  vm_size             = "Standard_F2s_v2"
  sql_version         = "latest"
  public_ip_id        = null
}
module "frontend_public_pip" {
  depends_on          = [module.resource_parent]
  source              = "../Azurerm_pip"
  public_ip           = "public_pip1"
  resource_group_name = "rg-todoapp"
  location            = "canadacentral"
  allocation_method   = "Static"
}
module "sql_server" {
  depends_on                   = [module.resource_parent]
  source                       = "../Azurerm_Sql_server"
  name                         = "sqlserver15674"
  resource_group_name          = "rg-todoapp"
  location                     = "canadacentral"
  sql_version                  = "12.0"
  administrator_login          = "adminstrator@12"
  administrator_login_password = "P@ssw0rd@123"
  minimum_tls_version          = "1.2"
}
module "sql_database1" {
  depends_on   = [module.sql_server, module.resource_parent]
  source       = "../Azurerm_Sql_database"
  name1        = "sql_database"
  server_id    = data.azurerm_mssql_server.datasql.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 1
  sku_name     = "S0"
}
# module "frontend_subnet" {
#   depends_on           = [module.azurerm_subnet_parent]
#   source               = "../Azurerm_subnet_datablock"
#   name                 = "frontend_subnet_todoapp"
#   virtual_network_name = "vnet-todoapp"
#   resource_group_name  = "rg-todoapp"
# }
# module "backend_subnet" {
#   depends_on           = [module.azurerm_backendsubnet_parent]
#   source               = "../Azurerm_subnet_datablock"
#   name                 = "backend_subnet_todoapp"
#   virtual_network_name = "vnet-todoapp"
#   resource_group_name  = "rg-todoapp"
# }
# module "publicip98" {
#   depends_on          = [module.frontend_public_pip]
#   source              = "../Azurerm_publiip_datablock"
#   publicip            = "public_pip1"
#   resource_group_name = "rg-todoapp"
# }

# module "server02" {
#   depends_on          = [module.sql_server]
#   source              = "../Azurem_server_datablock"
#   name                = "sqlserver15674"
#   resource_group_name = "rg-todoapp"
# }

data "azurerm_subnet" "frontend_subnet1" {
  depends_on = [module.azurerm_subnet_parent]
  name                 = "frontend_subnet_todoapp"
  virtual_network_name = "vnet-todoapp"
  resource_group_name  = "rg-todoapp"
}

data "azurerm_subnet" "backend_subnet1" {
  depends_on = [module.azurerm_backendsubnet_parent]
  name                 = "backend_subnet_todoapp"
  virtual_network_name = "vnet-todoapp"
  resource_group_name  = "rg-todoapp"
}

data "azurerm_public_ip" "pip13" {
  depends_on = [module.frontend_public_pip]
  name                = "public_pip1"
  resource_group_name = "rg-todoapp"
}
data "azurerm_mssql_server" "datasql" {
  depends_on = [module.sql_server]
  name                = "sqlserver15674"
  resource_group_name = "rg-todoapp"
}

