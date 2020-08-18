@spec.passing_foo() {
  echo "Hello from spec-style foo spec, I pass"
}

@spec.failing_foo() {
  echo "Hello from spec-style bar spec, I fail"
  return 1
}

@pending.pending_foo() {
  echo "This doesn't run, it's pending spec-style"
}

testPassingBar() {
  echo "Hello from xUnit-style test, I pass"
}

testFailingBar() {
  echo "Hello from xUnit-style test, I fail"
  return 1
}

xtestPendingBar() {
  echo "This doesn't run, it's pending xUnit-style"
}