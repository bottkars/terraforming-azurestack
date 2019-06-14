provider "azurestack" {
  # NOTE: we recommend pinning the version of the Provider which should be used in the Provider block
  version = "=0.3.0"
}

# Create a resource group
resource "azurestack_resource_group" "testrg" {
  name     = "rg1"
  location = "local"
}

resource "azurestack_storage_account" "testsa" {
  name                     = "storageaccountname"
  resource_group_name      = "${azurestack_resource_group.testrg.name}"
  location                 = "local"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }
}