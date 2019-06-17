resource "azurestack_public_ip" "uaa" {
  name                    = "uaa"
  location                = "${var.location}"
  resource_group_name     = "${var.resource_group_name}"
  public_ip_address_allocation       = "Static"
  idle_timeout_in_minutes = 30
}

resource "azurestack_lb" "uaa" {
  name                = "${var.env_name}-uaa-lb"
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

resource "azurestack_lb_probe" "uaa-8443-probe" {
  name                = "uaa-8443-probe"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.uaa.id}"
  protocol            = "TCP"
  port                = 8443
}

resource "azurestack_lb_rule" "uaa-8443-rule" {
  name                = "uaa-8443-rule"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.uaa.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 8443
  backend_port                   = 8443
  idle_timeout_in_minutes        = 30

  backend_address_pool_id = "${azurestack_lb_backend_address_pool.uaa-backend-pool.id}"
  probe_id                = "${azurestack_lb_probe.uaa-8443-probe.id}"
}
