provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "udacity" {
  name     = "${var.prefix}-rg"
  location = var.location

  tags = {
    "project" = var.project
  }
}