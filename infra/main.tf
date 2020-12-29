# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.41"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  defined_tags = merge(var.tag, {
    owner       = var.app
    environment = var.env
  })
}

module "core" {
  source = "./core"

  env             = var.env
  location        = var.location
  location_suffix = var.location_suffix
  app             = var.app
  acr             = var.acr
  acr_rg          = var.acr_rg
  tags            = local.defined_tags
}
