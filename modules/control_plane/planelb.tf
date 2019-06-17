resource "azurestack_public_ip" "plane" {
  name                    = "plane"
  location                = "${var.location}"
  resource_group_name     = "${var.resource_group_name}"
  public_ip_address_allocation       = "Static"
  idle_timeout_in_minutes = 30
}

resource "azurestack_lb" "plane" {
  name                = "${var.env_name}-plane-lb"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  frontend_ip_configuration = {
    name                 = "frontendip"
    public_ip_address_id = "${azurestack_public_ip.plane.id}"
  }
}

resource "azurestack_lb_backend_address_pool" "plane-backend-pool" {
  name                = "plane-backend-pool"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.plane.id}"
}

resource "azurestack_lb_probe" "plane-https-probe" {
  name                = "plane-https-probe"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.plane.id}"
  protocol            = "TCP"
  port                = 443
}

resource "azurestack_lb_rule" "plane-https-rule" {
  name                = "plane-https-rule"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.plane.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 443
  backend_port                   = 443
  idle_timeout_in_minutes        = 30

  backend_address_pool_id = "${azurestack_lb_backend_address_pool.plane-backend-pool.id}"
  probe_id                = "${azurestack_lb_probe.plane-https-probe.id}"
}

resource "azurestack_lb_probe" "plane-http-probe" {
  name                = "plane-http-probe"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.plane.id}"
  protocol            = "TCP"
  port                = 80
}

resource "azurestack_lb_rule" "plane-http-rule" {
  name                = "plane-http-rule"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.plane.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 80
  backend_port                   = 80
  idle_timeout_in_minutes        = 30

  backend_address_pool_id = "${azurestack_lb_backend_address_pool.plane-backend-pool.id}"
  probe_id                = "${azurestack_lb_probe.plane-http-probe.id}"
}

resource "azurestack_lb_rule" "plane-ntp" {
  name                = "plane-ntp-rule"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.plane.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "UDP"
  frontend_port                  = "123"
  backend_port                   = "123"

  backend_address_pool_id = "${azurestack_lb_backend_address_pool.plane-backend-pool.id}"
}
