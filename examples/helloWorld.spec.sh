@setup() {
  echo "HI FROM SETUP - this test name/function is: ($SPEC_NAME) ($SPEC_FUNCTION)"
}

@spec.helloWorld() {
  echo "FILE: $SPEC_FILE"
  echo "DIR: $SPEC_DIR"
  echo "Function: $SPEC_FUNCTION"
  echo "Name: $SPEC_NAME"
  echo ""
  [ "Hello" = "World" ]
}