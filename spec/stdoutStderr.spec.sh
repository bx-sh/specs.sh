@spec.doesnt_show_stdout_or_stderr_if_there_is_none() {
  VERBOSE=true refute run spec "$test_specs/stdout-stderr.spec.sh" -e "failing no stdout or stderr"

  expect "$STDOUT" toContain "[FAIL] failing no stdout or stderr"

  expect "$STDOUT" not toContain "[Output]"
  expect "$STDOUT" not toContain "[Standard Error]"
}

@spec.shows_stdout_when_present_and_spec_fails() {
  refute run spec "$test_specs/stdout-stderr.spec.sh" -e "failing just stdout"

  expect "$STDOUT" toContain "[Output]"
  expect "$STDOUT" toContain "Hi from STDOUT"
  expect "$STDOUT" toContain "[FAIL] failing just stdout"

  expect "$STDOUT" not toContain "[Standard Error]"
}

@spec.shows_stderr_when_present_and_spec_fails() {
  refute run spec "$test_specs/stdout-stderr.spec.sh" -e "failing just stderr"

  expect "$STDOUT" toContain "[Standard Error]"
  expect "$STDOUT" toContain "Hi from STDERR"
  expect "$STDOUT" toContain "[FAIL] failing just stderr"

  expect "$STDOUT" not toContain "[Output]"
}

@spec.doesnt_show_stdout_or_stderr_when_spec_passes() {
  assert run spec "$test_specs/stdout-stderr.spec.sh" -e "passing stdout and stderr"

  expect "$STDOUT" toContain "[OK] passing stdout and stderr"

  expect "$STDOUT" not toContain "[Output]"
  expect "$STDOUT" not toContain "[Standard Error]"
}

@spec.shows_stdout_when_present_and_spec_passed_if_VERBOSE_is_true() {
  VERBOSE=true assert run spec "$test_specs/stdout-stderr.spec.sh" -e "passing stdout and stderr"

  expect "$STDOUT" toContain "[OK] passing stdout and stderr"

  expect "$STDOUT" toContain "[Output]"
  expect "$STDOUT" toContain "[Standard Error]"
  expect "$STDOUT" toContain "Hello from STDOUT"
  expect "$STDOUT" toContain "Hello from STDERR"
}
