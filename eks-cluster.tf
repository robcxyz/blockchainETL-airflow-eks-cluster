//provider "kubernetes" {
//  host                   = data.aws_eks_cluster.cluster.endpoint
//  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
//  token                  = data.aws_eks_cluster_auth.cluster.token
//  load_config_file       = false
//}
//
//data "aws_eks_cluster" "cluster" {
//  name = module.eks.cluster_id
//}
//
//data "aws_eks_cluster_auth" "cluster" {
//  name = module.eks.cluster_id
//}

module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  cluster_name = local.cluster_name
  subnets      = module.vpc.private_subnets

  tags = {
    Environment = "training"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  vpc_id = module.vpc.vpc_id

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.small"
      additional_userdata           = ""
      asg_desired_capacity          = 2
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    },
    {
      name                          = "worker-group-2"
      instance_type                 = "t2.medium"
      additional_userdata           = ""
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
      asg_desired_capacity          = 1
    },
  ]
}

resource "null_resource" "kube_config" {
  provisioner "local-exec" {
    command = "aws eks --region $REGION update-kubeconfig --name $CLUSTER_ID"
    environment = {
      REGION     = var.region
      CLUSTER_ID = module.eks.cluster_id
    }
  }
}
