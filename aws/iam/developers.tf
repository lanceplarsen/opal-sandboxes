#frontend
resource "aws_iam_role" "dev_team_frontend" {
  name               = "DeveloperFrontend"
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
max_session_duration = 12 * 60 * 60
}

resource "aws_iam_role_policy_attachment" "dev_team_frontend_eks" {
  role       = aws_iam_role.dev_team_frontend.name
  policy_arn = aws_iam_policy.eks_cluster_list_only.arn
}

#backend
resource "aws_iam_role" "dev_team_backend" {
  name               = "DeveloperBackend"
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
max_session_duration = 12 * 60 * 60
}

#data-science
resource "aws_iam_role" "dev_team_data_science" {
  name               = "DeveloperDataScience"
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
max_session_duration = 12 * 60 * 60
}

#payments
resource "aws_iam_role" "dev_team_payments" {
  name               = "DeveloperPayments"
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
max_session_duration = 12 * 60 * 60
}
