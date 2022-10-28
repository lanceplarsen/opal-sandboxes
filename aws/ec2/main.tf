provider "aws" {
  region = var.region
}

data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../vpc/terraform.tfstate"
  }
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true


  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_security_group" "payments_app" {
  name        = "payments-app"
  description = "payments-app"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "payments_dev" {
  instance_type               = "t3.micro"
  ami                         = data.aws_ami.amazon_linux_2.id
  key_name                    = data.terraform_remote_state.vpc.outputs.ssh_key_name
  vpc_security_group_ids      = [aws_security_group.payments_app.id]
  subnet_id                   = data.terraform_remote_state.vpc.outputs.public_subnets[0]
  iam_instance_profile        = aws_iam_instance_profile.payments_app.name
  associate_public_ip_address = true
  tags = {
    Name         = "payments-dev"
    opal         = ""
    "opal:group" = var.opal_group
  }
}

resource "aws_instance" "payments_prod" {
  instance_type               = "t3.micro"
  ami                         = data.aws_ami.amazon_linux_2.id
  key_name                    = data.terraform_remote_state.vpc.outputs.ssh_key_name
  vpc_security_group_ids      = [aws_security_group.payments_app.id]
  subnet_id                   = data.terraform_remote_state.vpc.outputs.public_subnets[0]
  iam_instance_profile        = aws_iam_instance_profile.payments_app.name
  associate_public_ip_address = true
  tags = {
    Name = "payments-prod"
    opal = ""
  }
}

resource "aws_iam_instance_profile" "payments_app" {
  name = "PaymentsWorker-EC2-Instance-Profile"
  role = aws_iam_role.payments_app.name
}

resource "aws_iam_role" "payments_app" {
  name               = "PaymentsWorker-EC2-Instance-Profile"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "payments_app_ssm" {
  role       = aws_iam_role.payments_app.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "payments_app_cloudwatch" {
  role       = aws_iam_role.payments_app.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
