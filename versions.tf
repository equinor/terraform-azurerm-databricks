terraform {
  required_version = ">= 1.1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.104.0"
    }

    time = {
      source = "hashicorp/time"
      # Time provider version 0.5.0 required to use the "time_sleep" resource
      version = ">= 0.5.0"
    }
  }
}
