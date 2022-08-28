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
