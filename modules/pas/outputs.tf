output "mysql_dns" {
  value = "mysql.${azurestack_dns_a_record.mysql.zone_name}"
}

output "tcp_domain" {
  value = "tcp.${azurestack_dns_a_record.tcp.zone_name}"
}

output "sys_domain" {
  value = "sys.${azurestack_dns_a_record.sys.zone_name}"
}

output "apps_domain" {
  value = "apps.${azurestack_dns_a_record.apps.zone_name}"
}

output "web_lb_name" {
  value = "${azurestack_lb.web.name}"
}

output "diego_ssh_lb_name" {
  value = "${azurestack_lb.diego-ssh.name}"
}

output "mysql_lb_name" {
  value = "${azurestack_lb.mysql.name}"
}

output "tcp_lb_name" {
  value = "${azurestack_lb.tcp.name}"
}

# Subnets

output "pas_subnet_name" {
  value = "${azurestack_subnet.pas_subnet.name}"
}

output "pas_subnet_cidr" {
  value = "${azurestack_subnet.pas_subnet.address_prefix}"
}

output "pas_subnet_gateway" {
  value = "${cidrhost(azurestack_subnet.pas_subnet.address_prefix, 1)}"
}

output "services_subnet_name" {
  value = "${azurestack_subnet.services_subnet.name}"
}

output "services_subnet_cidr" {
  value = "${azurestack_subnet.services_subnet.address_prefix}"
}

output "services_subnet_gateway" {
  value = "${cidrhost(azurestack_subnet.services_subnet.address_prefix, 1)}"
}

# Storage

output "cf_storage_account_name" {
  value = "${azurestack_storage_account.cf_storage_account.name}"
}

output "cf_storage_account_access_key" {
  sensitive = true
  value     = "${azurestack_storage_account.cf_storage_account.primary_access_key}"
}

output "cf_droplets_storage_container_name" {
  value = "${azurestack_storage_container.cf_droplets_storage_container.name}"
}

output "cf_packages_storage_container_name" {
  value = "${azurestack_storage_container.cf_packages_storage_container.name}"
}

output "cf_resources_storage_container_name" {
  value = "${azurestack_storage_container.cf_resources_storage_container.name}"
}

output "cf_buildpacks_storage_container_name" {
  value = "${azurestack_storage_container.cf_buildpacks_storage_container.name}"
}

# Deprecated

output "pas_subnet_cidrs" {
  value = ["${azurestack_subnet.pas_subnet.address_prefix}"]
}

output "services_subnet_cidrs" {
  value = ["${azurestack_subnet.services_subnet.address_prefix}"]
}
