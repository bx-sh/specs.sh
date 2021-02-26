testIOutputThingsAndIFail() {
  echo "Hello STDOUT from failing spec"
  echo "Hello STDERR from failing spec" >&2
  return 1
}