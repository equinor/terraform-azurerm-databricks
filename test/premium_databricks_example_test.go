package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestPremiumDatabricksExample(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/premium-databricks",
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)
}
