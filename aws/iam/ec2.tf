resource "aws_iam_role" "ec2-admin" {
  name               = "EC2Admin"
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

resource "aws_iam_role_policy_attachment" "ec2-admin" {
  role       = aws_iam_role.ec2-admin.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}
