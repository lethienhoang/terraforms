resource "azurerm_virtual_network" "demo_virtual_network" {
  name                = "${var.prefix}-network"
  location            = var.location
  resource_group_name = azurerm_resource_group.demo_resource_group.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet_demo" {
  name                 = "${var.prefix}-subnet-1"
  resource_group_name  = azurerm_resource_group.demo_resource_group.name
  virtual_network_name = azurerm_virtual_network.demo_virtual_network.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_network_security_group" "allow-ssh" {
  name                = "${var.prefix}-allow-ssh"
  location            = var.location
  resource_group_name = azurerm_resource_group.demo_resource_group.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.ssh_source_address
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "public_ip_demo" {
  name                = "${var.prefix}-public-ip-1"
  location            = var.location
  resource_group_name = azurerm_resource_group.demo_resource_group.name
  allocation_method   = "Dynamic"
}


resource "azurerm_network_interface" "demo_network_interface" {
  name                = "${var.prefix}-nw-1"
  resource_group_name = azurerm_resource_group.demo_resource_group.name
  location = var.location

  ip_configuration {
    name                          = "${var.prefix}-ip-1"
    subnet_id                     = azurerm_subnet.subnet_demo.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip_demo.id
  }
}
