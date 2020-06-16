locals {
  vars = read_terragrunt_config(find_in_parent_folders("${get_parent_terragrunt_dir()}/variables.hcl"))
}

remote_state {
  backend = "s3"
  config = {
    encrypt = true
      region = local.vars.locals.remote_state_region
    key = "${local.vars.locals.remote_state_path}/${path_relative_to_include()}/terraform.tfstate"
    bucket = "terraform-states-${get_aws_account_id()}"
    dynamodb_table = "terraform-locks-${get_aws_account_id()}"
  }

  generate = {
    path = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

inputs = merge(
local.vars.locals,
local.vars.locals.env_vars,
local.vars.locals.secrets,
)
