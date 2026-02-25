# Changelog

## [4.3.1](https://github.com/equinor/terraform-azurerm-databricks/compare/v4.3.0...v4.3.1) (2026-02-25)


### Features

* **iam-v2:** add outputs `group_display_names` and `service_principal_application_ids` ([#71](https://github.com/equinor/terraform-azurerm-databricks/issues/71)) ([657eb71](https://github.com/equinor/terraform-azurerm-databricks/commit/657eb71ca26e81a23b59b5a50e46cab6b2ea727c))


### Code Refactoring

* **iam-v2:** remove `external_` prefix from variable and resource names ([#75](https://github.com/equinor/terraform-azurerm-databricks/issues/75)) ([51ca0d7](https://github.com/equinor/terraform-azurerm-databricks/commit/51ca0d7faba975064531ac71b5fabdc155de85a1))
* rename beta submodule `iam` to `iam-v2` ([#72](https://github.com/equinor/terraform-azurerm-databricks/issues/72)) ([cec862a](https://github.com/equinor/terraform-azurerm-databricks/commit/cec862a6b771ac3bbdf0d2d7b5363b5924af31c6))

## [4.3.0](https://github.com/equinor/terraform-azurerm-databricks/compare/v4.2.2...v4.3.0) (2026-02-17)


### Features

* **iam:** assign Entra ID service principals to workspace ([#63](https://github.com/equinor/terraform-azurerm-databricks/issues/63)) ([af878ab](https://github.com/equinor/terraform-azurerm-databricks/commit/af878abaec716e8b2224de8f2ddab46b93366da5))


### Bug Fixes

* **iam:** recently created Entra ID group not found in account ([#65](https://github.com/equinor/terraform-azurerm-databricks/issues/65)) ([dbebe91](https://github.com/equinor/terraform-azurerm-databricks/commit/dbebe91ee487f4f25060ee4e35670dd6702d15c2))
* **iam:** wait up to 30 minutes for external identity propagation ([#67](https://github.com/equinor/terraform-azurerm-databricks/issues/67)) ([9dc103d](https://github.com/equinor/terraform-azurerm-databricks/commit/9dc103db66ea20779ee5bc2ec42e78bdd78245c0))

## [4.2.2](https://github.com/equinor/terraform-azurerm-databricks/compare/v4.2.1...v4.2.2) (2026-02-09)


### Code Refactoring

* **iam:** rename `time_rotating.this` to `time_rotating.token_expiration` ([#59](https://github.com/equinor/terraform-azurerm-databricks/issues/59)) ([e82b44a](https://github.com/equinor/terraform-azurerm-databricks/commit/e82b44aeb710c6d881606b725472a89be69e232b))

## [4.2.1](https://github.com/equinor/terraform-azurerm-databricks/compare/v4.2.0...v4.2.1) (2026-02-05)


### Bug Fixes

* **iam:** permission assignment APIs are not available on initial apply ([#56](https://github.com/equinor/terraform-azurerm-databricks/issues/56)) ([b9da028](https://github.com/equinor/terraform-azurerm-databricks/commit/b9da028e265d9999121fe828e97931d3531a5163))
* **iam:** workspace URL is null on initial apply ([#55](https://github.com/equinor/terraform-azurerm-databricks/issues/55)) ([79b1767](https://github.com/equinor/terraform-azurerm-databricks/commit/79b176702bb1809b9eb5b8dc6e01a093803748be))

## [4.2.0](https://github.com/equinor/terraform-azurerm-databricks/compare/v4.1.1...v4.2.0) (2026-01-28)


### Features

* **iam:** assign Entra ID groups to workspace ([#53](https://github.com/equinor/terraform-azurerm-databricks/issues/53)) ([a227100](https://github.com/equinor/terraform-azurerm-databricks/commit/a227100463ea2ce2090d550f301a65a0544e763a))

## [4.1.1](https://github.com/equinor/terraform-azurerm-databricks/compare/v4.1.0...v4.1.1) (2026-01-23)


### Documentation

* manage identities ([#50](https://github.com/equinor/terraform-azurerm-databricks/issues/50)) ([bfcefe2](https://github.com/equinor/terraform-azurerm-databricks/commit/bfcefe2e14dd2efb4efcca420b6f2248180df6a7))

## [4.1.0](https://github.com/equinor/terraform-azurerm-databricks/compare/v4.0.0...v4.1.0) (2025-11-27)


### Features

* add output `managed_identity_principal_id` ([#46](https://github.com/equinor/terraform-azurerm-databricks/issues/46)) ([7796098](https://github.com/equinor/terraform-azurerm-databricks/commit/77960988d7ff4e6c22591c870b624a05798dc690))

## [4.0.0](https://github.com/equinor/terraform-azurerm-databricks/compare/v3.3.1...v4.0.0) (2025-10-10)


### ⚠ BREAKING CHANGES

* variable `sku` no longer allows value `"standard"`.

### Features

* create Premium tier workspace by default ([#44](https://github.com/equinor/terraform-azurerm-databricks/issues/44)) ([28a9bff](https://github.com/equinor/terraform-azurerm-databricks/commit/28a9bff10c95b8555f2e187466ed4b69efc27555))

## [3.3.1](https://github.com/equinor/terraform-azurerm-databricks/compare/v3.3.0...v3.3.1) (2025-04-29)


### Documentation

* update README ([88008e9](https://github.com/equinor/terraform-azurerm-databricks/commit/88008e9f8a9426bc7e2adfea415196d917e1244d))

## [3.3.0](https://github.com/equinor/terraform-azurerm-databricks/compare/v3.2.2...v3.3.0) (2025-03-06)


### Features

* add variables for all arguments ([#35](https://github.com/equinor/terraform-azurerm-databricks/issues/35)) ([349941d](https://github.com/equinor/terraform-azurerm-databricks/commit/349941db80d7beb8180e697a87c74e3123f96b1d))

## [3.2.2](https://github.com/equinor/terraform-azurerm-databricks/compare/v3.2.1...v3.2.2) (2024-08-28)


### Miscellaneous Chores

* update variable descriptions and add features list ([#40](https://github.com/equinor/terraform-azurerm-databricks/issues/40)) ([eb50254](https://github.com/equinor/terraform-azurerm-databricks/commit/eb50254db4a0fc16c788229d264d2c20effd5020))

## [3.2.1](https://github.com/equinor/terraform-azurerm-databricks/compare/v3.2.0...v3.2.1) (2023-07-26)


### Bug Fixes

* don't specify Log Analytics destination type ([#20](https://github.com/equinor/terraform-azurerm-databricks/issues/20)) ([218e475](https://github.com/equinor/terraform-azurerm-databricks/commit/218e4754abfebad0ff904a4f28669ccad0278666))

## [3.2.0](https://github.com/equinor/terraform-azurerm-databricks/compare/v3.1.1...v3.2.0) (2023-04-26)


### Features

* set diagnostic setting enabled log categories ([#18](https://github.com/equinor/terraform-azurerm-databricks/issues/18)) ([03f7c61](https://github.com/equinor/terraform-azurerm-databricks/commit/03f7c61af0c08411cca44eb4ffaa0d3e8f38db2c))

## [3.1.1](https://github.com/equinor/terraform-azurerm-databricks/compare/v3.1.0...v3.1.1) (2023-02-09)


### Bug Fixes

* disable log categories ([#14](https://github.com/equinor/terraform-azurerm-databricks/issues/14)) ([299faa3](https://github.com/equinor/terraform-azurerm-databricks/commit/299faa3d1d1d434ac9df4a1557e7e76d3b31aab5))

## [3.1.0](https://github.com/equinor/terraform-azurerm-databricks/compare/v3.0.0...v3.1.0) (2023-02-08)


### Features

* set log analytics destination type and update min. provider version ([#12](https://github.com/equinor/terraform-azurerm-databricks/issues/12)) ([4c4659d](https://github.com/equinor/terraform-azurerm-databricks/commit/4c4659d5cffed76da2cdd2817df9724327966f12))

## [3.0.0](https://github.com/equinor/terraform-azurerm-databricks/compare/v2.0.0...v3.0.0) (2023-01-27)


### ⚠ BREAKING CHANGES

* remove single resource submodule ([#6](https://github.com/equinor/terraform-azurerm-databricks/issues/6))

### Code Refactoring

* remove single resource submodule ([#6](https://github.com/equinor/terraform-azurerm-databricks/issues/6)) ([792e12a](https://github.com/equinor/terraform-azurerm-databricks/commit/792e12a84ed4c95435ebf66229343f7554ba4cb2))
