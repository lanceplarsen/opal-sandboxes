#admin
resource "aws_iam_role" "eks_cluster_admin" {
  name               = "EKSClusterAdmin"
  assume_role_policy = data.aws_iam_policy_document.opal_assume_role_policy.json
  tags = {
    "opal"       = ""
    "opal:group" = var.opal_group
  }
  max_session_duration = 1 * 60 * 60
}

resource "aws_iam_policy" "eks_cluster_admin" {
  name   = "EKSClusterAdminAccess"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ViewCluster",
      "Effect": "Allow",
      "Action": "eks:*",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eks_cluster_admin_cluster" {
  policy_arn = aws_iam_policy.eks_cluster_admin.arn
  role       = aws_iam_role.eks_cluster_admin.name
}

#view
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
        "eks:DescribeNodegroup",
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
    },
    {
      "Sid": "ViewLogs",
      "Effect": "Allow",
      "Action": [
        "logs:Describe*",
        "logs:Get*",
        "logs:List*",
        "logs:StartQuery",
        "logs:StopQuery",
        "logs:TestMetricFilter",
        "logs:FilterLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "eks_cluster_viewer" {
  name               = "EKSClusterViewer"
  assume_role_policy = data.aws_iam_policy_document.opal_assume_role_policy.json
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

#dev access
resource "aws_iam_policy" "eks_cluster_list_only" {
  name   = "EKSClusterListAccess"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ViewCluster",
      "Effect": "Allow",
      "Action": [
        "eks:ListClusters",
        "eks:DescribeCluster"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
