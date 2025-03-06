# Terraform module for Azure Databricks

[![GitHub License](https://img.shields.io/github/license/equinor/terraform-azurerm-databricks)](https://github.com/equinor/terraform-azurerm-databricks/blob/main/LICENSE)
[![GitHub Release](https://img.shields.io/github/v/release/equinor/terraform-azurerm-databricks)](https://github.com/equinor/terraform-azurerm-databricks/releases/latest)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-%23FE5196?logo=conventionalcommits&logoColor=white)](https://conventionalcommits.org)
[![SCM Compliance](https://scm-compliance-api.radix.equinor.com/repos/equinor/terraform-azurerm-databricks/badge)](https://developer.equinor.com/governance/scm-policy/)

Terraform module which creates Azure Databricks resources.

## Features

- Audit logs sent to given Log Analytics workspace by default (premium SKU only).

## Prerequisites

- Azure role `Contributor` resource group scope.
- Azure role `Log Analytics Contributor` at the Log Analytics workspace scope.

## Development

1. Read [this document](https://code.visualstudio.com/docs/devcontainers/containers).

1. Clone this repository.

1. Configure Terraform variables in a file `.devcontainer/devcontainer.env`:

    ```env
    TF_VAR_resource_group_name=
    TF_VAR_location=
    ```

1. Open repository in dev container.

## Testing

1. Change to the test directory:

    ```console
    cd test
    ```

1. Login to Azure:

    ```console
    az login
    ```

1. Set active subscription:

    ```console
    az account set -s <SUBSCRIPTION_NAME_OR_ID>
    ```

1. Run tests:

    ```console
    go test -timeout 60m
    ```

## Contributing

See [Contributing guidelines](https://github.com/equinor/terraform-baseline/blob/main/CONTRIBUTING.md).
