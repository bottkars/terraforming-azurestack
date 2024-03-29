provider "azurestack" {
  version = "=0.8.1"
}

terraform {
  required_version = "< 0.12.0"
}

module "infra" {
  source = "../modules/infra"

  env_name                          = "${var.env_name}"
  location                          = "${var.location}"
  dns_subdomain                     = "${var.dns_subdomain}"
  dns_suffix                        = "${var.dns_suffix}"
  pcf_infrastructure_subnet         = "${var.pcf_infrastructure_subnet}"
  pcf_virtual_network_address_space = "${var.pcf_virtual_network_address_space}"
}

module "ops_manager" {
  source = "../modules/ops_manager"

  env_name = "${var.env_name}"
  location = "${var.location}"
  env_short_name      = "${var.env_short_name}"
  ops_manager_image_uri  = "${var.ops_manager_image_uri}"
  ops_manager_vm_size    = "${var.ops_manager_vm_size}"
  ops_manager_private_ip = "${var.ops_manager_private_ip}"

  optional_ops_manager_image_uri = "${var.optional_ops_manager_image_uri}"

  resource_group_name = "${module.infra.resource_group_name}"
  dns_zone_name       = "${module.infra.dns_zone_name}"
  security_group_id   = "${module.infra.security_group_id}"
  subnet_id           = "${module.infra.infrastructure_subnet_id}"
}

module "control_plane" {
  source = "../modules/control_plane"

  resource_group_name = "${module.infra.resource_group_name}"
  env_name            = "${var.env_name}"
  env_short_name      = "${var.env_short_name}"
  dns_zone_name       = "${module.infra.dns_zone_name}"
  cidr                = "${var.plane_cidr}"
  network_name        = "${module.infra.network_name}"
  location    = "${var.location}"
}
