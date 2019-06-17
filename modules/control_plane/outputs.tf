output "cidr" {
  value = "${var.cidr}"
}


output "plane_lb_name" {
  value = "${azurestack_lb.plane.name}"
}

output "dns_name" {
  value = "${azurestack_dns_a_record.plane.name}.${azurestack_dns_a_record.plane.zone_name}"
}

output "network_name" {
  value = "${azurestack_subnet.plane.name}"
}

output "subnet_gateway" {
  value = "${cidrhost(var.cidr, 1)}"
}
