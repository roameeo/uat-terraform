terraform {
  backend "azurerm" {
    resource_group_name  = "terraform_rg"
    storage_account_name = "sttfstate7801"
    container_name       = "tfstate"
    key                  = "f830b735-d380-4c43-b54b-73ba9ff8cd9d/infra.tfstate"
  }
}
