terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.50"
    }
  }
}

provider "azurerm" {
  subscription_id = "f830b735-d380-4c43-b54b-73ba9ff8cd9d"
  features {}
}

provider "azurerm" {
  alias           = "prod"
  subscription_id = "55e6995b-7646-44c3-8824-b63576c1b501"
  features {}
}
