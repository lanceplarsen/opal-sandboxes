resource "aws_iam_user" "opal" {
  name = "opal"
}

resource "aws_iam_access_key" "opal" {
  user = aws_iam_user.opal.name
}

resource "aws_iam_user_policy" "opal_ro" {
  name   = "opal"
  user   = aws_iam_user.opal.name
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "sts:TagSession",
                "sts:GetFederationToken",
                "iam:GetRole",
                "iam:GetRolePolicy",
                "iam:PutRolePolicy",
                "iam:DeleteRolePolicy",
                "access-analyzer:ValidatePolicy",
                "iam:CreatePolicy",
                "iam:CreateRole",
                "iam:TagRole",
                "iam:AttachRolePolicy",
                "iam:GetPolicy",
                "ec2:DescribeInstances",
                "ssm:DescribeInstanceProperties",
                "ssm:GetConnectionStatus",
                "ssm:TerminateSession",
                "ssm:StartSession",
                "ssm:DescribeSessions",
                "ssm:SendCommand",
                "rds:DescribeDBInstances",
                "rds-db:connect",
                "sts:AssumeRole",
                "eks:DescribeCluster",
                "eks:ListClusters",
                "iam:ListRoleTags",
                "iam:ListRoles"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

output "opal_access_key_id" {
  value     = aws_iam_access_key.opal.id
  sensitive = true
}

output "opal_access_key_secret" {
  value     = aws_iam_access_key.opal.secret
  sensitive = true
}
