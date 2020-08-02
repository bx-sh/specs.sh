# 🔬 `@spec`

Simple Shell Specifications.

---

> - Small
> - Flexible
> - Simply BASH

---

```sh
@setup() {
  PATH="./greeting/bin:$PATH"
}

@teardown() {
  : # Do some cleanup
}

@spec.Should_give_a_nice_greeting() {
  [ "$( greeting )" = "Hello, world!" ]
}

@pending.I_will_write_this_later() {
  : # Unimplemented test
}
```

```sh
$ spec my-file.spec.sh

[OK] Should give a nice greeting
[PENDING] I will write this later

Tests passed. 1 passed. 1 pending.
```

---

> - Supports most commonly used test vocabulary

```sh
##
# These are all supported by default
##

@setup() { :; }
@before() { :; }

@teardown() { :; }
@before() { :; }

@setupFixture() { :; }
@beforeAll() { :; }

@teardownFixture() { :; }
@afterAll() { :; }

@test() { :; }
@spec() { :; }
@it() { :; }
@example() { :; }

@xtest() { :; }
@xspec() { :; }
@xit() { :; }
@pending() { :; }
```

---

> - Or bring your own DSL

```sh
# spec.config.sh

spec.specFunctionPrefixes() {
  echo test
}

spec.setupFunctionNames() {
  echo config
}

spec.teardownFunctionNames() {
  # support the built-in @teardown plus our own
  echo cleanup $(___spec___.teardownFunctionNames)
}
```

```sh
# my-file.spec.sh

config() {
  : # this will run before each test (like @setup does)
}

cleanup() {
  : # and this will run (like @teardown does)
}

testIChangedTheNamingConventions() {
  : # cool, any function that starts with 'test' runs now
}

testThisIsMuchMoreToMyLiking() {
  : # that sure was easy to customize
}
```

---
