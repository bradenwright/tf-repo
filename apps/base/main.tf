
module "base" {
  source = "./../../shared/chef_node"
  node_count = "1"
  recipe = "bb_base"
}

