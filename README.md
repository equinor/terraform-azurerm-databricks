# Terraform module for Azure Databricks

[![GitHub Release](https://img.shields.io/github/v/release/equinor/terraform-azurerm-databricks)](https://github.com/equinor/terraform-azurerm-databricks/releases/latest)
[![Terraform Module Downloads](https://img.shields.io/terraform/module/dt/equinor/databricks/azurerm)](https://registry.terraform.io/modules/equinor/databricks/azurerm/latest)
[![GitHub contributors](https://img.shields.io/github/contributors/equinor/terraform-azurerm-databricks)](https://github.com/equinor/terraform-azurerm-databricks/graphs/contributors)
[![GitHub Issues](https://img.shields.io/github/issues/equinor/terraform-azurerm-databricks)](https://github.com/equinor/terraform-azurerm-databricks/issues)
[![GitHub Pull requests](https://img.shields.io/github/issues-pr/equinor/terraform-azurerm-databricks)](https://github.com/equinor/terraform-azurerm-databricks/pulls)
[![GitHub License](https://img.shields.io/github/license/equinor/terraform-azurerm-databricks)](https://github.com/equinor/terraform-azurerm-databricks/blob/main/LICENSE)

Terraform module which creates Azure Databricks resources.

## Features

- Premium tier Databricks workspace created by default (trial tier available, which gives 14 days of free access to premium DBUs).
- Audit logs sent to given Log Analytics workspace by default.

## Prerequisites

- Azure role `Contributor` at the resource group scope.
- Azure role `Log Analytics Contributor` at the Log Analytics workspace scope.

## Usage

```terraform
provider "azurerm" {
  features {}
}

module "databricks" {
  source  = "equinor/databricks/azurerm"
  version = "~> 3.3"

  workspace_name             = "example-databricks"
  resource_group_name        = azurerm_resource_group.example.name
  location                   = azurerm_resource_group.example.location
  log_analytics_workspace_id = module.log_analytics.workspace_id
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "westeurope"
}

module "log_analytics" {
  source  = "equinor/log-analytics/azurerm"
  version = "~> 2.3"

  workspace_name      = "example-workspace"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
}
```

## Contributing

See [Contributing guidelines](https://github.com/equinor/terraform-baseline/blob/main/CONTRIBUTING.md).
