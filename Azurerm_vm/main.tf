resource "azurerm_network_interface" "frontend_nic" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "nic_configuration1"
    subnet_id                     = var.subnet1
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = var.public_ip_id
  }
}

resource "azurerm_virtual_machine" "vm1" {
    depends_on = [azurerm_network_interface.frontend_nic]
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.frontend_nic.id]
  vm_size               = var.vm_size
  delete_os_disk_on_termination = true


  storage_image_reference {
    publisher = var.Publisher
    offer     = var.offer
    sku       = var.sku
    version    = var.sql_version
  }
 os_profile {
    computer_name  = var.computer_name
    admin_username = var.admin_username
    admin_password = var.admin_password
  }
  storage_os_disk {
    name              = var.os_name
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
  }
  
  os_profile_linux_config {
    disable_password_authentication = false
  }
}
