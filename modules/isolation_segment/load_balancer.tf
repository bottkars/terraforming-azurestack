resource "azurestack_public_ip" "iso-lb-public-ip" {
  name                = "iso-lb-public-ip"
  count               = "${var.count}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  public_ip_address_allocation   = "Static"
}

resource "azurestack_lb" "iso" {
  name                = "${var.environment}-iso-lb"
  count               = "${var.count}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  frontend_ip_configuration = {
    name                 = "frontendip"
    public_ip_address_id = "${azurestack_public_ip.iso-lb-public-ip.id}"
  }
}

resource "azurestack_lb_backend_address_pool" "iso-backend-pool" {
  name                = "iso-backend-pool"
  count               = "${var.count}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.iso.id}"
}

resource "azurestack_lb_probe" "iso-https-probe" {
  name                = "iso-https-probe"
  count               = "${var.count}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.iso.id}"
  protocol            = "TCP"
  port                = 443
}

resource "azurestack_lb_rule" "iso-https-rule" {
  name                = "iso-https-rule"
  count               = "${var.count}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.iso.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 443
  backend_port                   = 443

  backend_address_pool_id = "${azurestack_lb_backend_address_pool.iso-backend-pool.id}"
  probe_id                = "${azurestack_lb_probe.iso-https-probe.id}"
}

resource "azurestack_lb_probe" "iso-http-probe" {
  name                = "iso-http-probe"
  count               = "${var.count}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.iso.id}"
  protocol            = "TCP"
  port                = 80
}

resource "azurestack_lb_rule" "iso-http-rule" {
  name                = "iso-http-rule"
  count               = "${var.count}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.iso.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 80
  backend_port                   = 80

  backend_address_pool_id = "${azurestack_lb_backend_address_pool.iso-backend-pool.id}"
  probe_id                = "${azurestack_lb_probe.iso-http-probe.id}"
}
