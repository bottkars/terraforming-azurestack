locals {
  name_prefix = "${var.env_name}-plane"
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


#



# Network

resource "azurestack_subnet" "plane" {
  name                 = "${local.name_prefix}-subnet"
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${var.network_name}"
  address_prefix       = "${var.cidr}"
}

# Database

