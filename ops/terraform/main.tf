provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "udacity" {
  name     = "${var.prefix}-resources"
  location = var.location
}