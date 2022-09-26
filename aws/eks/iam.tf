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
  name = "FrontendClusterAdmin"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/opal"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

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
            "Sid": "ClusterResources",
            "Effect": "Allow",
            "Action": [
                "eks:ListFargateProfiles",
                "eks:ListNodegroups",
                "eks:DescribeFargateProfile",
                "eks:ListTagsForResource",
                "eks:DescribeIdentityProviderConfig",
                "eks:ListUpdates",
                "eks:DescribeUpdate",
                "eks:AccessKubernetesApi",
                "eks:ListAddons",
                "eks:DescribeCluster",
                "eks:ListIdentityProviderConfigs",
                "eks:DescribeAddon"
            ],
            "Resource": [
                "arn:aws:eks:${var.region}:${data.aws_caller_identity.current.account_id}:addon/${module.eks.cluster_id}/*/*",
                "arn:aws:eks:${var.region}:${data.aws_caller_identity.current.account_id}:cluster/${module.eks.cluster_id}",
                "arn:aws:eks:${var.region}:${data.aws_caller_identity.current.account_id}:fargateprofile/${module.eks.cluster_id}/*/*",
                "arn:aws:eks:${var.region}:${data.aws_caller_identity.current.account_id}:identityproviderconfig/${module.eks.cluster_id}/*/*/*",
                "arn:aws:eks:${var.region}:${data.aws_caller_identity.current.account_id}:nodegroup/${module.eks.cluster_id}/*/*"
            ]
        },
        {
            "Sid": "AccountResources",
            "Effect": "Allow",
            "Action": [
                "eks:ListClusters",
                "eks:DescribeAddonVersions"
            ],
            "Resource": "${module.eks.cluster_arn}"
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
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/opal"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

  max_session_duration = 12 * 60 * 60
}

resource "aws_iam_role_policy_attachment" "AmazonEKSViewerPolicy" {
  policy_arn = aws_iam_policy.AmazonEKSViewer.arn
  role       = aws_iam_role.eks_cluster_viewer_role.name
}
