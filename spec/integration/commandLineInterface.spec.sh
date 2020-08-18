@pending.prints_usage_when_called_without_arguments() {
  :
}

@spec.can_print_version() {
  assert run ./spec.sh --version 
  expect "$STDOUT" toMatch ^[0-9]+\.[0-9]+\.[0-9]+$
  expect "$STDERR" toEqual "spec.sh version "
}

@pending.can_print_help_usage_documentation() {
  :
}

@spec.invalid.providing_argument_that_isnt_file_or_directory_shows_error() {
  # This is how to get 'spec.sh' or 'spec-full.sh' in a spec
  local commandName="./spec.sh "
  local displayName="${commandName#\.\/}"

  refute run ./spec.sh this-doesnt-exist.spec.sh
  expect "$STDOUT" toBeEmpty
  expect "$STDERR" toContain "${displayName}received unknown argument: this-doesnt-exist.spec.sh"
  expect "$STDERR" toContain "Expected file or directory or flag, e.g. --version"
}