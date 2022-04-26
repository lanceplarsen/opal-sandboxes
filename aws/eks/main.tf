provider "aws" {
  region = var.region
  default_tags {
    tags = {
      opal = ""
    }
  }
}

data "terraform_remote_state" "infra" {
  backend = "local"

  config = {
    path = "../vpc/terraform.tfstate"
  }
}
