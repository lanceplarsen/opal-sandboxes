#Administrator Access
resource "aws_iam_role" "admin" {
  name               = "AdministratorAccess"
  assume_role_policy = data.aws_iam_policy_document.opal_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "admin" {
  role       = aws_iam_role.admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

#View Only
resource "aws_iam_role" "view_only" {
  name               = "ViewOnly"
  assume_role_policy = data.aws_iam_policy_document.opal_assume_role_policy.json
  tags = {
    "opal:group" = var.opal_group
  }
}

resource "aws_iam_role_policy_attachment" "view_only" {
  role       = aws_iam_role.view_only.name
  policy_arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
}

#Power User
resource "aws_iam_role" "power_user" {
  name               = "PowerUser"
  assume_role_policy = data.aws_iam_policy_document.opal_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "power_user" {
  role       = aws_iam_role.power_user.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

#Security Audit
resource "aws_iam_role" "security_audit" {
  name               = "SecurityAudit"
  assume_role_policy = data.aws_iam_policy_document.opal_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "security_audit" {
  role       = aws_iam_role.security_audit.name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

#IAM - read only
resource "aws_iam_role" "iam_read_only" {
  name               = "IAMViewer"
  assume_role_policy = data.aws_iam_policy_document.opal_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "iam_read_only" {
  role       = aws_iam_role.iam_read_only.name
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}
