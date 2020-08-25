@spec.i_output_things_and_i_fail() {
  echo "Hello STDOUT from failing spec"
  echo "Hello STDERR from failing spec" >&2
  return 1
}