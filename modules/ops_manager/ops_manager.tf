# ==================== Storage

resource "azurestack_storage_account" "ops_manager_storage_account" {
name                     = "${var.env_short_name}opsmanagerstorage"
  resource_group_name      = "${var.resource_group_name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "${var.env_name}"
    account_for = "ops-manager"
  }
}

resource "azurestack_storage_container" "ops_manager_storage_container" {
  name                  = "opsmanagerimage"
  depends_on            = ["azurestack_storage_account.ops_manager_storage_account"]
  resource_group_name   = "${var.resource_group_name}"
  storage_account_name  = "${azurestack_storage_account.ops_manager_storage_account.name}"
  container_access_type = "private"
}

resource "azurestack_storage_blob" "ops_manager_image" {
  name                   = "opsman-disk.vhd"
  resource_group_name    = "${var.resource_group_name}"
  storage_account_name   = "${azurestack_storage_account.ops_manager_storage_account.name}"
  storage_container_name = "${azurestack_storage_container.ops_manager_storage_container.name}"
  source_uri             = "${var.ops_manager_image_uri}"
}

resource "azurestack_storage_blob" "optional_ops_manager_image" {
  name                   = "optional_opsman-disk.vhd"
  resource_group_name    = "${var.resource_group_name}"
  storage_account_name   = "${azurestack_storage_account.ops_manager_storage_account.name}"
  storage_container_name = "${azurestack_storage_container.ops_manager_storage_container.name}"
  source_uri             = "${var.optional_ops_manager_image_uri}"
}

# ==================== DNS

resource "azurestack_dns_a_record" "ops_manager_dns" {
  name                = "pcf"
  zone_name           = "${var.dns_zone_name}"
  resource_group_name = "${var.resource_group_name}"
  ttl                 = "60"
  records             = ["${azurestack_public_ip.ops_manager_public_ip.ip_address}"]
}

resource "azurestack_dns_a_record" "optional_ops_manager_dns" {
  name                = "pcf-optional"
  zone_name           = "${var.dns_zone_name}"
  resource_group_name = "${var.resource_group_name}"
  ttl                 = "60"
  records             = ["${azurestack_public_ip.optional_ops_manager_public_ip.ip_address}"]
  count               = "${local.optional_ops_man_vm}"
}

# ==================== VMs

resource "azurestack_public_ip" "ops_manager_public_ip" {
  name                    = "${var.env_name}-ops-manager-public-ip"
  location                = "${var.location}"
  resource_group_name     = "${var.resource_group_name}"
  public_ip_address_allocation       = "Static"
  idle_timeout_in_minutes = 30
}

resource "azurestack_network_interface" "ops_manager_nic" {
  name                      = "${var.env_name}-ops-manager-nic"
  depends_on                = ["azurestack_public_ip.ops_manager_public_ip"]
  location                  = "${var.location}"
  resource_group_name       = "${var.resource_group_name}"
  network_security_group_id = "${var.security_group_id}"
  count                     = "${local.ops_man_vm}"

  ip_configuration {
    name                          = "${var.env_name}-ops-manager-ip-config"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.ops_manager_private_ip}"
    public_ip_address_id          = "${azurestack_public_ip.ops_manager_public_ip.id}"
  }
}

resource "azurestack_virtual_machine" "ops_manager_vm" {
  name                          = "${var.env_name}-ops-manager-vm"
  depends_on                    = ["azurestack_network_interface.ops_manager_nic", "azurestack_storage_blob.ops_manager_image"]
  location                      = "${var.location}"
  resource_group_name           = "${var.resource_group_name}"
  network_interface_ids         = ["${azurestack_network_interface.ops_manager_nic.id}"]
  vm_size                       = "${var.ops_manager_vm_size}"
  count                         = "${local.ops_man_vm}"


  
  storage_os_disk {
    name          = "opsman-disk.vhd"
    image_uri     = "${azurestack_storage_account.ops_manager_storage_account}/vhds/osdisk.vhd"
    vhd_uri     = "${azurestack_storage_blob.ops_manager_image.url}"
    caching       = "ReadWrite"
    os_type       = "linux"
    create_option = "FromImage"
    disk_size_gb  = "150"
  }


#
  os_profile {
    computer_name  = "${var.env_name}-ops-manager"
    admin_username = "ubuntu"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/ubuntu/.ssh/authorized_keys"
      key_data = "${tls_private_key.ops_manager.public_key_openssh}"
    }
  }
}

# ==================== OPTIONAL

resource "azurestack_public_ip" "optional_ops_manager_public_ip" {
  name                         = "${var.env_name}-optional-ops-manager-public-ip"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  public_ip_address_allocation = "static"
  count                        = "${local.optional_ops_man_vm}"
}

resource "azurestack_network_interface" "optional_ops_manager_nic" {
  name                      = "${var.env_name}-optional-ops-manager-nic"
  depends_on                = ["azurestack_public_ip.optional_ops_manager_public_ip"]
  location                  = "${var.location}"
  resource_group_name       = "${var.resource_group_name}"
  network_security_group_id = "${var.security_group_id}"
  count                     = "${local.optional_ops_man_vm}"

  ip_configuration {
    name                          = "${var.env_name}-optional-ops-manager-ip-config"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "10.0.8.5"
    public_ip_address_id          = "${azurestack_public_ip.optional_ops_manager_public_ip.id}"
  }
}

resource "azurestack_virtual_machine" "optional_ops_manager_vm" {
  name                  = "${var.env_name}-optional-ops-manager-vm"
  depends_on            = ["azurestack_network_interface.optional_ops_manager_nic","azurestack_storage_blob.optional_ops_manager_image"]
  location              = "${var.location}"
  resource_group_name   = "${var.resource_group_name}"
  network_interface_ids = ["${azurestack_network_interface.optional_ops_manager_nic.id}"]
  vm_size               = "${var.ops_manager_vm_size}"
  count                 = "${local.optional_ops_man_vm}"
  delete_os_disk_on_termination = "true"
  storage_os_disk {
    name          = "opsman-disk.vhd"
    vhd_uri       = "${azurestack_storage_blob.optional_ops_manager_image.url}"
    caching       = "ReadWrite"
    os_type       = "linux"
    create_option = "FromImage"
    disk_size_gb  = "150"
  }
  
  os_profile {
    computer_name  = "${var.env_name}-optional-ops-manager"
    admin_username = "ubuntu"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/ubuntu/.ssh/authorized_keys"
      key_data = "${tls_private_key.ops_manager.public_key_openssh}"
    }
  }
}
