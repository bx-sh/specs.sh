@spec.prints_the_name_of_the_file_being_run() {
  assert run ./specs.sh examples/specSpecs/basics/passing.oneSpec.return0.specs.sh
  expect "$STDOUT" toContain "passing.oneSpec.return0.specs.sh"

  ./specs.sh examples/specSpecs/basics/failing.oneSpec.return1.specs.sh
  refute run ./specs.sh examples/specSpecs/basics/failing.oneSpec.return1.specs.sh
  expect "$STDOUT" toContain "failing.oneSpec.return1.specs.sh"
}

@spec.prints_the_name_of_the_spec_functions_run() {
  assert run ./specs.sh examples/specSpecs/basics/passing.threeSpecs.specs.sh
  expect "$STDOUT" toContain "passing.threeSpecs.specs.sh"
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