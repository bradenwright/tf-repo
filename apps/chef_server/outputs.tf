output "name" {
  value = "${lxd_container.chef_server.name}"
}

output "ip_address" {
  value = "${lxd_container.chef_server.ip_address}"
}
