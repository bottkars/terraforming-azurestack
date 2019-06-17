resource "azurestack_public_ip" "plane" {
  name                    = "plane"
  location                = "${var.location}"
  resource_group_name     = "${var.resource_group_name}"
  public_ip_address_allocation       = "Static"
  idle_timeout_in_minutes = 30
}

resource "azurestack_lb" "web" {
  name                = "${var.env_name}-web-lb"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  frontend_ip_configuration = {
    name                 = "frontendip"
    public_ip_address_id = "${azurestack_public_ip.plane.id}"
  }
}

resource "azurestack_lb_backend_address_pool" "web-backend-pool" {
  name                = "web-backend-pool"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.web.id}"
}

resource "azurestack_lb_probe" "web-https-probe" {
  name                = "web-https-probe"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.web.id}"
  protocol            = "TCP"
  port                = 443
}

resource "azurestack_lb_rule" "web-https-rule" {
  name                = "web-https-rule"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.web.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 443
  backend_port                   = 443
  idle_timeout_in_minutes        = 30

  backend_address_pool_id = "${azurestack_lb_backend_address_pool.web-backend-pool.id}"
  probe_id                = "${azurestack_lb_probe.web-https-probe.id}"
}

resource "azurestack_lb_probe" "web-http-probe" {
  name                = "web-http-probe"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.web.id}"
  protocol            = "TCP"
  port                = 80
}

resource "azurestack_lb_rule" "web-http-rule" {
  name                = "web-http-rule"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.web.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 80
  backend_port                   = 80
  idle_timeout_in_minutes        = 30

  backend_address_pool_id = "${azurestack_lb_backend_address_pool.web-backend-pool.id}"
  probe_id                = "${azurestack_lb_probe.web-http-probe.id}"
}

resource "azurestack_lb_rule" "web-ntp" {
  name                = "web-ntp-rule"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.web.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "UDP"
  frontend_port                  = "123"
  backend_port                   = "123"

  backend_address_pool_id = "${azurestack_lb_backend_address_pool.web-backend-pool.id}"
}
