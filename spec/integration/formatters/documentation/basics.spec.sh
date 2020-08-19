@spec.prints_the_name_of_the_file_being_run() {
  assert run ./spec.sh examples/specSpecs/basics/passing.oneSpec.return0.spec.sh
  expect "$STDOUT" toContain "passing.oneSpec.return0.spec.sh"

  ./spec.sh examples/specSpecs/basics/failing.oneSpec.return1.spec.sh
  refute run ./spec.sh examples/specSpecs/basics/failing.oneSpec.return1.spec.sh
  expect "$STDOUT" toContain "failing.oneSpec.return1.spec.sh"
}

@spec.prints_the_name_of_the_spec_functions_run() {
  assert run ./spec.sh examples/specSpecs/basics/passing.threeSpecs.spec.sh
  expect "$STDOUT" toContain "passing.threeSpecs.spec.sh"
  expect "$STDOUT" toContain "[OK] hello one"
  expect "$STDOUT" toContain "[OK] hello two"
  expect "$STDOUT" toContain "[OK] hello three"
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