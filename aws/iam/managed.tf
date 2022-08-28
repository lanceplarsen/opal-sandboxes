#Administrator Access
resource "aws_iam_role" "admin" {
  name               = "AdministratorAccess"
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

resource "aws_iam_role_policy_attachment" "admin" {
  role       = aws_iam_role.admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

#View Only
resource "aws_iam_role" "view-only" {
  name               = "ViewOnly"
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

resource "aws_iam_role_policy_attachment" "view-only" {
  role       = aws_iam_role.view-only.name
  policy_arn = "arn:aws:iam::aws:policy/ViewOnlyAccess"
}

#Power User
resource "aws_iam_role" "power-user" {
  name               = "PowerUser"
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

resource "aws_iam_role_policy_attachment" "power-user" {
  role       = aws_iam_role.power-user.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

#Security Audit
resource "aws_iam_role" "security-audit" {
  name               = "SecurityAudit"
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

resource "aws_iam_role_policy_attachment" "security-audit" {
  role       = aws_iam_role.security-audit.name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}
