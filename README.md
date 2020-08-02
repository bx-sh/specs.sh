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

### Supports most commonly used test vocabulary

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

### Or bring your own DSL

```sh
# spec.config.sh

spec.specFunctionPrefixes() {
  echo test
}

spec.setupFunctionNames() {
  echo config
}

spec.teardownFunctionNames() {
  echo cleanup
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

### Or implement your own output

```sh
# spec.config.sh

spec.displayTestResult() {
  local functionName="$3" # actual function name
  local name="$2"         # function name without prefix
                          # implement spec.getTestDisplayName() to generate yourself
  local status="$3"       # PASS or FAIL or PENDING
  local stdout="$4"       # STDOUT from the test (includes output from @setup and @teardown)
  local stderr="$5"       # STDERR from the test (includes output from @setup and @teardown)
}

spec.displayTestsSummary() {
  local status="$1" # PASS or FAIL
  local total="$2"
  local passed="$3"
  local failed="$4"
  local pending="$5"
  echo "$status. $total total tests. $passed passed, $failed failed, $pending unimplemented."
}
```

### Configuration

```sh
# Given a $1 function name (without prefix)
# return a formatted name, e.g. replace _ with ' '
spec.getTestDisplayName() {
  echo "${1/_/ }"
}

# Return list of function prefixes which designate
# a function as a test that should be executed
spec.specFunctionPrefixes() {
  echo @test. test @spec.
}

##
# For all of these, if you want to call the default
# implementation, just call `___spec___.[function name]`
##

# Example showing how to *extend* existing list
spec.specFunctionPrefixes() {
  echo myPrefix $(___spec___.specFunctionPrefixes)
}

# Prefixes which designate a function as a 'pending'
# test which is not yet implemented (and is not run)
spec.pendingFunctionPrefixes

# List names of functions which will be run before 
# and after each test is run (setup/teardown)
spec.setupFunctionNames
spec.teardownFunctionNames

# List names of functions which will be run before 
# and after each test file is run (setupFixure/teardownFixture)
spec.setupFixtureFunctionNames()
spec.teardownFixtureFunctionNames()

# Return a list of filenames which will be automatically detected
# sourced. Defaults include specHelper.sh and spec.config.sh.
# The whole file tree is searched (parent directories).
spec.helperFilenames()
```

### Display / Lifecycle Hooks

```
spec.loadHelpers
spec.beforeFile
  spec.displayTestsBanner
    spec.displayRunningTest
      spec.runTest
    spec.displayTestResult
  spec.displayTestsSummary
spec.afterFile
```
