
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.24.0"
  cluster_name    = var.cluster_name
  cluster_version = "1.20"
  subnets         = data.terraform_remote_state.infra.outputs.private_subnets

  vpc_id = data.terraform_remote_state.infra.outputs.vpc

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      name                 = "worker-group-1"
      instance_type        = "t3.small"
      asg_desired_capacity = 1
    }
  ]

  map_roles = [
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
      rolearn  = data.terraform_remote_state.iam.outputs.developer_frontend.arn
      username = data.terraform_remote_state.iam.outputs.developer_frontend.name
      groups   = ["opal:developers-web"]
    },
    {
      rolearn  = data.terraform_remote_state.iam.outputs.developer_frontend.arn
      username = data.terraform_remote_state.iam.outputs.developer_frontend.name
      groups   = ["opal:developers-public-api"]
    },
  ]

  cluster_tags = {
    "opal"                                                                          = ""
    "opal:eks:role:1"                                                               = data.terraform_remote_state.iam.outputs.eks_cluster_admin.name
    "opal:eks:role:2"                                                               = data.terraform_remote_state.iam.outputs.eks_cluster_viewer.name
    "opal:eks:role:3"                                                               = data.terraform_remote_state.iam.outputs.developer_frontend.name
    "opal:group:${data.terraform_remote_state.iam.outputs.eks_cluster_viewer.name}" = var.opal_group
  }

}
