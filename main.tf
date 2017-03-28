provider "lxd" {}

module "chef_server" {
  source = "./apps/chef_server"
}

resource "lxd_container" "bb_base" {
  name      = "bb-base"
  image     = "bb_base-ubuntu-14.04-static-ip"
  ephemeral = false
  profiles  = ["default"]
  provisioner "chef" {
    environment     = "_default"
    run_list        = [  ]
    node_name       = "bb-base"
    server_url      = "https://${module.chef_server.ip_address}/organizations/bb"
    recreate_client = true
    user_name       = "braden"
    user_key        = "${file("~/.chef/braden.pem")}"
    fetch_chef_certificates = true
    ssl_verify_mode = "verify_none"
    skip_install = true
  }
  provisioner "local-exec" {
    command = "lxc exec chef-server -- su - braden -c 'knife node run_list add ${self.name} recipe[bb_base] && sleep 3'"
  }
  provisioner "local-exec" {
    command = "lxc exec chef-server -- su - braden -c 'knife vault refresh bb_users braden --clean --mode client'"
  }
  provisioner "remote-exec" {
    inline = [ "chef-client" ]
  }
}

