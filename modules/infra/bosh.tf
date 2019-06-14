resource random_string "bosh_storage_account_name" {
  length  = 20
  special = false
  upper   = false
}

resource "azurestack_storage_account" "bosh_root_storage_account" {
  name                     = "${random_string.bosh_storage_account_name.result}"
  resource_group_name      = "${azurestack_resource_group.pcf_resource_group.name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "${var.env_name}"
    account_for = "bosh"
  }
}

resource "azurestack_storage_container" "bosh_storage_container" {
  name                  = "bosh"
  depends_on            = ["azurestack_storage_account.bosh_root_storage_account"]
  resource_group_name   = "${azurestack_resource_group.pcf_resource_group.name}"
  storage_account_name  = "${azurestack_storage_account.bosh_root_storage_account.name}"
  container_access_type = "private"
}

resource "azurestack_storage_container" "stemcell_storage_container" {
  name                  = "stemcell"
  depends_on            = ["azurestack_storage_account.bosh_root_storage_account"]
  resource_group_name   = "${azurestack_resource_group.pcf_resource_group.name}"
  storage_account_name  = "${azurestack_storage_account.bosh_root_storage_account.name}"
  container_access_type = "blob"
}

#resource "azurestack_storage_table" "stemcells_storage_table" {
#  name                 = "stemcells"
#  resource_group_name  = "${azurestack_resource_group.pcf_resource_group.name}"
#  storage_account_name = "${azurestack_storage_account.bosh_root_storage_account.name}"
#}

output "bosh_root_storage_account" {
  value = "${azurestack_storage_account.bosh_root_storage_account.name}"
}
