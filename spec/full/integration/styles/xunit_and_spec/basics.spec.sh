@spec.runs_at_spec_functions_and_also_runs_test_prefixed_functions() {
  refute run ./spec-full.sh examples/specSpecs/basics/xunitAndBdd.spec.sh

  expect "$STDOUT" toContain "foo"
  expect "$STDOUT" toContain "passing foo"
  expect "$STDOUT" toContain "failing foo"
  # expect "$STDOUT" toContain "pending foo"

  expect "$STDOUT" toContain "bar" "Bar"
  expect "$STDOUT" toContain "[OK] Passing Bar"
  expect "$STDOUT" toContain "[FAIL] Failing Bar"
  # expect "$STDOUT" not toContain "Pending Bar"
}