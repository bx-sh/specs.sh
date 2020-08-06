@setupFixture() {
  echo "Hi, I run before the whole file. I am $SPEC_CURRENT_FUNCTION."
}

@teardownFixture() {
  echo "Hi, I run after the whole file. I am $SPEC_CURRENT_FUNCTION."
}

@setup() {
  echo "HI FROM SETUP - this test name/function is: ($SPEC_NAME) ($SPEC_FUNCTION) - I am $SPEC_CURRENT_FUNCTION"
}

@teardown() {
  echo "HI FROM TEARDOWN - this test name/function is: ($SPEC_NAME) ($SPEC_FUNCTION) - I am $SPEC_CURRENT_FUNCTION"
}

@spec.hello_world() {
  echo "FILE: $SPEC_FILE"
  echo "DIR: $SPEC_DIR"
  echo "Function: $SPEC_FUNCTION"
  echo "Name: $SPEC_NAME"
  echo "Hello STDERR" >&2
  [ "Hello" = "World" ]
}

@spec.second_spec() {
  [ 1 -eq 2 ]
}

@spec.passing_spec() {
  echo "Current Spec: $SPEC_NAME"
  echo "Current Spec Function: $SPEC_FUNCTION"
  echo "Current Function: $SPEC_CURRENT_FUNCTION"
  [ 1 -eq 1 ]
}

@pending.hello_i_am_pending() {
  :
}
