@pending.prints_usage_when_called_without_arguments() {
  :
}

@spec.can_print_version() {
  assert run ./spec-full.sh --version 
  expect "$STDOUT" toMatch ^[0-9]+\.[0-9]+\.[0-9]+$
  expect "$STDERR" toEqual "spec.sh version "
}

@spec.can_print_help_usage_documentation() {
  # This is how to get 'spec.sh' or 'spec-full.sh' in a spec
  local commandName="./spec-full.sh "
  local displayName="${commandName#\.\/}"

  assert run ./spec-full.sh --help
  expect "$OUTPUT" toContain "${displayName}[file.spec.sh]"
}

@pending.runs_all_specs_in_the_current_directory_when_called_with_no_arguments() {
  :
}

@spec.invalid.providing_argument_that_isnt_file_or_directory_shows_error() {
  # This is how to get 'spec.sh' or 'spec-full.sh' in a spec
  local commandName="./spec-full.sh "
  local displayName="${commandName#\.\/}"

  refute run ./spec-full.sh this-doesnt-exist.spec.sh
  expect "$STDOUT" toBeEmpty
  expect "$STDERR" toContain "${displayName}received unknown argument: this-doesnt-exist.spec.sh"
  expect "$STDERR" toContain "Expected file or directory or flag, e.g. --version"
}