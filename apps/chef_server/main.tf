
resource "lxd_container" "chef_server" {
  name      = "chef-server"
  image     = "bb_chef_server-ubuntu-14.04-static-ip"
  ephemeral = false
  profiles  = ["default"]
  provisioner "local-exec" {
    command = <<EOS
      lxc exec local:${self.name} chef-server-ctl reconfigure
EOS
  }
  provisioner "local-exec" {
    command = "lxc file pull local:${self.name}/home/${var.dev_username}/.chef/${var.dev_username}.pem ~/.chef/${var.dev_username}.pem"
  }
  provisioner "remote-exec" {
    inline = [
      "su - braden -c '~/chef-repo/scripts/chef_server_upload_all.sh'"
    ]
  }
}

