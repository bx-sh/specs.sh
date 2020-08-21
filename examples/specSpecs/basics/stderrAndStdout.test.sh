testIOutputThingsAndIPass() {
  echo "Hello STDOUT from passing spec"
  echo "Hello STDERR from passing spec" >&2
}

testIOutputThingsAndIFail() {
  echo "Hello STDOUT from failing spec"
  echo "Hello STDERR from failing spec" >&2
  return 1
}