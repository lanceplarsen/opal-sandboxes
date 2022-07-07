provider "aws" {
  region = var.region
}

data "terraform_remote_state" "infra" {
  backend = "local"

  config = {
    path = "../vpc/terraform.tfstate"
  }
}
