# Create a resource group
resource "azurerm_resource_group" "demo" {
  name     = "${var.resource_g}-RG"
  location = "${var.location}"
}

# Create a virtual network within the resource group

resource "azurerm_virtual_network" "demo" {
  name                = "${var.virtualnetwork}-vnet"
  resource_group_name = "${azurerm_resource_group.demo.name}"
    location            = "${azurerm_resource_group.demo.location}"
  address_space       = ["10.0.0.0/16"]
  }

#Create Subnet

resource "azurerm_subnet" "front" {
    name           = "${var.subnet}"
     resource_group_name  = "${azurerm_resource_group.demo.name}"
    virtual_network_name = "${azurerm_virtual_network.demo.name}"
    address_prefix = "10.0.1.0/24"
}

resource "azurerm_subnet" "back" {
    name           = "${var.backsub}"
     resource_group_name  = "${azurerm_resource_group.demo.name}"
    virtual_network_name = "${azurerm_virtual_network.demo.name}"
        address_prefix = "10.0.2.0/24"
}

#Create network interface
resource "azurerm_network_interface" "front" {
  name                = "${var.aznetworkinterface}"
  location            = "${azurerm_resource_group.demo.location}"
  resource_group_name = "${azurerm_resource_group.demo.name}"   
  network_security_group_id = "${azurerm_network_security_group.demo.id}"

    ip_configuration {
    name                          = "frontendipconfig"
    subnet_id                     = "${azurerm_subnet.front.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = "${azurerm_public_ip.demo.id}"
  }
}

resource "azurerm_network_interface" "back" {
  name                = "${var.aznetworkinterface2}"
  location            = "${azurerm_resource_group.demo.location}"
  resource_group_name = "${azurerm_resource_group.demo.name}"   
  network_security_group_id = "${azurerm_network_security_group.demo.id}"

    ip_configuration {
    name                          = "backendipconfig"
    subnet_id                     = "${azurerm_subnet.back.id}"
    private_ip_address_allocation = "Dynamic"
  }
}

#create virtual machine

resource "azurerm_virtual_machine" "front" {
    name                  = "${var.frontend}"
      location              = "${azurerm_resource_group.demo.location}"
  resource_group_name   = "${azurerm_resource_group.demo.name}"
    network_interface_ids = ["${azurerm_network_interface.front.id}"]
  vm_size               = "Standard_B1s"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk0"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
    os_profile {
    computer_name  = "${var.frontend}"
    admin_username = "${var.username}"
    admin_password = "${var.password}"
  }
  os_profile_linux_config {
    disable_password_authentication = false
    }
    tags = {
    environment = "staging"
  }
}

resource "azurerm_virtual_machine" "back" {
    name                  = "${var.backend}"
      location              = "${azurerm_resource_group.demo.location}"
  resource_group_name   = "${azurerm_resource_group.demo.name}"
    network_interface_ids = ["${azurerm_network_interface.back.id}"]
  vm_size               = "Standard_B1s"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
    os_profile {
    computer_name  = "${var.backend}"
    admin_username = "${var.username1}"
    admin_password = "${var.password1}"
  }
  os_profile_linux_config {
    disable_password_authentication = false
    }
    tags = {
    environment = "test"
  }
}

resource "azurerm_network_security_group" "demo" {
  name                = "${var.nsg}"
  location            = "${azurerm_resource_group.demo.location}"
  resource_group_name = "${azurerm_resource_group.demo.name}"
}
  resource "azurerm_network_security_rule" "demo" {
  name                        = "${var.nsgrule}"
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.demo.name}"
  network_security_group_name = "${azurerm_network_security_group.demo.name}"
}

resource "azurerm_network_security_rule" "demo1" {
  name                        = "${var.nsgrule}-1"
  priority                    = 400
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.demo.name}"
  network_security_group_name = "${azurerm_network_security_group.demo.name}"
}

resource "azurerm_public_ip" "demo" {
  name                = "Public_IP"
  location            = "West US"
  resource_group_name         = "${azurerm_resource_group.demo.name}"
      sku = "Basic"
  allocation_method   = "Dynamic"
}

resource "azurerm_subnet_network_security_group_association" "front" {
  subnet_id                 = "${azurerm_subnet.front.id}"
  network_security_group_id = "${azurerm_network_security_group.demo.id}"
}

resource "azurerm_subnet_network_security_group_association" "back" {
  subnet_id                 = "${azurerm_subnet.back.id}"
  network_security_group_id = "${azurerm_network_security_group.demo.id}"
}

  resource "azurerm_network_security_rule" "back" {
  name                        = "${var.nsgrule}-2"
  priority                    = 500
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.demo.name}"
  network_security_group_name = "${azurerm_network_security_group.demo.name}"
}

resource "azurerm_storage_account" "test" {
  name                     = "testaccs"
  resource_group_name      = "${azurerm_resource_group.demo.name}"
  location                 = "westus"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "test" {
  name                  = "vhds"
  resource_group_name   = "${azurerm_resource_group.demo.name}"
  storage_account_name  = "${azurerm_storage_account.test.name}"
  container_access_type = "private"
}

/*resource "azurerm_storage_blob" "testblob" {
  name = "sample.vhd"
  resource_group_name    = "${azurerm_resource_group.demo.name}"
  storage_account_name   = "${azurerm_storage_account.test.name}"
  storage_container_name = "${azurerm_storage_container.test.name}"

  type = "page"
  size = 10
}*/

resource "azurerm_managed_disk" "test" {
  name                 = "disk1"
  location             = "${azurerm_resource_group.demo.location}"
  resource_group_name  = "${azurerm_resource_group.demo.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}

resource "azurerm_virtual_machine_data_disk_attachment" "test" {
  managed_disk_id    = "${azurerm_managed_disk.test.id}"
  virtual_machine_id = "${azurerm_virtual_machine.front.id}"
  lun                = "10"
  caching            = "ReadWrite"
}