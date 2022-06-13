provider "aws" {
  region = var.region
  default_tags {
    tags = {
      opal = ""
    }
  }
}

data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../vpc/terraform.tfstate"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "payments-app" {
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

resource "aws_instance" "payments-app" {
  instance_type               = "t3.small"
  ami                         = data.aws_ami.ubuntu.id
  key_name                    = data.terraform_remote_state.vpc.outputs.ssh_key_name
  vpc_security_group_ids      = [aws_security_group.payments-app.id]
  subnet_id                   = data.terraform_remote_state.vpc.outputs.public_subnets[0]
  iam_instance_profile        = aws_iam_instance_profile.payments-app.name
  user_data                   = data.template_file.init.rendered
  associate_public_ip_address = true
  tags = {
    Name = "payments-app"
    opal = ""
    "opal:group" = var.opal_group
  }
}

data "template_file" "init" {
  template = file("${path.module}/scripts/payments.sh")
}

resource "aws_iam_instance_profile" "payments-app" {
  name = "payments-app"
  role = aws_iam_role.payments-app.name
}

resource "aws_iam_role" "payments-app" {
  name = "PaymentsApp"

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

resource "aws_iam_role_policy_attachment" "payments-app-ssm" {
  role       = aws_iam_role.payments-app.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "payments-app-cloudwatch" {
  role       = aws_iam_role.payments-app.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
