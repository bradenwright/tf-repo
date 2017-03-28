provider "lxd" {}

data "terraform_remote_state" "chef_server" {
  backend = "local"

  config {
    path = "${path.module}/../../apps/chef_server/terraform.tfstate"
  }
}

resource "lxd_container" "chef_node" {
  count     = "${var.node_count}"
  name      = "${replace(var.recipe,"_","-")}-${count.index}"
  image     = "${var.recipe}-ubuntu-14.04-static-ip"
  ephemeral = false
  profiles  = ["default"]
  provisioner "chef" {
    environment     = "_default"
    run_list        = [  ]
    node_name       = "${replace(var.recipe,"_","-")}-${count.index}"
    server_url      = "https://${data.terraform_remote_state.chef_server.ip_address}/organizations/bb"
    recreate_client = true
    user_name       = "braden"
    user_key        = "${file("~/.chef/braden.pem")}"
    fetch_chef_certificates = true
    ssl_verify_mode = "verify_none"
    skip_install = true
  }
  provisioner "local-exec" {
    command = "lxc exec ${data.terraform_remote_state.chef_server.name} -- su - braden -c 'knife node run_list add ${self.name} recipe[${var.recipe}] && sleep 3'"
  }
  provisioner "local-exec" {
    command = "lxc exec ${data.terraform_remote_state.chef_server.name} -- su - braden -c 'knife vault refresh bb_users braden --clean --mode client'"
  }
  provisioner "remote-exec" {
    inline = [ "chef-client" ]
  }
}

