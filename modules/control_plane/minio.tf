resource "azurestack_public_ip" "minio" {
  name                    = "minio"
  location                = "${var.location}"
  resource_group_name     = "${var.resource_group_name}"
  public_ip_address_allocation       = "Static"
  idle_timeout_in_minutes = 30
}

resource "azurestack_lb" "minio" {
  name                = "${var.env_name}-minio"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  frontend_ip_configuration = {
    name                 = "frontendip"
    public_ip_address_id = "${azurestack_public_ip.minio.id}"
  }
}

resource "azurestack_lb_backend_address_pool" "minio-backend-pool" {
  name                = "minio-backend-pool"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.minio.id}"
}

resource "azurestack_lb_probe" "minio-9000-probe" {
  name                = "minio-9000-probe"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.minio.id}"
  protocol            = "TCP"
  port                = 9000
}

resource "azurestack_lb_rule" "minio-9000-rule" {
  name                = "minio-9000-rule"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurestack_lb.minio.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 9000
  backend_port                   = 9000
  idle_timeout_in_minutes        = 30

  backend_address_pool_id = "${azurestack_lb_backend_address_pool.minio-backend-pool.id}"
  probe_id                = "${azurestack_lb_probe.minio-9000-probe.id}"
}



