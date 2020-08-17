@spec.file_not_found() {
  refute run spec "$test_specs/i-do-not-exist"

  expect "$STDOUT" toBeEmpty
  expect "$STDERR" toContain "Unsupported 'spec' argument: [examples/.test_specs/i-do-not-exist]"
}

@spec.run_by_filename() {
  refute run spec "$test_specs/helloWorld/hello-world.spec.sh"

  expect "$STDOUT" toContain "[OK] this should pass"
  expect "$STDOUT" toContain "[FAIL] this should fail"
  expect "$STDOUT" toContain "Specs failed"
}

@spec.run_by_directory() {
  refute run spec "$test_specs/helloWorld/"

  expect "$STDOUT" toContain "[OK] this should pass"
  expect "$STDOUT" toContain "[FAIL] this should fail"
  expect "$STDOUT" toContain "Specs failed"
}

@spec.run_by_name() {
  # Without spaces
  assert run spec "$test_specs/helloWorld/" -e "pass"

  expect "$STDOUT" toContain "[OK] this should pass"
  expect "$STDOUT" toContain "Specs passed"
  expect "$STDOUT" not toContain "FAIL" "should fail"

  # With spaces
  refute run spec "$test_specs/helloWorld/" -e "should fail"

  expect "$STDOUT" toContain "[FAIL] this should fail"
  expect "$STDOUT" toContain "Specs failed"
  expect "$STDOUT" not toContain "OK" "should pass"
}

@spec.output_should_include_filename() {
  refute run spec "$test_specs/helloWorld/"

  expect "$STDOUT" toContain "helloWorld/hello-world.spec.sh"
}

@spec.output_should_include_suite_results() {
  refute run spec "$test_specs/helloWorld/"

  # This format may change, this is the only place it is tested so it can be changed
  expect "$STDOUT" toContain "Specs failed. 1 passed. 1 failed."
}