# 🔬 `@spec`

Simple Shell Specifications.

---

> - Small
> - Flexible
> - Simply BASH

---

Download the [latest version](https://github.com/bx-sh/spec.sh/archive/v0.2.3.tar.gz)

```sh
$ PATH="$PATH:spec/bin"

$ spec --version
spec version 0.2.3
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

- [Spec syntax](#foo) - (`@spec`)
- [Setup](#foo) - (`@setup`)
- [Teardown](#foo) - (`@teardown`)
- [Pending](#foo) - (`@pending`)
- [Helper functions](#foo) - (`myFunction()`)
- [Shared code](#foo) - (`specHelper.sh`)

#### Command-Line `spec`

- [Running specs](#foo) - (`spec`)
- [Running only certain specs](#foo) - (`spec -e my_test`)
- [Printing spec names](#foo) - (`spec -p`)
- [Configuration files](#foo) - (`spec -c`)
- [Fail fast](#foo) - (`spec -f`)

#### Customization

- [Custom spec definition syntax](#foo)
- [Custom setup and teardown syntax](#foo)
- [Extending existing configuration](#foo)
- [Lifecycle event hooks](#foo)
- [Custom display output](#foo)
- [Customization API reference](#foo)

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
> - `@setupFixture` can also be named `@beforeAll`

---

> #### ℹ Spec + Subshells
>
> `spec` runs every individual spec function inside of its own subshell.
>
> It is safe to set global variables in `@setup`, they will not effect your other tests.

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
  [ -n "$directory" ] && [ -d "$directory" ] && rm -rf "$directory"
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
> - `@teardownFixture` can also be named `@afterAll`

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
>   rm -rf "$directory" # <--- this code will never run if the test fails
> }
> ```
>
> Always remember to put your test cleanup code into `@teardown` and not the test, itself.
>
> Note: if the `@teardown` function does not return a non-zero code, it will fail the test.

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
  [ -n "$1" ] && [ -d "$1" ] && rm -rf "$1"
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

spec version 0.2.4

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

The `-e pattern` is used as a BASH regular expression

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
  echo @configure
}

spec.teardownFunctionNames() {
  echo @cleanup
}

spec.setupFixtureFunctionNames() {
  echo @prepareTests
}

spec.teardownFixtureFunctionNames() {
  echo @cleanupEnvironment
}
```

And now the following will work!

```sh
@prepareTests() {
  # This will run before all of the tests in this file are run
  :
}

@cleanupEnvironment() {
  # This will run after all of the tests in this file have been run
  :
}

@configure() {
  # This will run before each spec
  :
}

@cleanup() {
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

Let's say that you want to continue to support `@setup` and `@before` but also support `@configure`.

To extend any of the built-in `spec` functionality, call `___spec___.[config function name]`.

```sh
# Configure the names of functions which are detected and used as 'setup' functions
spec.setupFunctionNames() {
  # Print the default function names (this is like calling "super" in many programming languages)
  ___spec___.setupFunctionNames

  # Now add your own options:
  echo @configure
}

# Same as above, this adds `@cleanup` as an additional option for `@teardown`
spec.teardownFunctionNames() {
  echo @cleanup $(___spec___.teardownFunctionNames)
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
   1. `spec.runTests`
      1. `spec.displayTestsBanner`
      1. `spec.runSetupFixture` (called once for each setup fixture)
      1. for each test in the file...
         1. `spec.displayRunningTest`
         1. `spec.runSetup` (called once for each setup function)
         1. **`spec.runTest`**
         1. `spec.displayTestResult`
         1. `spec.runTeardown` (called once for each teardown function)
      1. `spec.runTeardownFixture` (called once for each setup fixture)
      1. `spec.displayTestResult` (called for each pending test after other tests have run)
      1. `spec.displayTestsSummary`

## Custom display output

This section focuses on writing your own test display formatter.

You will want to reference [Lifecycle event hooks](#lifecycle-event-hooks).

The most useful functions for displaying test results are:

1. `spec.displayTestsBanner`
1. for each test in the file...
   1. `spec.displayRunningTest`
   1. `spec.displayTestResult`
1. `spec.displayTestResult` (called for each pending test after other tests have run)
1. `spec.displayTestsSummary`

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

To help you get started, we will...

- Create two example spec files
- Write a simple display formatter which outputs useful information for you to use
- Run the specs to see the output

That should get you started 🔬

### Example Specs

### Example Formatter Implementation

### Example Formatter Output

## Customization API reference
