resource "aws_iam_role" "eks-admin" {
  name               = "EKSAdmin"
  assume_role_policy = <<EOF
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
EOF
}

resource "aws_iam_policy" "eks-admin" {
  name        = "EKSAdmin"
  description = "Admin access to EKS"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eks-admin" {
  role       = aws_iam_role.eks-admin.name
  policy_arn = aws_iam_policy.eks-admin.arn
}

resource "aws_iam_role" "eks-viewer" {
  name               = "EKSViewer"
  assume_role_policy = <<EOF
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
EOF
tags = {
  "opal:group" = var.opal_group
}
}

resource "aws_iam_policy" "eks-viewer" {
  name        = "EKSViewer"
  description = "View access to EKS"

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

resource "aws_iam_role_policy_attachment" "eks-viewer" {
  role       = aws_iam_role.eks-viewer.name
  policy_arn = aws_iam_policy.eks-viewer.arn
}
