source bin/specs

@spec.store.configVariables.can_store_config_variables() {
  expect "${#SPECS_CONFIG_VARIABLES[@]}" toEqual 0
  
  # List of all config variable names doesn't include this
  assert specs -- store configVariables listNames # TODO UPDATE `expect` to do this check and fail unless expected failure
  expect { specs -- store configVariables listNames } toBeEmpty

  specs -- store configVariables add SPECS_FOO "The default value" "This is a variable and it has a description" "-f="

echo hi
  expect "${#SPECS_CONFIG_VARIABLES[@]}" toEqual 1

  # List of all config variable names does include this
  expect { specs -- store configVariables listNames } toContain "SPECS_FOO"

  # Use the getters to check that we can get the values
  expect { specs -- store configVariables getDefaultValue SPECS_FOO } toEqual "The default value"
  expect { specs -- store configVariables getDescription SPECS_FOO } toEqual "This is a variable and it has a descriptione"
  expect { specs -- store configVariables getFlags SPECS_FOO } toEqual "-f="

  # Check the encoded format matches what's expected
  expect "${SPECS_CONFIG_VARIABLES[0]}" toEqual ""
}