mock_provider "azurerm" {
  source = "./tests/azurerm"
}

run "setup" {
  module {
    source = "./tests/setup"
  }
}

variables {
  resource_group_name = run.setup.resource_group_name
  location            = run.setup.location
}

run "premium_databricks_example" {
  module {
    source = "./examples/premium-databricks"
  }
}
