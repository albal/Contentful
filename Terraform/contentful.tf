terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.21.1"
    }
  }
}

provider "azurerm" {
  features {}
  tenant_id = "ba82b308-dd6b-4236-b218-6262064c27ee"
}

resource "azurerm_resource_group" "rg" {
  name     = "Contentful"
  location = "uksouth"
}

resource "azurerm_container_group" "contentful-g" {
  name                = "contentful-group"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "Public"
  dns_name_label      = "dfecontentful"
  os_type             = "Linux"

  container {
    name   = "container"
    image  = "albal/contentful:latest"
    cpu    = "0.5"
    memory = "1.5"

    environment_variables = {
      CONTENTFUL_APIKEY = var.TF_VAR_CONTENTFUL_APIKEY,
      CONTENTFUL_SPACE  = var.TF_VAR_CONTENTFUL_SPACE
    }

    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}
