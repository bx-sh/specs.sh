@spec.run_directory_with_no_tests() {
  refute run spec "$test_specs/noSpecs"

  expect "$STDOUT" toBeEmpty
  expect "$STDERR" toContain "No specs found to run"
}