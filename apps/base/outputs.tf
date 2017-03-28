output "name" {
  value = "${lxd_container.bb_base.name}"
}

output "ip_address" {
  value = "${lxd_container.bb_base.ip_address}"
}
