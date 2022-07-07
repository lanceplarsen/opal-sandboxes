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
      rolearn  = aws_iam_role.eks_cluster_admin_role.arn
      username = aws_iam_role.eks_cluster_admin_role.name
      groups   = ["system:masters"]
    },
    {
      rolearn  = aws_iam_role.eks_cluster_viewer_role.arn
      username = aws_iam_role.eks_cluster_viewer_role.name
      groups   = ["viewers"]
    },
  ]

  cluster_tags = {
    "opal"                                                    = ""
    "opal:eks:role:1"                                         = aws_iam_role.eks_cluster_admin_role.name
    "opal:eks:role:2"                                         = aws_iam_role.eks_cluster_viewer_role.name
    "opal:group:${aws_iam_role.eks_cluster_viewer_role.name}" = var.opal_group
  }

}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
