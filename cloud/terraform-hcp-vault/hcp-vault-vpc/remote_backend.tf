terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "hashicorp-zarkesh"
    workspaces {
      name = "hcp-setup-vault-terraform-provider"
    }
  }
}