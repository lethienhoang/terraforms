resource "azurerm_virtual_machine" "demo-vm-instance" {
  name                  = "${var.prefix}-vm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.demo_resource_group.name
  network_interface_ids = [azurerm_network_interface.demo_network_interface.id]
  vm_size               = var.vm_size

  delete_data_disks_on_termination = true
  delete_os_disk_on_termination    = true

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
    computer_name  = "demo-instance"
    admin_username = "demo"
    #admin_password = "" is required for the windows, optional for Linux
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("mykey.pub")
      path     = "/home/demo/.ssh/authorized_keys"
    }
  }
}

# scale set 


source "azurerm_virtual_machine_scale_set" "scale_set" {
  name                = "${var.prefix}-vm-scale-set"
  location            = var.location
  resource_group_name = azurerm_resource_group.demo_resource_group.name

  # automatic rolling upgrade
  automatic_os_upgrade = true
  upgrade_policy       = "Rolling"

  rolling_upgrade_policy {
    max_batch_instance_percent               = 20
    max_unhealthy_instance_percent           = 20
    max_unheadlthy_upgraded_instance_percent = 5
    pause_time_between_batches               = "PT05"
  }

  health_probe_id = aazurerm_lb_probe.lb_probe.id

  zones = var.zones

  sku {
    name     = "Standard_A1_v2"
    tier     = "Standard"
    capacity = 2
  }

  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    lun           = 0
    caching       = "ReadWrite"
    create_option = "Empty"
    disk_size_gb  = 10
  }

  os_profile {
    computer_name_prefix = "demo-instance-1"
    admin_username       = "demo"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      key_data = file("mykey.pub")
      path     = "/home/demo/.ssh/authorized_keys"
    }
  }

  network_profile {
    name                      = "networkproifile"
    primary                   = true
    network_security_group_id = azurerm_network_security_group.allow-ssh.id
    ip_configuration {
      name                                   = "IPConfiguration"
      primary                                = true
      subnet_id                              = azurerm_subnet.subnet_demo.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool.id]
      load_balancer_inbound_nat_rules_ids    = [azurerm_lb_nat_pool.lbnatpool.id]
    }
  }
}
