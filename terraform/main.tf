
# Create a resource group

resource "azurerm_resource_group" "rg" {
  name     = var.rg
  location = var.location
}

# Create a virtual network within the resource group


resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet
  address_space       = var.vnet-add
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Creating Subnet 

resource "azurerm_subnet" "sub" {
  name                 = var.subnet
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = var.vnet
  address_prefixes     = var.sub-add
  depends_on           = [azurerm_virtual_network.vnet]
}

# create public ip

resource "azurerm_public_ip" "vm-pip" {
  name                = "Vm-pip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  allocation_method   = "Static"
}

## Create NIC

resource "azurerm_network_interface" "nic" {
  name                = var.nic
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "conf-testvm"
    subnet_id                     = azurerm_subnet.sub.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm-pip.id

  }
}
  
#Create VM 

resource "azurerm_windows_virtual_machine" "vm-name" {
  name                  = var.vm-name
  #name                  = "${var.vm-name}-${format("%02d",count.index)}" We can ALSO USE THIS FORMAT AND THE ONE BELOW AS WELL
#   name                  = "${var.vm-name}-${count.index+1}"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  size                  = "Standard_E2s_v3"
  admin_username        = var.name
  admin_password        = var.pass
  network_interface_ids = [azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "microsoftwindowsdesktop"
    offer     = "windows-11"
    sku       = "win11-21h2-pro"
    version   = "latest"
  }
}