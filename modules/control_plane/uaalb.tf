resource "azurestack_public_ip" "uaa" {
  name                    = "uaa"
  location                = "${var.location}"
  resource_group_name     = "${var.resource_group_name}"
  public_ip_address_allocation       = "Static"
  idle_timeout_in_minutes = 30
}

resource "azurestack_lb" "uaa" {
  name                = "${var.env_name}-uaa"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  frontend_ip_configuration = {
    name                 = "frontendip"
    public_ip_address_id = "${azurestack_public_ip.uaa.id}"
  }
}

resource "azurestack_lb_backend_address_pool" "uaa-backend-pool" {
  name                = "uaa-backend-pool"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.uaa.id}"
}

resource "azurestack_lb_probe" "uaa-https-probe" {
  name                = "uaa-https-probe"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.uaa.id}"
  protocol            = "TCP"
  port                = 443
}

resource "azurestack_lb_rule" "uaa-https-rule" {
  name                = "uaa-https-rule"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.uaa.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 443
  backend_port                   = 443
  idle_timeout_in_minutes        = 30

  backend_address_pool_id = "${azurestack_lb_backend_address_pool.uaa-backend-pool.id}"
  probe_id                = "${azurestack_lb_probe.uaa-https-probe.id}"
}

resource "azurestack_lb_probe" "uaa-http-probe" {
  name                = "uaa-http-probe"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.uaa.id}"
  protocol            = "TCP"
  port                = 80
}

resource "azurestack_lb_rule" "uaa-http-rule" {
  name                = "uaa-http-rule"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.uaa.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 80
  backend_port                   = 80
  idle_timeout_in_minutes        = 30

  backend_address_pool_id = "${azurestack_lb_backend_address_pool.uaa-backend-pool.id}"
  probe_id                = "${azurestack_lb_probe.uaa-http-probe.id}"
}

resource "azurestack_lb_rule" "uaa-ntp" {
  name                = "uaa-ntp-rule"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.uaa.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "UDP"
  frontend_port                  = "123"
  backend_port                   = "123"

  backend_address_pool_id = "${azurestack_lb_backend_address_pool.uaa-backend-pool.id}"
}
