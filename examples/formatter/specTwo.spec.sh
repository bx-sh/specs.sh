@setupFixture() {
  echo "Hi from setupFixture. This function: $SPEC_CURRENT_FUNCTION This file $SPEC_FILE"
}

@teardownFixture() {
  echo "Hi from teardownFixture. This function: $SPEC_CURRENT_FUNCTION This file $SPEC_FILE"
}

@setup() {
  echo "Hi from setup. Current spec: $SPEC_NAME This function: $SPEC_CURRENT_FUNCTION Spec function: $SPEC_FUNCTION"
}

@teardown() {
  echo "Hi from setup. Current spec: $SPEC_NAME Spec status: $SPEC_STATUS This function: $SPEC_CURRENT_FUNCTION Spec function: $SPEC_FUNCTION"
}

@spec.spec_one() {
  echo "Hi from spec. This function: $SPEC_FUNCTION This spec name: $SPEC_NAME"
}

@spec.spec_two() {
  echo "Hi from spec. This function: $SPEC_FUNCTION This spec name: $SPEC_NAME"
}

@pending.i_am_pending() {
  echo "Hi from spec. This function: $SPEC_FUNCTION This spec name: $SPEC_NAME"
}

@spec.i_fail() {
  echo "Hi from spec. This function: $SPEC_FUNCTION This spec name: $SPEC_NAME"
  [ 1 -eq 2 ]
}