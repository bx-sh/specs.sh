@spec.config_files_are_searched_for_and_loaded_even_before_spec_main_invoked() {
  # Without spec.config.sh
  refute run ./specs.sh examples/specSpecs/customization/overridesMain/hello.specs.sh
  expect "$STDOUT" toContain "[hello.specs.sh]"

  # With spec.config.sh (via SPEC_CONFIG)
  export SPEC_CONFIG="examples/specSpecs/customization/overridesMain/spec.config.sh"
  
  assert run ./specs.sh examples/specSpecs/customization/overridesMain/hello.specs.sh
  expect "$STDERR" toBeEmpty
  expect "$STDOUT" not toContain "[hello.specs.sh]"
  expect "$STDOUT" toContain "Hi from customized main! You called me with examples/specSpecs/customization/overridesMain/hello.specs.sh"
}

@pending.shows_error_if_provided_SPEC_CONFIG_file_does_not_exist() {
  :
}

@pending.can_provide_multiple_files_via_SPEC_CONFIG() {
  :
}

@pending.shows_error_if_provided_dash_dash_config_file_does_not_exist() {
  :
}

@pending.can_provide_multiple_files_via_dash_dash_config() {
  :
}

@pending.paths_can_be_provided_via_environment_variable() {
  :
}

@pending.if_paths_are_provided_no_searching_happens() {
  :
}

@pending.providing_empty_path_disables_config_searching() {
  :
}

@pending.searches_up_directory_path_for_spec_config_files_loading_the_top_level_ones_first() {
  :
}