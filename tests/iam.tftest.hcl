mock_provider "azurerm" {
  source = "./tests/azurerm"
}

run "setup_tests" {
  module {
    source = "./tests/setup"
  }
}

run "test_databricks_iam" {
  module {
    source = "./modules/iam"
  }

  variables {}
}
