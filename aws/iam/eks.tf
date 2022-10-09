resource "aws_iam_role" "eks_cluster_admin" {
  name               = "EKSClusterAdmin"
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
    },
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
    "opal"       = ""
    "opal:group" = var.opal_group
  }
  max_session_duration = 12 * 60 * 60
}

resource "aws_iam_role_policy_attachment" "eks_cluster_admin_eks_admin" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_admin.name
}

resource "aws_iam_role_policy_attachment" "eks_cluster_admin_eks_viewer" {
  policy_arn = aws_iam_policy.eks_cluster_read_only.arn
  role       = aws_iam_role.eks_cluster_admin.name
}

resource "aws_iam_role_policy_attachment" "eks_cluster_admin_iam_viewer" {
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
  role       = aws_iam_role.eks_cluster_admin.name
}

resource "aws_iam_role_policy_attachment" "eks_cluster_admin_ec2_viewer" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
  role       = aws_iam_role.eks_cluster_admin.name
}

resource "aws_iam_policy" "eks_cluster_read_only" {
  name   = "EKSClusterReadOnlyAccess"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ViewCluster",
      "Effect": "Allow",
      "Action": [
        "eks:ListClusters",
        "eks:DescribeAddonVersions",
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
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "eks_cluster_viewer" {
  name               = "EKSClusterViewer"
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
  tags = {
    "opal"       = ""
    "opal:group" = var.opal_group
  }
  max_session_duration = 12 * 60 * 60
}

resource "aws_iam_role_policy_attachment" "eks_cluster_viewer_read_only" {
  policy_arn = aws_iam_policy.eks_cluster_read_only.arn
  role       = aws_iam_role.eks_cluster_viewer.name
}
