@spec.prints_the_name_of_the_file_being_run() {
  assert run ./spec-full.sh examples/specSpecs/basics/passing.oneSpec.return0.spec.sh
  expect "$STDOUT" toContain "passing.oneSpec.return0.spec.sh"

  refute run ./spec-full.sh examples/specSpecs/basics/failing.oneSpec.return1.spec.sh
  expect "$STDOUT" toContain "failing.oneSpec.return1.spec.sh"
}

@pending.prints_the_name_of_the_spec_functions_run() {
  :
}

@pending.prints_OK_for_passing_spec_functions() {
  :
}

@pending.prints_FAIL_for_passing_spec_functions() {
  :
}

@pending.prints_PENDING_for_passing_spec_functions() {
  :
}

@pending.prints_spec_function_output_when_spec_fails() {
  :
}