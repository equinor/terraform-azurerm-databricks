mock_provider "azurerm" {
  source = "./tests/azurerm"
}

run "setup_tests" {
  module {
    source = "./tests/setup"
  }
}

variables {
  resource_group_name = run.setup_tests.resource_group_name
  location            = run.setup_tests.location
}

run "premium_databricks_example" {
  module {
    source = "./examples/premium-databricks"
  }
}
