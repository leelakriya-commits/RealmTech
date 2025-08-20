# Configure the Azure provider, you can have many
# if you use azurerm provider, it's source is hashicorp/azurerm
# short for registry.terraform.io/hashicorp/azurerm


terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.12.0"
    }
  }

  required_version = ">= 1.9.0"
}
# configures the provider

provider "azurerm" {
  features {}
  subscription_id = "884910e6-bcf0-4484-8432-127ce8c5bc9c"
  client_id       = "6d097b90-f733-4519-98e6-979d7f6a402c"
  tenant_id       = "dc180534-22ba-4f5d-a576-b51fd61fa086"
}
