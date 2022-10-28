data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "opal_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/opal"]
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      opal = ""
    }
  }
}
