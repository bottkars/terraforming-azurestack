provider "azurestack" {
  # NOTE: we recommend pinning the version of the Provider which should be used in the Provider block
  version = "0.7.0"
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
  env_short_name = "${var.env_short_name}"
  location = "${var.location}"
  ops_manager_image_source  = "${var.ops_manager_image_source}"
  ops_manager_vm_size    = "${var.ops_manager_vm_size}"
  ops_manager_private_ip = "${var.ops_manager_private_ip}"

  optional_ops_manager_image_source = "${var.optional_ops_manager_image_source}"

  resource_group_name = "${module.infra.resource_group_name}"
  dns_zone_name       = "${module.infra.dns_zone_name}"
  security_group_id   = "${module.infra.security_group_id}"
  subnet_id           = "${module.infra.infrastructure_subnet_id}"
}

module "pas" {
  source = "../modules/pas"

  env_name = "${var.env_name}"
  location = "${var.location}"

  pas_subnet_cidr      = "${var.pcf_pas_subnet}"
  services_subnet_cidr = "${var.pcf_services_subnet}"

  cf_storage_account_name              = "${var.cf_storage_account_name}"
  cf_buildpacks_storage_container_name = "${var.cf_buildpacks_storage_container_name}"
  cf_droplets_storage_container_name   = "${var.cf_droplets_storage_container_name}"
  cf_packages_storage_container_name   = "${var.cf_packages_storage_container_name}"
  cf_resources_storage_container_name  = "${var.cf_resources_storage_container_name}"

  resource_group_name                 = "${module.infra.resource_group_name}"
  dns_zone_name                       = "${module.infra.dns_zone_name}"
  network_name                        = "${module.infra.network_name}"
  bosh_deployed_vms_security_group_id = "${module.infra.bosh_deployed_vms_security_group_id}"
}

module "certs" {
  source = "../modules/certs"

  env_name           = "${var.env_name}"
  dns_suffix         = "${var.dns_suffix}"
  ssl_ca_cert        = "${var.ssl_ca_cert}"
  ssl_ca_private_key = "${var.ssl_ca_private_key}"
}

module "isolation_segment" {
  source = "../modules/isolation_segment"

  count = "${var.isolation_segment ? 1 : 0}"

  environment = "${var.env_name}"
  location    = "${var.location}"

  ssl_cert           = "${var.iso_seg_ssl_cert}"
  ssl_private_key    = "${var.iso_seg_ssl_private_key}"
  ssl_ca_cert        = "${var.iso_seg_ssl_ca_cert}"
  ssl_ca_private_key = "${var.iso_seg_ssl_ca_private_key}"

  resource_group_name = "${module.infra.resource_group_name}"
  dns_zone            = "${module.infra.dns_zone_name}"
}
