loadSpecs

@spec.store.configVariables.can_store_config_variables() {
  expect "${#SPECS_CONFIG_VARIABLES[@]}" toEqual 1 # [0] is the config variable lookup field (keyed on name)
  
  # List of all config variable names doesn't include this
  assert specs -- store configVariables listNames # TODO UPDATE `expect` to do this check and fail unless expected failure
  expect { specs -- store configVariables listNames } toBeEmpty

  specs -- store configVariables add SPECS_FOO value "This is a variable and it has a description" "-f --foo" "The default value"

  expect "${#SPECS_CONFIG_VARIABLES[@]}" toEqual 2

  # List of all config variable names does include this
  expect { specs -- store configVariables listNames } toContain "SPECS_FOO"

  # Use the getters to check that we can get the values
  expect { specs -- store configVariables getDefaultValue SPECS_FOO } toEqual "The default value"
  expect { specs -- store configVariables getDescription SPECS_FOO } toEqual "This is a variable and it has a description"
  expect { specs -- store configVariables getFlags SPECS_FOO } toEqual "-f --foo"

  # Check the encoded format matches what's expected
  expect "${SPECS_CONFIG_VARIABLES[0]}" toEqual ";SPECS_FOO:1"
  expect "${SPECS_CONFIG_VARIABLES[1]}" toEqual "SPECS_FOO;value|-f --foo+The default value[[DESCRIPTION]]This is a variable and it has a description"
}

# For each of these, test a negative case, a positive one, then positive returning var printf -v
@pending.store.configVariables.add() {
  :
}

@pending.store.configVariables.getDefaultValue() {
  :
}

@pending.store.configVariables.getDescription() {
  :
}

@pending.store.configVariables.getName() {
  :
}

@pending.store.configVariables.listNames() {
  :
}