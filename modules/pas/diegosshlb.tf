resource "azurestack_public_ip" "diego-ssh-lb-public-ip" {
  name                = "diego-ssh-lb-public-ip"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  public_ip_address_allocation   = "Static"
}

resource "azurestack_lb" "diego-ssh" {
  name                = "${var.env_name}-diego-ssh-lb"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  frontend_ip_configuration = {
    name                 = "frontendip"
    public_ip_address_id = "${azurestack_public_ip.diego-ssh-lb-public-ip.id}"
  }
}

resource "azurestack_lb_backend_address_pool" "diego-ssh-backend-pool" {
  name                = "diego-ssh-backend-pool"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.diego-ssh.id}"
}

resource "azurestack_lb_probe" "diego-ssh-probe" {
  name                = "diego-ssh-probe"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.diego-ssh.id}"
  protocol            = "TCP"
  port                = 2222
}

resource "azurestack_lb_rule" "diego-ssh-rule" {
  name                = "diego-ssh-rule"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.diego-ssh.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 2222
  backend_port                   = 2222

  backend_address_pool_id = "${azurestack_lb_backend_address_pool.diego-ssh-backend-pool.id}"
  probe_id                = "${azurestack_lb_probe.diego-ssh-probe.id}"
}

resource "azurestack_lb_rule" "diego-ssh-ntp" {
  name                = "diego-ssh-ntp-rule"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.diego-ssh.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "UDP"
  frontend_port                  = "123"
  backend_port                   = "123"

  backend_address_pool_id = "${azurestack_lb_backend_address_pool.diego-ssh-backend-pool.id}"
}
