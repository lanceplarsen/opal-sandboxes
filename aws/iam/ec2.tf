#ec2
resource "aws_iam_role" "ec2_admin" {
  name               = "EC2Admin"
  assume_role_policy = data.aws_iam_policy_document.opal_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ec2_admin" {
  role       = aws_iam_role.ec2_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

#SGs
resource "aws_iam_role" "security_group_admin" {
  name               = "SecurityGroupAdmin"
  assume_role_policy = data.aws_iam_policy_document.opal_assume_role_policy.json
}

resource "aws_iam_policy" "security_group_admin" {
  name   = "SecurityGroupFullAccess"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSecurityGroupReferences",
        "ec2:DescribeStaleSecurityGroups",
        "ec2:DescribeVpcs"
      ],
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "ec2:AuthorizeSecurityGroupEgress",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:DeleteSecurityGroup",
        "ec2:RevokeSecurityGroupEgress",
        "ec2:RevokeSecurityGroupIngress"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "security_group_admin" {
  role       = aws_iam_role.security_group_admin.name
  policy_arn = aws_iam_policy.security_group_admin.arn
}
