
module "sg_redshift" {
  source  = "terraform-aws-modules/security-group/aws//modules/redshift"
  version = "~> 3.0"

  name   = "redshift-cluster"
  vpc_id = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
}

variable "cluster_database_name" {
  description = ""
  type        = string
  default     = "mydb"
}

variable "cluster_master_username" {
  description = ""
  type        = string
  default     = "mydbuser"
}

variable "cluster_master_password" {
  description = ""
  type        = string
  default     = "MySecretPassw0rd"
}

variable "cluster_node_type" {
  type        = string
  default     = "dc1.large"
  description = ""
}

variable "cluster_number_of_nodes" {
  type        = number
  default     = 1
  description = ""
}

variable "cluster_name" {
  default = "redshiftcluster"
}

module "redshift" {
  source  = "terraform-aws-modules/redshift/aws"
  version = "~> 2.0"

  cluster_identifier        = var.cluster_name
  final_snapshot_identifier = var.cluster_name

  cluster_node_type       = var.cluster_node_type
  cluster_number_of_nodes = var.cluster_number_of_nodes

  cluster_database_name   = var.cluster_database_name
  cluster_master_username = var.cluster_master_username
  cluster_master_password = var.cluster_master_password

  subnets                = module.vpc.redshift_subnets
  vpc_security_group_ids = [module.sg_redshift.this_security_group_id]
}
