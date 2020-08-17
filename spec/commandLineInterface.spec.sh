@pending.prints_usage_when_called_without_arguments() {
  :
}

@spec.can_print_version() {
  run ./spec.sh --version 
  expect "$STDOUT" toMatch ^[0-9]+\.[0-9]+\.[0-9]+$
  expect "$STDERR" toEqual "spec.sh version "
}