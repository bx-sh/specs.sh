echo "Hiiiii"

@spec.uses_assert_and_refute() {
  # This should fail if assert/refute aren't defined but pass if they are available
  echo "Hellooo"
  set -x
  assert [ 1 -eq 1 ]
  refute [ 1 -eq 12345 ]
}