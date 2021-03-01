loadSpecs

@spec.configVariables.can_store_config_variable_definitions() {
  expect "${#SPECS_CONFIG_VARIABLES[@]}" toEqual 1 # [0] is the config variable lookup field (keyed on name)
  
  # List of all config variable names doesn't include this
  assert specs -- configVariables listNames # TODO UPDATE `expect` to do this check and fail unless expected failure
  expect { specs -- configVariables listNames } toBeEmpty

  specs -- configVariables add SPECS_FOO value "This is a variable and it has a description" "-f --foo" "The default value"

  expect "${#SPECS_CONFIG_VARIABLES[@]}" toEqual 2

  # List of all config variable names does include this
  expect { specs -- configVariables listNames } toContain "SPECS_FOO"

  # Use the getters to check that we can get the values
  expect { specs -- configVariables getDefaultValue SPECS_FOO } toEqual "The default value"
  expect { specs -- configVariables getDescription SPECS_FOO } toEqual "This is a variable and it has a description"
  expect { specs -- configVariables getFlags SPECS_FOO } toEqual "-f --foo"

  # Check the encoded format matches what's expected
  expect "${SPECS_CONFIG_VARIABLES[0]}" toEqual ";SPECS_FOO:1"
  expect "${SPECS_CONFIG_VARIABLES[1]}" toEqual "SPECS_FOO;value|-f --foo+The default value[[DESCRIPTION]]This is a variable and it has a description"
}

# For each of these, test a negative case, a positive one, then positive returning var printf -v
@pending.configVariables.add() {
  :
}

@pending.configVariables.getDefaultValue() {
  :
}

@pending.configVariables.getDescription() {
  :
}

@pending.configVariables.getName() {
  :
}

@pending.configVariables.listNames() {
  :
}

@pending.configVariables.listDetails() {
  :
}

@pending.configVariables.setValue() {
  :
}