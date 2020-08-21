@spec.i_output_things_and_i_pass() {
  echo "Hello STDOUT from passing spec"
  echo "Hello STDERR from passing spec" >&2
}

@spec.i_output_things_and_i_fail() {
  echo "Hello STDOUT from failing spec"
  echo "Hello STDERR from failing spec" >&2
  return 1
}