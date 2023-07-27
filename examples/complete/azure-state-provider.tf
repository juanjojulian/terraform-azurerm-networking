terraform {
  backend "azurerm" {
    key                  = ""
    storage_account_name = ""
    container_name       = ""
    subscription_id      = ""
    use_azuread_auth     = true
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.65.0"
    }
  }


}

provider "azurerm" {
  subscription_id = ""
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}