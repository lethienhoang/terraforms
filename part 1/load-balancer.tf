
resource "azurerm_lb" "lb" {
  name                = "${var.prefix}-vm-lb"
  location            = var.location
  resource_group_name = azurerm_resource_group.demo_resource_group.name

  frontend_ip_configuration {
    name                 = "${var.prefix}-vm-PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.public_ip_demo.id
  }
}

resource "azurerm_lb_probe" "lb_probe" {
  name                = "${var.prefix}-vm-http-probe"
  resource_group_name = azurerm_resource_group.demo_resource_group.name
  protocol            = "http"
  request_path        = "/"
  port                = 80
  loadbalancer_id     = azurerm_lb.lb.id
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  resource_group_name = zurerm_resource_group.demo_resource_group.name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "${var.prefix}-vm-BackEndAddressPool"
}

resource "azurerm_lb_nat_pool" "lbnatpool" {
  resource_group_name            = azurerm_resource_group.demo_resource_group.name
  name                           = "${var.prefix}-vm-ssh"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
}
