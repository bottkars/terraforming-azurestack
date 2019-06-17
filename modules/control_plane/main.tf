locals {
  name_prefix = "${var.env_name}-plane"
  web_ports   = [80, 443, 8443, 8844, 2222]
}

# DNS

resource "azurestack_dns_a_record" "plane" {
  resource_group_name = "${var.resource_group_name}"
  name                = "plane"
  zone_name           = "${var.dns_zone_name}"
  ttl                 = "60"
  records             = ["${azurestack_public_ip.plane.ip_address}"]
}

# Load Balancers

resource "azurestack_public_ip" "plane" {
  resource_group_name = "${var.resource_group_name}"
  name                = "${local.name_prefix}-ip"
  location            = "${var.location}"
  public_ip_address_allocation   = "Static"
}

resource "azurestack_lb" "plane" {
  resource_group_name = "${var.resource_group_name}"
  name                = "${var.env_name}-lb"
  location            = "${var.location}"

  frontend_ip_configuration {
    name                 = "${local.name_prefix}-ip"
    public_ip_address_id = "${azurestack_public_ip.plane.id}"
  }
}

resource "azurestack_lb_backend_address_pool" "plane" {
  resource_group_name = "${var.resource_group_name}"
  name                = "${local.name_prefix}-pool"
  loadbalancer_id     = "${azurestack_lb.plane.id}"
}

resource "azurestack_lb_probe" "plane" {
  resource_group_name = "${var.resource_group_name}"
  count               = "${length(local.web_ports)}"
  name                = "${local.name_prefix}-${element(local.web_ports, count.index)}-probe"

  port     = "${element(local.web_ports, count.index)}"
  protocol = "Tcp"

  loadbalancer_id     = "${azurestack_lb.plane.id}"
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurestack_lb_rule" "plane" {
  resource_group_name = "${var.resource_group_name}"
  count               = "${length(local.web_ports)}"
  name                = "${local.name_prefix}-${element(local.web_ports, count.index)}"

  protocol                       = "Tcp"
  loadbalancer_id                = "${azurestack_lb.plane.id}"
  frontend_port                  = "${element(local.web_ports, count.index)}"
  backend_port                   = "${element(local.web_ports, count.index)}"
  backend_address_pool_id        = "${azurestack_lb_backend_address_pool.plane.id}"
  frontend_ip_configuration_name = "${azurestack_public_ip.plane.name}"
  probe_id                       = "${element(azurestack_lb_probe.plane.*.id, count.index)}"
}

# Firewall

resource "azurestack_network_security_group" "plane" {
  name                = "${local.name_prefix}-security-group"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
}

resource "azurestack_network_security_rule" "plane" {
  resource_group_name = "${var.resource_group_name}"
  network_security_group_name = "${azurestack_network_security_group.plane.name}"

  name                       = "${local.name_prefix}-security-group-rule"
  priority                   = 100
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range    = "${local.web_ports}"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
}

# Network

resource "azurestack_subnet" "plane" {
  name                 = "${local.name_prefix}-subnet"
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${var.network_name}"
  address_prefix       = "${var.cidr}"
}

# Database

