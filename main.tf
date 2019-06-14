provider "azurestack" {
  # NOTE: we recommend pinning the version of the Provider which should be used in the Provider block
  version = "0.6.0"
}

# Create a resource group
resource "azurestack_resource_group" "test" {
  name     = "rg1"
  location = "${var.location}"
}

resource "azurestack_storage_account" "testsa" {
  name                     = "storageaccountname"
  resource_group_name      = "${azurestack_resource_group.test.name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }
}

resource "azurestack_storage_container" "test" {
  name                  = "vhds"
  resource_group_name   = "${azurestack_resource_group.test.name}"
  storage_account_name  = "${azurestack_storage_account.test.name}"
  container_access_type = "private"
}

resource "azurestack_storage_blob" "testsb" {
  name = "sample.vhd"

  resource_group_name    = "${azurestack_resource_group.test.name}"
  storage_account_name   = "${azurestack_storage_account.test.name}"
  storage_container_name = "${azurestack_storage_container.test.name}"
  source_uri = "https://opsmanagerimage.blob.westus.stackpoc.com/images/ops-manager-2.5.2-build.172.vhd"  
  type = "page"
  
}