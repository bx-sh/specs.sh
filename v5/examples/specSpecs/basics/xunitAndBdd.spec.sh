@spec.passing_foo() {
  echo "Hello from spec-style foo spec, I pass"
}

@example.failing_foo() {
  echo "Hello from spec-style foo spec, I fail"
  return 1
}

@pending.pending_foo() {
  echo "This doesn't run, it's pending spec-style"
}

testPassingBar() {
  echo "Hello from xUnit-style bar test, I pass"
}

testFailingBar() {
  echo "Hello from xUnit-style bar test, I fail"
  return 1
}

xtestPendingBar() {
  echo "This doesn't run, it's pending xUnit-style bar test"
}