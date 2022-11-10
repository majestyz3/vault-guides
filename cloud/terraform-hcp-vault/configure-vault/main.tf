#------------------------------------------------------------------------------
# The best practice is to use remote state file and encrypt it since your
# state files may contains sensitive data (secrets).
#------------------------------------------------------------------------------
# terraform {
#       backend "s3" {
#             bucket = "remote-terraform-state-dev"
#             encrypt = true
#             key = "terraform.tfstate"
#             region = "us-east-1"
#       }
# }


#------------------------------------------------------------------------------
# To leverage more than one namespace, define a vault provider per namespace
#
#   admin
#    ├── salesforce
#    │   └── training
#    │       └── boundary
#    └── test
#------------------------------------------------------------------------------

provider "vault" {
  alias = "admin"
  namespace = "admin"
}

#--------------------------------------
# Create 'admin/salesforce' namespace
#--------------------------------------
resource "vault_namespace" "salesforce" {
  provider = vault.admin
  path = "salesforce"
}

provider "vault" {
  alias = "salesforce"
  namespace = "admin/salesforce"
}

#---------------------------------------------------
# Create 'admin/salesforce/training' namespace
#---------------------------------------------------
resource "vault_namespace" "training" {
  depends_on = [vault_namespace.salesforce]
  provider = vault.salesforce
  path = "training"
}

provider "vault" {
  alias = "training"
  namespace = "admin/salesforce/training"
}

#-----------------------------------------------------------
# Create 'admin/salesforce/training/boundary' namespace
#-----------------------------------------------------------
resource "vault_namespace" "boundary" {
  depends_on = [vault_namespace.training]
  provider = vault.training
  path = "boundary"
}

provider "vault" {
  alias = "boundary"
  namespace = "admin/salesforce/training/boundary"
}

#--------------------------------------
# Create 'admin/test' namespace
#--------------------------------------
resource "vault_namespace" "test" {
  provider = vault.admin
  path = "test"
}

provider "vault" {
  alias = "test"
  namespace = "admin/test"
}