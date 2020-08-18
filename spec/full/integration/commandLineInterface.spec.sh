@pending.prints_usage_when_called_without_arguments() {
  :
}

@spec.can_print_version() {
  assert run ./spec-full.sh --version 
  expect "$STDOUT" toMatch ^[0-9]+\.[0-9]+\.[0-9]+$
  expect "$STDERR" toEqual "spec.sh version "
}

@pending.can_print_help_usage_documentation() {
  :
}

@spec.invalid.providing_argument_that_isnt_file_or_directory_shows_error() {
  refute run ./spec-full.sh this-doesnt-exist.spec.sh
  expect "$STDOUT" toBeEmpty
  expect "$STDERR" toContain "spec.sh received unknown argument: this-doesnt-exist.spec.sh"
  expect "$STDERR" toContain "Expected file or directory or flag, e.g. --version"
}