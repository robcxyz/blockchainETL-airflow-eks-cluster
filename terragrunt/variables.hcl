locals {
  ######################
  # Deployment Variables
  ######################
  namespace = "lizi-project"
  environment = "dev"
  region = "us-east-2"

  remote_state_region = "us-east-1"

//  cluster_name = "cluster-name"
  cluster_name = local.id

  ###################
  # Environment Logic
  ###################
  env_vars = {
    dev = {
//      instance_type = "t2.small"
    }
    prod = {
//      instance_type = "i3.large"
    }
  }[local.environment]

  # Imports
  secrets = yamldecode(file("${get_parent_terragrunt_dir()}/secrets.yaml"))[local.environment]

  ###################
  # Label Boilerplate
  ###################
  label_map = {
    namespace = local.namespace
    environment = local.environment
    region = local.region
  }

  remote_state_path_label_order = ["namespace", "environment", "region"]
  remote_state_path = join("/", [ for i in local.remote_state_path_label_order : lookup(local.label_map, i)])

  id_label_order = ["namespace", "environment"]
  id = join("-", [ for i in local.id_label_order : lookup(local.label_map, i)])

  name_label_order = ["namespace", "environment"]
  name = join("", [ for i in local.name_label_order : title(lookup(local.label_map, i))])

  tags = { for t in local.remote_state_path_label_order : t => lookup(local.label_map, t) }
}
