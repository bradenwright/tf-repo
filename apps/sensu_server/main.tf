
module "sensu_server" {
  source = "./../../shared/chef_node"
  node_count = "1"
  recipe = "bb_sensu"
}

