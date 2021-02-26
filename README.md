# `v6` - VSCODE + ASYNC + SIMPLICITY + _source LOC_

START with VS CODE extension. As a STARTING point. ALWAYS use VS Code extension as THE WAY to run and manage Specs.sh tests.

^--- this is CRITICAL for having a ROCKIN SWEET AWESOMESAUCE developer experience.

Formatters: should be ONE FUNCTION, not a million.

Adapters: should be ONE FUNCTION, not a million.

ASYNC. Tests should be run in parallel by default. It should be WICKED FAST. `&`. Set some variable which is the # of concurrent.
If a test doens't work in parallel, it's not written properly, generally.

----

# TODO

- [X] Rename to `specs`
- [X] Fix colors / bold with resets
- [X] Indent output
- [ ] Show test run time and provide individual spec run times to formatters
- [ ] Include total numbers when there are multiple spec files (p1)
- [ ] Random order support (p3)
- [ ] TAP formatter (p1)
- [ ] Progress formatter (p3)
- [ ] JUnit XML formatter (p2)

---

[![Spec Status](https://github.com/bx-sh/specs.sh/workflows/Specs/badge.svg)](https://github.com/bx-sh/specs.sh/actions)

# `$ specs` - 🔬 Simple Shell Specifications

---

> - Small
> - Flexible
> - Simply BASH

---

Download the [latest version](https://github.com/bx-sh/specs.sh/archive/v0.3.0.tar.gz)

```sh
$ PATH="$PATH:spec/bin"

$ spec --version
spec version 0.3.0
```

---

## Shell Specifications

```sh
# [ my-file.spec.sh ]

@spec.one_equals_one() {
  [ 1 -eq 1 ]
}

@spec.one_equals_two() {
  [ 1 -eq 2 ]
}
```

```sh
$ spec my-file.spec.sh

[OK] one equals one
[FAIL] one equals two

Tests passed. 1 passed. 1 pending.
```

---

> ### Related Projects
>
> - ☑️ [`assert.sh`](https://github.com/bx-sh/assert.sh) - provides `assert [ 1 -eq 1 ]` syntax
> - 🧐 [`expect.sh`](https://github.com/bx-sh/expect.sh) - provides `expect 1 toEqual 1` syntax

---

#### Basics

- [Spec syntax](#spec-syntax) - (`@spec`)
- [Setup](#setup) - (`@setup`)
- [Teardown](#teardown) - (`@teardown`)
- [Pending](#pending) - (`@pending`)
- [Helper functions](#helper-functions) - (`myFunction()`)
- [Shared code](#shared-code) - (`specHelper.sh`)

#### Command-Line `spec`

- [Running specs](#running-spec) - (`spec`)
- [Running only certain specs](#running-only-certain-specs) - (`spec -e my_test`)
- [Printing spec names](#printing-spec-names) - (`spec -p`)
- [Configuration files](#configuration-files) - (`spec -c`)
- [Fail fast](#fail-fast) - (`spec -f`)

#### Customization

- [Custom spec definition syntax](#custom-spec-definition-syntax) - (`testHello()`)
- [Custom setup and teardown syntax](#custom-setup-and-teardown-syntax) - (`configure()`)
- [Extending existing configuration](#extending-existing-configuration) - (`___spec___.[fn]`)
- [Lifecycle event hooks](#livecycle-event-hooks) - (`spec.runSpecs`)
- [Custom display output](#custom-display-output) - (`spec.displaySpecResult`)
- [Customization API reference](#customization-api-reference) - (`$SPEC_CURRENT_FUNCTION`)

---

# Basics

## Spec syntax

Specs (or tests) are defined as simple BASH functions:

```sh
@spec.file_should_exist() {
  local expected_file_path="my-file.txt"
  [ -f "$expected_file_path" ]
}
```

#### ✅ Passing Specs

A spec will **`[PASS]`** when the function is run and returns a non-zero return code:

- ```sh
  @spec.this_spec_will_pass() {
    # ... something something ...
    return 0
  }
  ```

#### ❌ Failing Specs

A spec will **`[FAIL]`** when the function is run and either of these conditions occur:

- (a) The function exits with a non-zero exit code, e.g. **`exit 1`**
  ```sh
  @spec.this_spec_will_fail() {
    # ... something something ...
    exit 1
    # ... something something ...
  }
  ```
- (b) The the function returns a non-zero exit code, e.g. **`return 1`**
  ```sh
  @spec.this_spec_will_also_fail() {
    # ... something something ...
    return 1
  }
  ```

---

> #### ℹ Implicit Returns
>
> BASH functions implicitly return the return code of the last command run in the function:
>
> - It is common to write specs so the final command is used to determine if the spec will pass:
>   ```sh
>   @spec.verify_that_a_file_exists() {
>     local expected_file="my-file.txt"
>     [ -f "$expected_file" ]
>   }
>   ```
> - This behaves the same as the following example (showing an explicit return):
>   ```sh
>   @spec.verify_that_a_file_exists() {
>     local expected_file="my-file.txt"
>     [ -f "$expected_file" ]
>     return $?
>   }
>   ```

---

> Aliases:
>
> There are a number of aliases provided for defining spec functions in addition to `@spec.<test name>`
>
> - `@test.<test name>` can also be used
> - `@it.<test name>` can also be used
> - `@example.<test name>` can also be used

---

## Setup

It is common to have multiple specs in the same file which perform the same setup.

> In the following example, every individual test is creating a temporary directory:

```sh
@spec.verify_can_write_files_in_directory() {
  # Create temporary directory for this spec
  local directory="$( mktemp -d )"

  touch "$directory/foo"
  [ -f "$directory/foo" ]
}

@spec.verify_can_read_files_in_directory() {
  # Create temporary directory for this spec
  local directory="$( mktemp -d )"

  echo "Hello" > "$directory/foo"
  [ "$( cat "$directory/foo" )" = "Hello" ]
}

@spec.verify_can_list_files_in_directory() {
  # Create temporary directory for this spec
  local directory="$( mktemp -d )"

  touch "$directory/foo"
  touch "$directory/bar"

  local list="$( ls "$directory" )"
  [[ "$( ls "$directory" )" = *"foo"* ]] && [[ " ]]
}
```

To perform common operations before each test runs, define a **`@setup()`** function:

```sh
@setup() {
  # Create temporary directory for this spec
  directory="$( mktemp -d )"
}

@spec.verify_can_write_files_in_directory() {
  touch "$directory/foo"
  [ -f "$directory/foo" ]
}

@spec.verify_can_read_files_in_directory() {
  echo "Hello" > "$directory/foo"
  [ "$( cat "$directory/foo" )" = "Hello" ]
}

@spec.verify_can_list_files_in_directory() {
  touch "$directory/foo"
  touch "$directory/bar"

  local list="$( ls "$directory" )"
  [[ "$( ls "$directory" )" = *"foo"* ]] && [[ " ]]
}
```

`@setup` runs before **every** individual test is run.

If you want to perform some setup **once** before **all** of the tests are run, define a **`@setupFixture`** function:

```sh
@setupFixture() {
  echo "This runs once before running all of the tests in the file"
}

@setup() {
  echo "This runs before every test"
}
```

---

> Aliases:
>
> - `@setup` can also be named `@before`  
>    (_or `@globalSetup` / `@globalBefore` typically used in a `specHelper.sh`_)  
>    (_`@globalSetup` runs before `@setup`_)
>
> - `@setupFixture` can also be named `@beforeAll`  
>   _(or `@globalSetupFixture` / `@globalBeforeAll` typically used in a `specHelper.sh`)_  
>   _(`@globalSetupFixture` runs before `@setupFixture`)_

---

> #### ℹ Spec + Subshells
>
> `spec` runs every individual spec function inside of its own subshell.
>
> It is safe to set global variables in `@setup`, they will not effect your other tests.
>
> Note: if any `@setup` function exits, neither the spec nor the teardowns will run.

---

## Teardown

If you want to perform some cleanup after your tests, define a **`@teardown`** function:

```sh
@setup() {
  # Create temporary directory for this spec
  directory="$( mktemp -d )"
}

@teardown() {
  # After each spec, the temporary directory is deleted (presuming it was created OK)
  [ -n "$directory" ] && [ -d "$directory" ] && rm -r "$directory"
}

@spec.verify_can_write_files_in_directory() {
  touch "$directory/foo"
  [ -f "$directory/foo" ]
}

@spec.verify_can_read_files_in_directory() {
  echo "Hello" > "$directory/foo"
  [ "$( cat "$directory/foo" )" = "Hello" ]
}
```

`@teardown` runs after **every** individual test is run.

If you want to perform some cleanup **once** after **all** of the tests are run, define a **`@teardownFixture`** function:

```sh
@teardownFixture() {
  echo "This runs once after running all of the tests in the file"
}

@teardown() {
  echo "This runs after every test"
}
```

---

> Aliases:
>
> - `@teardown` can also be named `@after`  
>   _(or `@globalTeardown` / `@globalAfter` typically used in a `specHelper.sh`)_
>
> - `@teardownFixture` can also be named `@afterAll`  
>   _(or `@globalTeardown` / `@globalAfter` typically used in a `specHelper.sh`)_

---

> #### ℹ Test Cleanup
>
> The `@teardown` function runs after each test, even if the test fails.
>
> This is preferable to adding cleanup code to your tests:
>
> ```sh
> @spec.verify_can_write_files_in_directory() {
>   # Create temporary directory for this spec
>   local directory="$( mktemp -d )"
>
>   touch "$directory/foo"
>   [ -f "$directory/foo" ] || return 1
>
>   rm -r "$directory" # <--- this code will never run if the test fails
> }
> ```
>
> Always remember to put your test cleanup code into `@teardown` and not the test, itself.
>
> Note: if the `@teardown` function does not return a non-zero code, it will fail the test.
>
> Also note: `@teardown` has access to all variables set by `@setup` but does not have access
> to any variables created or changed by the spec or other teardown functions. The spec and all
> teardown functions are run inside subshells so that, if one exits, the rest will still run.
>
> Example: if you need to delete a file/directory after a spec runs, set the path in `@setup`.  
> This way both `@teardown` and your specs will have access to the path.

---

## Pending

Sometimes you may want to define a number of tests which you are not ready to implement yet.

You can define a test _which will not be run_ by using `@pending` in place of `@spec`

```sh
@setup() {
  # Create temporary directory for this spec
  directory="$( mktemp -d )"
}

@spec.verify_can_write_files_in_directory() {
  touch "$directory/foo"
  [ -f "$directory/foo" ]
}

@spec.verify_can_read_files_in_directory() {
  echo "Hello" > "$directory/foo"
  [ "$( cat "$directory/foo" )" = "Hello" ]
}

@pending.verify_can_list_files_in_directory() {
  :
}

@pending.verify_can_check_permissions_of_directory() {
  :
}

@pending.verify_only_readable_directories_are_used() {
  :
}
```

This is useful when initially defining tests or if you want to temporarily disable a test:

```sh
@setup() {
  # Create temporary directory for this spec
  directory="$( mktemp -d )"
}

@spec.verify_can_write_files_in_directory() {
  touch "$directory/foo"
  [ -f "$directory/foo" ]
}

# Hmm this test isn't working, let's mark it @pending for now
@pending.verify_can_read_files_in_directory() {
  echo "Hello" > "$directory/foo"
  [ "$( cat "$directory/foo" )" = "Not Hello" ]
}
```

---

> Aliases:
>
> There are a number of aliases provided for marking spec functions to not be run in addition to `@pending.`
>
> - `@xspec.<test name>` can also be used
> - `@xtest.<test name>` can also be used
> - `@xit.<test name>` can also be used
> - `@xexample.<test name>` can also be used
>
> For every supported `@spec.<test name>` syntax, you can use an `x` prefix to mark the spec as pending.

---

## Helper functions

Spec files are just BASH files. Don't be afraid to implement helper functions!

> These are silly examples, just a friendly reminder to use functions in your files when useful 🔬

```sh
getTemporaryDirectory() {
  mktemp -d
}

deleteDirectory() {
  [ -n "$1" ] && [ -d "$1" ] && rm -r "$1"
}

createFile() {
  local filename="$1"
  local content="$2"
  if [ -z "$content" ]
  then
    touch "$filename"
  else
    echo "$content" > "$filename"
  fi
}

@setup() {
  directory="$( getTemporaryDirectory )"
}

@teardown() {
  deleteDirectory "$directory"
}

@spec.verify_can_write_files_in_directory() {
  createFile "$directory/foo"

  [ -f "$directory/foo" ]
}

@spec.verify_can_read_files_in_directory() {
  createFile "$directory/foo" "Hello"

  [ "$( cat "$directory/foo" )" = "Hello" ]
}
```

## Shared code

You may find that your spec files have a lot of redundancy between them, e.g. loading the same dependencies:

```sh
source "dependency1.sh"
source "dependency2.sh"
source "dependency3.sh"
source "dependency4.sh"

@setup() {
  # ...
}

helperFunctionOne() {
  # ...
}

helperFunctionTwo() {
  # ...
}

```

If you move code into a `specHelper.sh` file, it will be automatically sourced into your spec files before tests are run:

```sh
# [ spec/specHelper.sh ]

source "dependency1.sh"
source "dependency2.sh"
source "dependency3.sh"
source "dependency4.sh"

@globalSetup() {
  # ...
}

helperFunctionOne() {
  # ...
}

helperFunctionTwo() {
  # ...
}
```

```sh
# [ spec/myFile.spec.sh ]

@spec.this_individual_spec() {
  helperFunctionOne
  # ...
```

This allows you to easily share dependencies between various `spec` source code files.

---

> #### ℹ Helper File Locations
>
> `spec` will search the path for `specHelper.sh` files.
>
> If your spec file is `/foo/bar/baz.spec.sh` then `spec` will search for:
>
> - `/specHelper.sh`
> - `/foo/specHelper.sh`
> - `/foo/bar/specHelper.sh`
>
> They will be loaded in this order, starting with parent directories.
>
> This allows you to define more generic `specHelper.sh` common code in your project in parent directories.
>
> More specific helpers should be added to `specHelper.sh` files in subdirectories.

---

> Aliases:
>
> In addition to `specHelper.sh`, `spec` also searches for the following filenames to autoload:
>
> - `testHelper.sh`
> - `helper.spec.sh`
> - `helper.test.sh`

---

# Command-Line `spec`

```sh
$ spec --help

spec version 0.2.6

Usage: spec [directory/ or file.spec.sh] [-f -p -e -c -h -v]

Options:

  -e, --name, --pattern [pattern]

  -c, --config [config file]

  -f, --fail-fast, --fast-fail

  -p, --print, --dry--run

  -h, --help

  -v, --version

Examples:

  spec file.spec.sh                   Runs file.spec.sh

  spec file.spec.sh another.spec.sh   Runs two spec files

  spec directory/                     Recursively searches directory/ for
                                      *.spec.sh and *.test.sh files to run

  spec                                Recursively searches current directory for
                                      *.spec.sh and *.test.sh files to run

  spec -e ^hello                      Runs tests with names that start with "hello"

  spec -e world$                      Runs tests with names that end with "world"

  spec -e "*world*"                   Runs tests containing "world"
```

## Running specs

To run a `spec` source file:

```sh
$ spec my-spec.spec.sh
```

> Your spec file can have any name, but `*.spec.sh` or `*.test.sh` are the most common

You can also run multiple spec files:

```sh
$ spec spec/first.spec.sh spec/second.spec.sh
```

You can also run all spec files in a directory by providing `spec` with the directory name:

```sh
$ spec spec/
```

> This will search the `spec/` directory for `*.spec.sh` and `*.test.sh` files

If you run `spec` with no arguments, it will run all spec files in the current directory:

```sh
$ spec
```

> This is the equivalent of running `spec ./` and searches for `*.spec.sh` and `*.test.sh` files

## Running only certain specs

You can run only tests which match a particular name/pattern by providing `-e pattern`

```sh
$ spec -e ^dog
```

> This will run only tests where the test name starts with "dog"

The `-e pattern` supports `^` (start with) `$` (end with) and `*` (wildcard search)

> The default `spec -e` behavior converts your text into a BASH regular expression.
>
> You can take advantage of this for more advanced matching. Note that `*` is translated into `.*`

## Printing spec names

You can print the names of spec functions and display names without running them by providing `-p`

```sh
$ spec -p
```

> This will list the names of all functions detected as spec functions as well as their display names

## Configuration files

Configuration files are used for customization and are loaded before `specHelper.sh` helper files.

You can provide a spec configuration file by providing `-c`

```sh
spec -c spec.config.sh
```

A `spec` configuration file is a simple BASH script which includes functions used for customization.

> See [Customization](#customization) below

You can also set the `SPEC_CONFIG` environment variable to the path of a file and it will be loaded.

> Configuration files are also auto-detected and loaded if named `spec.config.sh` or `test.config.sh`.  
> Explicitly provided configuration files via `-c` or `SPEC_CONFIG` are loaded before auto-loaded configs.

## Fail fast

If `spec` is provided multiple files, you can _stop_ running files after one fails by providing `-f`

```sh
$ spec -f
```

> This will run all detected test files but will stop running if a test file fails

---

# Customization

`spec` is incredibly customizable.

### Supported `spec` customizations

- Change syntax of functions detected as specs
- Change display output of test results
- Use lifecycle hooks to perform actions

## Custom spec definition syntax

By default, `spec` supports a number of commonly used keywords for defining specs:

- `@spec.<test name>`
- `@test.<test name>`
- `@it.<test name>`
- `@example.<test name>`

You can easily override or extend this functionality using configuration files in one of two ways:

1.  If you simply want a different prefix, override or extend `spec.specFunctionPrefixes`
2.  If you want to detect test functions in an entirely different way, override `spec.loadSpecFunctions`

Additionally, `spec` supports a number of commonly used keywords for defining pending specs:

- `@pending.<test name>`
- `@xspec.<test name>`
- `@xtest.<test name>`
- `@xit.<test name>`
- `@xexample.<test name>`

To extend or override the detection of pending specs:

1.  If you simply want a different prefix, override or extend `spec.pendingFunctionPrefixes`
2.  If you want to detect test functions in an entirely different way, override `spec.loadPendingFunctions`

### Example

> This example changes `spec` to use `testFoo`-style tests and `xtestFoo` pending tests

```sh
# [ spec.config.sh ]

# Update the config so all functions that start with 'test' will be considered test functions
spec.specFunctionPrefixes() {
  echo test
}

# Update the config so all functions that start with 'xtest' will be considered pending functions
spec.pendingFunctionPrefixes() {
  echo xtest
}
```

```sh
# [ my-test.test.sh ]

testHelloWorld() {
  # hey this works!
  :
}

xtestUnimplemented() {
  # this is now considered pending
  :
}
```

## Custom setup and teardown syntax

By default, `spec` supports a number of commonly used keywords for defining setup/teardown functions:

- `@setup` or `@before`
- `@teardown` or `@after`
- `@setupFixture` or `@beforeAll`
- `@teardownFixture` or `@afterAll`

Using configuration, you can provide a list of names for each of these types, e.g.

```sh
spec.setupFunctionNames() {
  echo @setup @before
}

spec.teardownFunctionNames() {
  echo @teardown @after
}

spec.setupFixtureFunctionNames() {
  echo @beforeAll @setupFixture
}

spec.teardownFixtureFunctionNames() {
  echo @afterAll @teardownFixture
}
```

If you wanted to change these, you can easily update these lists in your `spec.config.sh`

```sh
# [ spec.config.sh ]

spec.setupFunctionNames() {
  echo configure
}

spec.teardownFunctionNames() {
  echo cleanup
}

spec.setupFixtureFunctionNames() {
  echo prepareTests
}

spec.teardownFixtureFunctionNames() {
  echo cleanupEnvironment
}
```

And now the following will work!

```sh
prepareTests() {
  # This will run before all of the tests in this file are run
  :
}

cleanupEnvironment() {
  # This will run after all of the tests in this file have been run
  :
}

configure() {
  # This will run before each spec
  :
}

cleanup() {
  # This will run after each spec
  :
}

@spec.one() {
  # ...
  :
}

@spec.two() {
  # ...
  :
}
```

## Extending existing configuration

In the examples above, functions were added to `spec.config.sh` to override existing `spec` behavior.

Let's say that you want to continue to support `@setup` and `@before` but also support `configure`.

To extend any of the built-in `spec` functionality, call `___spec___.[config function name]`.

```sh
# Configure the names of functions which are detected and used as 'setup' functions
spec.setupFunctionNames() {
  # Print the default function names (this is like calling "super" in many programming languages)
  ___spec___.setupFunctionNames

  # Now add your own options:
  echo configure
}

# Same as above, this adds `cleanup` as an additional option for `@teardown`
spec.teardownFunctionNames() {
  echo cleanup $(___spec___.teardownFunctionNames)
}
```

## Lifecycle event hooks

This is the `spec` "order of operations" for extensibility purposes

For every file that is run by `spec`, the following is performed:

1. source `spec` source code including default implementations of all functions
1. source `SPEC_CONFIG` if provided via `spec -c config.sh` or `SPEC_CONFIG`` environment variable
1. `spec.loadConfigs` searches for and sources configs using names defined in `spec.configFilenames`
1. `spec.loadHelpers` searches for and sources helper files using names defined in `spec.helperFilenames`
1. `spec.beforeFile`
1. provided spec file is sourced
1. `spec.afterFile`
1. `spec.loadTests`
   1. `spec.loadSpecFunctions`
   1. `spec.loadPendingFunctions`
   1. `spec.loadSetupFunctions`
   1. `spec.loadSetupFixtureFunctions`
   1. `spec.loadTeardownFunctions`
   1. `spec.loadTeardownFixtureFunctions`
1. if `-p` or `--print` or `--dry-run` (the tests are printed and not run)
   1. `spec.listTests`
1. else
   1. `spec.runSpecs`
      1. `spec.displaySpecBanner`
      1. `spec.runSetupFixture` (called once for each setup fixture)
         - `spec.runFunction`
      1. for each test in the file...
         1. `spec.displayRunningSpec`
         1. `spec.runSpecWithSetupAndTeardown`
            1. `spec.runSetup` (called once for each setup function)
               - `spec.runFunction`
            1. **`spec.runSpec`**
               - `spec.runFunction`
            1. `spec.displaySpecResult`
            1. `spec.runTeardown` (called once for each teardown function)
               - `spec.runFunction`
         1. `spec.displaySpecResult` (called for each pending test after other tests have run)
      1. `spec.runTeardownFixture` (called once for each setup fixture)
         - `spec.runFunction`
      1. `spec.displaySpecSummary`

## Custom display output

> The code for this section can be found in the [`examples/formatter`](https://github.com/bx-sh/specs.sh/tree/master/examples/formatter) folder.

This section focuses on writing your own test display formatter.

You will want to reference [Lifecycle event hooks](#lifecycle-event-hooks).

The most useful functions for displaying test results are:

1. `spec.displaySpecBanner`
1. for each test in the file...
   1. `spec.displayRunningSpec`
   1. `spec.displaySpecResult`
1. `spec.displaySpecResult` (called for each pending test after other tests have run)
1. `spec.displaySpecSummary.g`

You will want to reference [Customization API reference](#customization-api-reference) for available variables and function parameters.

The most useful global variables for displaying test results are:

- `SPEC_FILE`
- `SPEC_CURRENT_FUNCTION`
- `SPEC_FUNCTION`
- `SPEC_NAME`
- `SPEC_STATUS`
- `SPEC_STDOUT`
- `SPEC_STDERR`
- `SPEC_TOTAL_COUNT`
- `SPEC_PENDING_COUNT`
- `SPEC_FAILED_COUNT`
- `SPEC_PASSED_COUNT`
- `SPEC_SUITE_STATUS`

To help you get started, we will...

- Create two example spec files
- Write a simple display formatter which outputs useful information for you to use
- Run the specs to see the output

That should get you started 🔬

### Example Specs

Create two files, `specOne.spec.sh` and `specTwo.spec.sh` and give the both this content:

```sh
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
  echo "This is an error message" >&2
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
```

### Example Formatter Implementation

Now create a `spec.config.sh` with the following content and place it in the same folder as your spec files.

```sh
# Display every function that is run
spec.runFunction() {
  echo -e "\t[RUN $SPEC_CURRENT_FUNCTION]"
  ___spec___.runFunction "$@"
}

# Print the file name
spec.displaySpecBanner() {
  echo "[Spec File: $SPEC_FILE]"
}

# Print the spec that is about to be run
spec.displayRunningSpec() {
  printf "\t> Running $SPEC_NAME ... "
}

# Print the spec result
spec.displaySpecResult() {
  echo "[$SPEC_STATUS]"
  echo
  if [ -n "$SPEC_STDERR" ]
  then
    echo -e "\t\tSTDERR: (($SPEC_STDERR))"
  fi
}

# Display summary of totals
spec.displaySpecSummary() {
  if [ $SPEC_TOTAL_COUNT -eq 0 ]
  then
    echo "No tests to run"
  elif [ $SPEC_FAILED_COUNT -gt 0 ]
  then
    echo "[$SPEC_SUITE_STATUS] Tests failed. $SPEC_PASSED_COUNT passed, $SPEC_FAILED_COUNT failed, $SPEC_PENDING_COUNT pending."
  else
    echo "[$SPEC_SUITE_STATUS] Tests failed. $SPEC_PASSED_COUNT passed, $SPEC_FAILED_COUNT failed, $SPEC_PENDING_COUNT pending."
  fi
}

```

### Example Formatter Output

Now run the specs:

```sh
$ spec specOne.spec.sh specTwo.spec.sh

[Spec File: examples/formatter/specOne.spec.sh]
	[RUN @setupFixture]
Hi from setupFixture. This function: @setupFixture This file examples/formatter/specOne.spec.sh
	> Running i fail ... [FAIL]

	> Running spec one ... [PASS]

		STDERR: ((This is an error message))
	> Running spec two ... [PASS]

	[RUN @teardownFixture]
Hi from teardownFixture. This function: @teardownFixture This file examples/formatter/specOne.spec.sh
	> Running i am pending ... [PENDING]

[FAIL] Tests failed. 2 passed, 1 failed, 1 pending.
[Spec File: examples/formatter/specTwo.spec.sh]
	[RUN @setupFixture]
Hi from setupFixture. This function: @setupFixture This file examples/formatter/specTwo.spec.sh
	> Running i fail ... [FAIL]

	> Running spec one ... [PASS]

		STDERR: ((This is an error message))
	> Running spec two ... [PASS]

	[RUN @teardownFixture]
Hi from teardownFixture. This function: @teardownFixture This file examples/formatter/specTwo.spec.sh
	> Running i am pending ... [PENDING]

[FAIL] Tests failed. 2 passed, 1 failed, 1 pending.

Tests failed
```

> Note: the STDOUT and STDERR of tests are captured and not shown unless you display them.
>
> `@setupFixture` and `@teardownFixture` functions run at the top-level and their output is shown (not captured)

---

# Customization API reference

## VARIABLES

| Name                                   | Description                                                                                         |
| -------------------------------------- | --------------------------------------------------------------------------------------------------- |
| `SPEC_CONFIG`                          | Path to provided spec config, if provided (see `spec -c`)                                           |
| `SPEC_CURRENT_FUNCTION`                | Full name of current function running (might be a setup function or spec or teardown)               |
| `SPEC_DIR`                             | Directory of the current spec file (relative)                                                       |
| `SPEC_DISPLAY_NAMES`                   | Array of display names for specs as generated by `getSpecDisplayName`                               |
| `SPEC_FAILED_COUNT`                    | Total number of failed specs for the current file                                                   |
| `SPEC_FILE`                            | Path of the current spec file (relative)                                                            |
| `SPEC_FUNCTION`                        | Full function name of the currently relevant spec function, e.g. provided before running function   |
| `SPEC_FUNCTION_NAMES`                  | Array of function names for specs (counterpart to `SPEC_DISPLAY_NAMES`)                             |
| `SPEC_NAME`                            | Display name of the currently relevant spec, e.g. provided before running function                  |
| `SPEC_NAME_PATTERN`                    | Pattern to use to filter test names, if any provided (see `spec -e`)                                |
| `SPEC_PASSED_COUNT`                    | Total number of passes specs for the current file                                                   |
| `SPEC_PENDING_COUNT`                   | Total number of pending specs for the current file                                                  |
| `SPEC_PENDING_DISPLAY_NAMES`           | Array of display bames for pending specs as generated by `getSpecDisplayName`                       |
| `SPEC_PENDING_FUNCTION_NAMES`          | Array of function names for pending specs (counterpart to `SPEC_PENDING_DISPLAY_NAMES`)             |
| `SPEC_PRINT_ONLY`                      | Set to `"true"` is `spec -p` or `spec --print` was called (list names of specs, but don't run them) |
| `SPEC_RESULT_CODE`                     | Exit/return code of last spec run                                                                   |
| `SPEC_SETUP_FIXTURE_FUNCTION_NAMES`    | Array of function names for setup fixtures (loaded by `loadSetupFixtureFunctions`)                  |
| `SPEC_SETUP_FUNCTION_NAMES`            | Array of function names for setup (loaded by `loadSetupFunctions`)                                  |
| `SPEC_STATUS`                          | `PASS` or `FAIL` or `PENDING` status of the most recently run spec                                  |
| `SPEC_STDERR`                          | `STDERR` content from the most recently run spec (including setup and teardown)                     |
| `SPEC_STDOUT`                          | `STDOUT` content from the most recently run spec (including setup and teardown)                     |
| `SPEC_SUITE_STATUS`                    | Final `PASS` or `FAIL` status for the current file                                                  |
| `SPEC_TEARDOWN_FIXTURE_FUNCTION_NAMES` | Array of function names for teardown fixtures (loaded by `loadTeardownFixtureFunctions`)            |
| `SPEC_TEARDOWN_FUNCTION_NAMES`         | Array of function names for teardown (loaded by `loadTeardownFunctions`)                            |
| `SPEC_TOTAL_COUNT`                     | Total number of specs for the current file                                                          |

## FUNCTIONS

All of these functions have access to the following variables:

- `SPEC_DIR`
- `SPEC_FILE`
- `SPEC_NAME_PATTERN`
- `SPEC_CONFIG`
- `SPEC_PRINT_ONLY`

#### `spec.afterFile`

> Caller: `spec` binary

- Called immediately after sourcing spec file

#### `spec.beforeFile`

> Caller: `spec` binary

- Called immediately before sourcing spec file

#### `spec.configFilenames`

> Caller: `spec.loadConfigs`  
> Default: `echo spec.config.sh test.config.sh`

- Function should echo a list of strings
- Each item will be used as the basename of a file to search for and load

#### `spec.displayRunningSpec`

> Display-only  
> Variables: has access to all variables loaded by `spec.loadTests`

- Called immediately before running a spec function (or the spec's first setup function)
- `SPEC_NAME` will be set to the spec's display name
- `SPEC_FUNCTION` will be set to the spec's function name

#### `spec.displaySpecBanner`

> Display-only  
> Variables: has access to all variables loaded by `spec.loadTests`

- Called before any tests in a provided file have been run
- Called immediately before the tests begin to run for the given file

#### `spec.displaySpecResult`

> Display-only  
> Variables: has access to all variables loaded by `spec.loadTests`

- Called after a test has been run (or skipped if pending)
- `SPEC_STATUS` will be set to `PASS` `FAIL` or `PENDING`
- `SPEC_RESULT_CODE` will be set to the numeric exit/return code from the test
  - If set to `1` this could be from the test or because a teardown function failed
- `SPEC_NAME` will be set to the spec's display name
- `SPEC_FUNCTION` will be set to the spec's function name

#### `spec.displaySpecSummary`

> Display-only  
> Variables: has access to all variables loaded by `spec.loadTests`

- Called after all of the specs in a file have been run
- `SPEC_SUITE_STATUS` will be set to `PASS` or `FAIL`
- `SPEC_TOTAL_COUNT` will be set to the total count of specs in this file
- `SPEC_PASSED_COUNT` will be set to the total number of specs which passed
- `SPEC_FAILED_COUNT` will be set to the total number of specs which failed
- `SPEC_PENDING_COUNT` will be set to the total number of pending specs

#### `spec.getSpecDisplayName`

> Callers: `spec.loadSpecFunctions`, `spec.loadPendingFunctions`

- Used to set `SPEC_NAME` provided the spec's function name
- `$1` - the spec function name _without_ the prefix, e.g. `foo` instead of `@spec.foo`
- `$2` - the full spec function name

#### `spec.helperFilenames`

> Caller: `spec.loadHelpers`  
> Default: `echo specHelper.sh testHelper.sh helper.spec.sh helper.test.sh`

- Function should echo a list of strings
- Each item will be used as the basename of a file to search for and load

#### `spec.listTests`

> Caller: `spec` binary  
> Variables: has access to all variables loaded by `spec.loadTests`

- Called when `spec` is called with the `-p` `--print` `--dry-run` option

#### `spec.loadConfigs`

> Caller: `spec` binary

- `SPEC_CONFIG` is loaded right before `spec.loadConfigs` is called
- `spec.loadConfigs` is the first of all of these functions to be called
- Called immediately after loading `spec` framework in preparation of running a test file
- Searches for config files using names provided by `spec.configFilenames`
- Files are sourced as they are found

#### `spec.loadHelpers`

> Caller: `spec` binary

- Called immediately after `spec.loadConfigs`
- Searches for helper files using names provided by `spec.configFilenames`
- Files are sourced as they are found

#### `spec.loadPendingFunctions`

> Caller: `spec.loadTests`

- Run after the spec file has been sourced (so `declare -F` can be used to get all function names)
- Responsible for populating the `SPEC_PENDING_FUNCTION_NAMES` array (used to display these functions later and get the total count of pending functions)
- Responsible for populating the `SPEC_PENDING_DISPLAY_NAMES` array using `spec.getSpecDisplayName`
- Uses `spec.pendingFunctionPrefixes` to get prefixes of functions to load into the array

#### `spec.loadSetupFixtureFunctions`

> Caller: `spec.loadTests`

- Run after the spec file has been sourced (so `declare -F` can be used to get all function names)
- Responsible for populating the `SPEC_SETUP_FIXTURE_FUNCTION_NAMES` array (used to run these functions later)
- Uses `spec.setupFixtureFunctionNames` to get the names of the functions to put into the array

#### `spec.loadSetupFunctions`

> Caller: `spec.loadTests`

- Run after the spec file has been sourced (so `declare -F` can be used to get all function names)
- Responsible for populating the `SPEC_SETUP_FUNCTION_NAMES` array (used to run these functions later)
- Uses `spec.setupFunctionNames` to get the names of the functions to put into the array

#### `spec.loadSpecFunctions`

> Caller: `spec.loadTests`

- Run after the spec file has been sourced (so `declare -F` can be used to get all function names)
- Responsible for populating the `SPEC_FUNCTION_NAMES` array (used to run these functions later and to get the total count of spec functions)
- Responsible for populating the `SPEC_DISPLAY_NAMES` array using `spec.getSpecDisplayName`
- Uses `spec.specFunctionPrefixes` to get prefixes of functions to load into the array

#### `spec.loadTeardownFixtureFunctions`

> Caller: `spec.loadTests`

- Run after the spec file has been sourced (so `declare -F` can be used to get all function names)
- Responsible for populating the `SPEC_TEARDOWN_FIXTURE_FUNCTION_NAMES` array (used to run these functions later)
- Uses `spec.teardownFixtureFunctionNames` to get the names of the functions to put into the array

#### `spec.loadTeardownFunctions`

> Caller: `spec.loadTests`

- Run after the spec file has been sourced (so `declare -F` can be used to get all function names)
- Responsible for populating the `SPEC_TEARDOWN_FUNCTION_NAMES` array (used to run these functions later)
- Uses `spec.teardownFunctionNames` to get the names of the functions to put into the array

#### `spec.loadTests`

> Caller: `spec` binary

- Responsible for loading all of these arrays:
  - `SPEC_FUNCTION_NAMES`
  - `SPEC_DISPLAY_NAMES`
  - `SPEC_PENDING_FUNCTION_NAMES`
  - `SPEC_PENDING_DISPLAY_NAMES`
  - `SPEC_SETUP_FUNCTION_NAMES`
  - `SPEC_TEARDOWN_FUNCTION_NAMES`
  - `SPEC_SETUP_FIXTURE_FUNCTION_NAMES`
  - `SPEC_TEARDOWN_FIXTURE_FUNCTION_NAMES`
- Does so by calling other `spec.load*` functions

#### `spec.pendingFunctionPrefixes`

> Caller: `spec.loadPendingFunctions`

- Function should echo a list of strings
- Each item will be used as a valid prefix for functions to be considered as pending specs

#### `spec.runFunction`

> Callers: `spec.runSpec`, `spec.runSetup`, `spec.runSetupFixture`, `spec.runTeardown`, `spec.runTeardownFixture`

- Invoked anytime a function such as a spec or setup function is called
- Should simply invoke the function

#### `spec.runSetup`

> Caller: `spec.runSpecWithSetupAndTeardown`

- NOT run inside a subshell because it needs to be able to set global environment variables for spec/teardowns
- Invoked anytime a setup function is called (possible for there to be multiple for a single spec)
- Default implementation simply passes the value to `spec.runFunction` to be run

#### `spec.runSetupFixture`

> Caller: `spec.runSpecs`

- Invoked anytime a setup fixture function is called (possible for there to be multiple for a single file)
- Default implementation simply passes the value to `spec.runFunction` to be run

#### `spec.runTeardown`

> Caller: `spec.runSpecWithSetupAndTeardown`

- Run inside a subshell so that other teardowns will run if one fails
- Note: does not have access to any variables set by the spec, only by the setup
- Invoked anytime a teardown function is called (possible for there to be multiple for a single spec)
- Default implementation simply passes the value to `spec.runFunction` to be run

#### `spec.runTeardownFixture`

> Caller: `spec.runSpecs`

- Invoked anytime a teardown fixture function is called (possible for there to be multiple for a single file)
- Default implementation simply passes the value to `spec.runFunction` to be run

#### `spec.runSpec`

> Caller: `spec.runSpecWithSetupAndTeardown`

- Run inside a subshell so that teardowns may be run if the spec fails
- Invoked anytime a spec function is called
- Default implementation simply passes the value to `spec.runFunction` to be run

#### `spec.runSpecs`

> Caller: `spec` binary

- Default implementation uses these arrays to get all specs and setup/teardown functions:
  - `SPEC_FUNCTION_NAMES`
  - `SPEC_DISPLAY_NAMES`
  - `SPEC_PENDING_FUNCTION_NAMES`
  - `SPEC_PENDING_DISPLAY_NAMES`
  - `SPEC_SETUP_FUNCTION_NAMES`
  - `SPEC_TEARDOWN_FUNCTION_NAMES`
  - `SPEC_SETUP_FIXTURE_FUNCTION_NAMES`
  - `SPEC_TEARDOWN_FIXTURE_FUNCTION_NAMES`
- Loops through all setup fixture, setup, spec, teardown, and teardown fixture functions as expected
- Invokes functions using their respective `spec.run<function type>` functions, e.g. `spec.runSetup`
- Invokes display functions, see [Lifecycle event hooks](#lifecycle-event-hooks) for a full list
- Sets function values as appropriate while running, e.g. sets these values at certain times:
  - `SPEC_CURRENT_FUNCTION`
  - `SPEC_RESULT_CODE`
  - `SPEC_STDOUT`
  - `SPEC_STDERR`
  - `SPEC_STATUS`
  - `SPEC_NAME`
  - `SPEC_FUNCTION`
  - `SPEC_TOTAL_COUNT`
  - `SPEC_PASSED_COUNT`
  - `SPEC_FAILED_COUNT`
  - `SPEC_PENDING_COUNT`

#### `spec.runSpecWithSetupAndTeardown`

> Caller: `spec.runSpecs`

- Invoked in a subshell by `spec.runSpecs` and the `STDOUT` / `STDERR` captured
- Expects `SPEC_FUNCTION` to be set
- Sets `SPEC_CURRENT_FUNCTION` for each function that is called internally
- Runs all setups from `SPEC_SETUP_FUNCTION_NAMES` (stops if one fails)
- Runs all teardowns from `SPEC_SETUP_FUNCTION_NAMES` (runs all eveb if test fails)
- Returns status code representing whether or not the test failed

#### `spec.setupFixtureFunctionNames`

> Caller: `spec.loadSetupFixtureFunctions`

- Function should echo a list of strings
- Each item will be used as a valid function name which, if present, will be considered a setup fixture function

#### `spec.setupFunctionNames`

> Caller: `spec.loadSetupFunctions`

- Function should echo a list of strings
- Each item will be used as a valid function name which, if present, will be considered a setup function

#### `spec.specFunctionPrefixes`

> Caller: `spec.loadSpecFunctions`

- Function should echo a list of strings
- Each item will be used as a valid prefix for functions to be considered as specs

#### `spec.specNameMatchesPattern`

> Callers: `spec.loadSpecFunctions`, `spec.loadPendingFunctions`

- Predicate function returns 0 or 1 depending on if the provided spec matches the `SPEC_NAME_PATTERN`
- `$1`: full spec function name
- `$2`: spec function name without prefix, e.g. `foo_bar` rather than `@spec.foo_bar`
- `$3`: spec display name, e.g. `foo bar` rather than `foo_bar` (see: `spec.getSpecDisplayName`)
- `$4`: pattern (same value as `SPEC_PATTERN_NAME`)

#### `spec.teardownFixtureFunctionNames`

> Caller: `spec.loadTeardownFixtureFunctions`

- Function should echo a list of strings
- Each item will be used as a valid function name which, if present, will be considered a teardown fixture function

#### `spec.teardownFunctionNames`

> Caller: `spec.loadTeardownFunctions`

- Function should echo a list of strings
- Each item will be used as a valid function name which, if present, will be considered a teardown function
