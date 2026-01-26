mock_provider "azurerm" {
  source = "./tests/azurerm"
}

mock_provider "databricks" {}

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
