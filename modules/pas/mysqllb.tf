resource "azurestack_lb" "mysql" {
  name                = "${var.env_name}-mysql-lb"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  frontend_ip_configuration = {
    name      = "frontendip"
    subnet_id = "${azurestack_subnet.pas_subnet.id}"
  }
}

resource "azurestack_lb_backend_address_pool" "mysql-backend-pool" {
  name                = "mysql-backend-pool"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.mysql.id}"
}

resource "azurestack_lb_probe" "mysql-probe" {
  name                = "mysql-probe"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.mysql.id}"
  protocol            = "TCP"
  port                = 1936
}

resource "azurestack_lb_rule" "mysql-rule" {
  name                = "mysql-rule"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.mysql.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 3306
  backend_port                   = 3306

  backend_address_pool_id = "${azurestack_lb_backend_address_pool.mysql-backend-pool.id}"
  probe_id                = "${azurestack_lb_probe.mysql-probe.id}"
}

resource "azurestack_lb_rule" "mysql-ntp" {
  name                = "mysql-ntp-rule"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.mysql.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "UDP"
  frontend_port                  = "123"
  backend_port                   = "123"

  backend_address_pool_id = "${azurestack_lb_backend_address_pool.mysql-backend-pool.id}"
}
