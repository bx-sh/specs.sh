# TODO update to use mocks.sh instead of picking random known config variables - although that works great for now!

@spec.initialize.is_not_called_when_specs_is_sourced() {
  expect SPECS_VERSION not toBeDefined

  source bin/specs

  expect SPECS_VERSION not toBeDefined
}

@spec.initialize.is_called_the_first_time_specs_function_is_called() {
  expect SPECS_VERSION not toBeDefined

  source bin/specs

  specs --version # call anything on specs()

  expect SPECS_VERSION toBeDefined
}

@spec.initialize.is_not_called_when_the_specs_function_is_called_again() {
  expect SPECS_VERSION not toBeDefined

  source bin/specs

  specs --version # call anything on specs()

  expect SPECS_VERSION toBeDefined
  unset SPECS_VERSION
  expect SPECS_VERSION not toBeDefined

  specs --version # call anything on specs()

  expect SPECS_VERSION not toBeDefined # oh jeepers, it did not re-set SPECS_VERSION. i.e. it did not re-initialize
}