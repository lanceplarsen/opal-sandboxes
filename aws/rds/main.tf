provider "aws" {
  region = var.region
}

data "terraform_remote_state" "infra" {
  backend = "local"

  config = {
    path = "../vpc/terraform.tfstate"
  }
}

data "aws_availability_zones" "available" {}

resource "random_password" "password" {
  length  = 16
  special = false
}

resource "aws_security_group" "rds" {
  name   = "product-db-rds"
  vpc_id = data.terraform_remote_state.infra.outputs.vpc

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "product-db-rds"
  }
}

resource "aws_db_parameter_group" "product-db" {
  name   = "product-db"
  family = "postgres14"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_subnet_group" "product-db" {
  name       = "product-db"
  subnet_ids = data.terraform_remote_state.infra.outputs.public_subnets

  tags = {
    Name = "product-db"
  }
}

resource "aws_db_instance" "product-db" {
  identifier                          = "product-db"
  db_name                             = "product"
  instance_class                      = "db.t3.micro"
  allocated_storage                   = 5
  engine                              = "postgres"
  engine_version                      = "14.1"
  username                            = "postgres"
  password                            = random_password.password.result
  db_subnet_group_name                = aws_db_subnet_group.product-db.name
  vpc_security_group_ids              = [aws_security_group.rds.id]
  parameter_group_name                = aws_db_parameter_group.product-db.name
  publicly_accessible                 = true
  skip_final_snapshot                 = true
  iam_database_authentication_enabled = true
  tags = {
    opal                  = "",
    "opal:database-name"  = "product"
    "opal:group:readonly" = var.opal_group
  }
}

resource "null_resource" "db_setup" {

  triggers = {
    always_run = timestamp()
  }

  # runs after database and security group providing external access is created
  depends_on = [aws_db_instance.product-db, aws_security_group.rds]

  provisioner "local-exec" {
    command = "psql -U postgres -d product -h ${aws_db_instance.product-db.address} -f sql/opal_users.sql -a"
    environment = {
      PGPASSWORD = random_password.password.result
    }
  }
}
