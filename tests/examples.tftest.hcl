mock_provider "azurerm" {
  source = "./tests/azurerm"
}

run "premium_databricks_example" {
  module {
    source = "./examples/premium-databricks"
  }

  variables {
    resource_group_name = "example-resources"
    location            = "westeurope"
  }
}
