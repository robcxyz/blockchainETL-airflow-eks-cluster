terraform {
  source = "."
}

include {
  path = find_in_parent_folders()
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("variables.hcl")).locals
}

dependencies {
  paths = ["../cluster"]
}

dependency "cluster" {
  config_path = "../cluster"
}

inputs = {
  cluster_id = dependency.cluster.outputs.cluster_id
//  cluster_id = local.vars.cluster_name
//  cloud_platform = local.vars.provider
//  lb_endpoint = dependency.asg.outputs.dns_name
//  aws_worker_arn = dependency.cluster.outputs.worker_iam_role_arn
//  deployment_domain_name = dependency.network.outputs.public_regional_domain
//  kubeconfig = base64encode(dependency.cluster.outputs.kubeconfig)
}
//
//generate "provider" {
//  path = "kubernetes.tf"
//  if_exists = "overwrite"
//  contents =<<-EOF
//data "aws_eks_cluster_auth" "this" {
//  name = "${dependency.cluster.outputs.cluster_id}"
//}
//
//provider "aws" {
//  region = "${local.vars.region}"
//  skip_get_ec2_platforms     = true
//  skip_metadata_api_check    = true
//  skip_region_validation     = true
//  skip_requesting_account_id = true
//}
//
//provider "helm" {
//  version = "=1.1.1"
//  kubernetes {
//    host                   = "${dependency.cluster.outputs.cluster_endpoint}"
//    cluster_ca_certificate = base64decode("${dependency.cluster.outputs.cluster_certificate_authority_data}")
//    token                  = data.aws_eks_cluster_auth.this.token
//    load_config_file       = false
//  }
//}
//
//provider "kubernetes" {
//    host                   = "${dependency.cluster.outputs.cluster_endpoint}"
//    cluster_ca_certificate = base64decode("${dependency.cluster.outputs.cluster_certificate_authority_data}")
//    token                  = data.aws_eks_cluster_auth.this.token
//    load_config_file       = false
//}
//EOF
//}
