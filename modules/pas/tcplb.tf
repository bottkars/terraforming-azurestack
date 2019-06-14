resource "azurestack_public_ip" "tcp-lb-public-ip" {
  name                = "tcp-lb-public-ip"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  public_ip_address_allocation   = "Static"
}

resource "azurestack_lb" "tcp" {
  name                = "${var.env_name}-tcp-lb"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  frontend_ip_configuration = {
    name                 = "frontendip"
    public_ip_address_id = "${azurestack_public_ip.tcp-lb-public-ip.id}"
  }
}

resource "azurestack_lb_backend_address_pool" "tcp-backend-pool" {
  name                = "tcp-backend-pool"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.tcp.id}"
}

resource "azurestack_lb_probe" "tcp-probe" {
  name                = "tcp-probe"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.tcp.id}"
  protocol            = "TCP"
  port                = 80
}

resource "azurestack_lb_rule" "tcp-rule" {
  count               = 5
  name                = "tcp-rule-${count.index + 1024}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.tcp.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = "${count.index + 1024}"
  backend_port                   = "${count.index + 1024}"

  backend_address_pool_id = "${azurestack_lb_backend_address_pool.tcp-backend-pool.id}"
  probe_id                = "${azurestack_lb_probe.tcp-probe.id}"
}

resource "azurestack_lb_rule" "tcp-ntp" {
  name                = "tcp-ntp-rule"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.tcp.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "UDP"
  frontend_port                  = "123"
  backend_port                   = "123"

  backend_address_pool_id = "${azurestack_lb_backend_address_pool.tcp-backend-pool.id}"
}
