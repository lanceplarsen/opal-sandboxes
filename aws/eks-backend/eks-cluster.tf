
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "18.30.1"
  cluster_name    = var.cluster_name
  cluster_version = "1.23"
  subnet_ids         = data.terraform_remote_state.infra.outputs.private_subnets
  vpc_id = data.terraform_remote_state.infra.outputs.vpc

  cluster_enabled_log_types = ["audit","api","authenticator"]


  eks_managed_node_group_defaults = {
    root_volume_type = "gp2"
    instance_type    = "t3.small"
    iam_role_additional_policies = [
      "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    ]
  }
  eks_managed_node_groups = {
    worker = {
      name         = "worker"
      max_size     = 3
      desired_size = 3
    }
  }

  manage_aws_auth_configmap = true
  aws_auth_roles = [
    {
      rolearn  = data.terraform_remote_state.iam.outputs.eks_cluster_admin.arn
      username = data.terraform_remote_state.iam.outputs.eks_cluster_admin.name
      groups   = ["system:masters"]
    },
    {
      rolearn  = data.terraform_remote_state.iam.outputs.eks_cluster_viewer.arn
      username = data.terraform_remote_state.iam.outputs.eks_cluster_viewer.name
      groups   = ["opal:viewers"]
    },
    {
      rolearn  = data.terraform_remote_state.iam.outputs.developer_product.arn
      username = data.terraform_remote_state.iam.outputs.developer_product.name
      groups   = ["opal:developers-product"]
    },
    {
      rolearn  = data.terraform_remote_state.iam.outputs.developer_payments.arn
      username = data.terraform_remote_state.iam.outputs.developer_payments.name
      groups   = ["opal:developers-payments"]
    }
    {
      rolearn  = data.terraform_remote_state.iam.outputs.developer_data_science.arn
      username = data.terraform_remote_state.iam.outputs.developer_data_science.name
      groups   = ["opal:developers-data-science"]
    },
  ]

  cluster_tags = {
    "opal"                                                                          = ""
    "opal:eks:role:1"                                                               = data.terraform_remote_state.iam.outputs.eks_cluster_admin.name
    "opal:eks:role:2"                                                               = data.terraform_remote_state.iam.outputs.eks_cluster_viewer.name
    "opal:eks:role:3"                                                               = data.terraform_remote_state.iam.outputs.developer_product.name
    "opal:eks:role:4"                                                               = data.terraform_remote_state.iam.outputs.developer_data_science.name
    "opal:eks:role:5"                                                               = data.terraform_remote_state.iam.outputs.developer_payments.name
    "opal:group:${data.terraform_remote_state.iam.outputs.eks_cluster_viewer.name}" = var.opal_group
  }

}
