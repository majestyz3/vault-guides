# Enable kv-v2 secrets engine in the salesforce namespace
resource "vault_mount" "kv-v2" {
  depends_on = [vault_namespace.salesforce]
  provider = vault.salesforce
  path = "kv-v2"
  type = "kv-v2"
}

# Enable kv-v2 secrets engine in the 'admin/test' namespace at 'secret' path
resource "vault_mount" "secret" {
  depends_on = [vault_namespace.test]
  provider = vault.test
  path = "secret"
  type = "kv-v2"
}

# Enable Transit secrets engine at 'transit' in the 'admin/salesforce' namespace
resource "vault_mount" "transit" {
  depends_on = [vault_namespace.salesforce]
  provider = vault.salesforce
  path = "transit"
  type = "transit"
}

# Creating an encryption key named 'payment'
resource "vault_transit_secret_backend_key" "key" {
  depends_on = [vault_mount.transit]
  provider = vault.salesforce
  backend    = "transit"
  name       = "payment"
  deletion_allowed = true
}
