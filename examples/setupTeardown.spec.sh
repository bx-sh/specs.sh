@setup() {
  echo "BEFORE"
  SOME_VAR="The value of some var"
}

@teardown() {
  echo "AFTER"
}

@spec.hello() {
  echo "Hello - some var was... $SOME_VAR"
  SOME_VAR="Hello changed this"
  echo "Hello - some var is now... $SOME_VAR"
}

@spec.world() {
  echo "World - some var was... $SOME_VAR"
  SOME_VAR="World changed this"
  echo "World - some var is now... $SOME_VAR"
}