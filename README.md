# Terraform module for Azure Databricks

[![GitHub License](https://img.shields.io/github/license/equinor/terraform-azurerm-databricks)](https://github.com/equinor/terraform-azurerm-databricks/blob/main/LICENSE)
[![GitHub Release](https://img.shields.io/github/v/release/equinor/terraform-azurerm-databricks)](https://github.com/equinor/terraform-azurerm-databricks/releases/latest)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-%23FE5196?logo=conventionalcommits&logoColor=white)](https://conventionalcommits.org)
[![SCM Compliance](https://scm-compliance-api.radix.equinor.com/repos/equinor/terraform-azurerm-databricks/badge)](https://developer.equinor.com/governance/scm-policy/)

Terraform module which creates Azure Databricks resources.

## Features

- Standard tier Databricks workspace created by default.
- *(Premium tier only)* Audit logs sent to given Log Analytics workspace by default.

## Prerequisites

- Azure role `Contributor` resource group scope.
- Azure role `Log Analytics Contributor` at the Log Analytics workspace scope.

## Usage

1. Login to Azure:

    ```console
    az login
    ```

1. Create a Terraform configuration file `main.tf` and add the following example configuration:

    ```terraform
    provider "azurerm" {
      features {}
    }

    module "databricks" {
      source  = "equinor/databricks/azurerm"
      version = "~> 3.2"

      workspace_name      = "example-dbw"
      resource_group_name = azurerm_resource_group.example.name
      location            = azurerm_resource_group.example.location
    }

    resource "azurerm_resource_group" "example" {
      name     = "example-resources"
      location = "westeurope"
    }

    module "log_analytics" {
      source  = "equinor/log-analytics/azurerm"
      version = "~> 2.0"

      workspace_name      = "example-workspace"
      resource_group_name = azurerm_resource_group.example.name
      location            = azurerm_resource_group.example.location
    }
    ```

1. Install required provider plugins and modules:

    ```console
    terraform init
    ```

1. Apply the Terraform configuration:

    ```console
    terraform apply
    ```

## Contributing

See [Contributing guidelines](https://github.com/equinor/terraform-baseline/blob/main/CONTRIBUTING.md).
