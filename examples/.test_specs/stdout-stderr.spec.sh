@spec.passing_stdout_and_stderr() {
  echo "Hello from STDOUT"
  echo "Hello from STDERR" >&2
  return 0
}

@spec.failing_just_stdout() {
  echo "Hi from STDOUT"
  return 1
}

@spec.failing_just_stderr() {
  echo "Hi from STDERR" >&2
  return 1
}

@spec.failing_no_stdout_or_stderr() {
  return 1
}