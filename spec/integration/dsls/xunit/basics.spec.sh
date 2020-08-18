@pending.runs_test_prefixed_functions_but_not_at_spec_functions() {
  refute run ./spec.sh examples/specSpecs/basics/xunitAndBdd.spec.sh

  expect "$STDOUT" toContain "Bar"
  expect "$STDOUT" toContain "[OK] Passing Bar"
  expect "$STDOUT" toContain "[FAIL] Failing Bar"
  # expect "$STDOUT" toContain "Pending Bar"

  expect "$STDOUT" not toContain "foo" "Foo"
  expect "$STDOUT" not toContain "passing foo"
  expect "$STDOUT" not toContain "failing foo"
  # expect "$STDOUT" not toContain "pending foo"
}