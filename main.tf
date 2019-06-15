provider "azurestack" {
  # NOTE: we recommend pinning the version of the Provider which should be used in the Provider block
  version = "0.7.0"
}
variable "ops_manager_image_uri" {
  type        = "string"
  description = "Ops Manager image on Azure. Ops Manager VM will be skipped if this is empty"
}

# Create a resource group
resource "azurestack_resource_group" "test" {
  name     = "rg1"
  location = "${var.location}"
}


resource "azurestack_image" "test" {
  name                = "acctest"
  location            = "local"
  resource_group_name = "${azurestack_resource_group.test.name}"

  os_disk {
    os_type  = "Linux"
    os_state = "Generalized"
    blob_uri = "{var.ops_manager_image_uri}"
    size_gb  = 30
  }
}