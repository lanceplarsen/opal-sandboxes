data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "AmazonEKSAdminPolicy" {
  name   = "AmazonEKSAdminPolicy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "eks:*",
            "Resource": "${module.eks.cluster_arn}"
        }
    ]
}
EOF
}

resource "aws_iam_role" "eks_cluster_admin_role" {
  name = "FrontendClusterDeveloper"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

  tags = {
    "opal:eks:cluster-arn" = module.eks.cluster_arn
    //"opal:group:${module.eks.cluster_arn}" = var.opal_group
  }

  max_session_duration = 12 * 60 * 60
}

resource "aws_iam_role_policy_attachment" "AmazonEKSAdminPolicy" {
  policy_arn = aws_iam_policy.AmazonEKSAdminPolicy.arn
  role       = aws_iam_role.eks_cluster_admin_role.name
}

resource "aws_iam_policy" "AmazonEKSViewer" {
  name   = "AmazonEKSViewerPolicy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:DescribeCluster",
                "eks:ListClusters"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role" "eks_cluster_viewer_role" {
  name = "FrontendClusterViewer"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

  tags = {
    "opal:eks:cluster-arn" = module.eks.cluster_arn
    "opal:group:${module.eks.cluster_arn}" = var.opal_group
  }

  max_session_duration = 12 * 60 * 60
}

resource "aws_iam_role_policy_attachment" "AmazonEKSViewerPolicy" {
  policy_arn = aws_iam_policy.AmazonEKSViewer.arn
  role       = aws_iam_role.eks_cluster_viewer_role.name
}
