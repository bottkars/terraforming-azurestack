resource "azurestack_public_ip" "credhub" {
  name                    = "credhub"
  location                = "${var.location}"
  resource_group_name     = "${var.resource_group_name}"
  public_ip_address_allocation       = "Static"
  idle_timeout_in_minutes = 30
}

resource "azurestack_lb" "credhub" {
  name                = "${var.env_name}-credhub-lb"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  frontend_ip_configuration = {
    name                 = "frontendip"
    public_ip_address_id = "${azurestack_public_ip.credhub.id}"
  }
}

resource "azurestack_lb_backend_address_pool" "credhub-backend-pool" {
  name                = "credhub-backend-pool"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.credhub.id}"
}

resource "azurestack_lb_probe" "credhub-8844-probe" {
  name                = "credhub-8844-probe"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.credhub.id}"
  protocol            = "TCP"
  port                = 8844
}

resource "azurestack_lb_rule" "credhub-8844-rule" {
  name                = "credhub-8844-rule"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.credhub.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 8844
  backend_port                   = 8844
  idle_timeout_in_minutes        = 30

  backend_address_pool_id = "${azurestack_lb_backend_address_pool.credhub-backend-pool.id}"
  probe_id                = "${azurestack_lb_probe.credhub-8844-probe.id}"
}



