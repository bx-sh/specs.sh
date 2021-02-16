@spec.runs_at_spec_functions_but_not_test_prefixed_functions() {
  refute run ./specs-full.sh examples/specSpecs/basics/xunitAndBdd.spec.sh

  expect "$STDOUT" toContain "foo"
  expect "$STDOUT" toContain "passing foo"
  expect "$STDOUT" toContain "failing foo"
  expect "$STDOUT" toContain "pending foo"

  expect "$STDOUT" not toContain "bar" "Bar"
  expect "$STDOUT" not toContain "[OK] Passing Bar"
  expect "$STDOUT" not toContain "[FAIL] Failing Bar"
  expect "$STDOUT" not toContain "Pending Bar"
}