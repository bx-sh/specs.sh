@spec.normal_spec_doesnt_include_assert() {
  refute run ./spec.sh examples/specSpecs/full/usesAssert.spec.sh
  expect "$STDERR" toContain "assert: command not found"
  expect "$STDERR" toContain "refute: command not found"
}

@spec.full_spec_includes_assert() {
  assert run ./spec-full.sh examples/specSpecs/full/usesAssert.spec.sh
  expect "$STDERR" not toContain "assert: command not found"
  expect "$STDERR" not toContain "refute: command not found"
}