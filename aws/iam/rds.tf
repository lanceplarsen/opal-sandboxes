resource "aws_iam_role" "rds_admin" {
  name               = "RDSAdmin"
  assume_role_policy = data.aws_iam_policy_document.opal_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "rds_admin" {
  role       = aws_iam_role.rds_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}
