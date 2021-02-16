## 🎨 User Configuration

Environment variables for configuring the behavior of `specs.sh`

These can be exported in your shell or configured in `spec.config.sh`

 - Export variables
   ```sh
   export SPEC_FORMATTER=tap

   ./specs.sh file.spec.sh dir/
   ```
 - Set variables in `spec.config.sh`
   ```sh
   # spec.config.sh

   SPEC_FORMATTER=tap
   ```

> Note: `spec.config.sh` runs _after_ default variables are configured.


## `$SPEC_FORMATTER`

- Sets the formatter to use, e.g.
  - `documentation` - default formatter
    - supports color
    - prints `[OK]` and `[FAIL]` messages for each spec
  - `tap` - [TAP-compliant](https://testanything.org/) output
    - See [testanything.org](https://testanything.org/) for more information
  - `xml` - JUnit-style XML output
    - (_XML format used by many continuous integration platforms_
- The default syntax style is: `xunit_and_spec` which supports BOTH `xunit` and `spec` syntax


## `$SPEC_STYLE`

- Sets the syntax style to use, e.g.
  - `xunit` (_`testFoo()`_)
  - `spec` (_`@spec.foo()`_)
- The default syntax style is: `xunit_and_spec` which supports BOTH `xunit` and `spec` syntax


---

# 🛠️ Customization API

`specs.sh` is extremely customizable.

This section provides documentation on the variables and functions you
may want to configure to customize `specs.sh` to meet your needs!

Every `specs.sh` function documented here can be overriden
by defining a new function in your `spec.config.sh` file.

For example:

```sh
# TODO
```

## Variables


### `$SPEC_COLOR`

- Default: `true`
- When not `true`, formatter should not use color output


### `$SPEC_FILE_SUFFIXES`

- Sets the list of suffixes to use when searching directories for specs.
- Default: `.spec.sh:.test.sh`
- Can provide multiple `:`-separated suffixes


### `$SPEC_FUNCTION_PREFIXES`

- The list of prefixes to use when determing which functions "represent" spec/tests.
- Both the `xunit` and `spec` formatters use this to store which function prefixes should be noted as tests
  - e.g. `xunit` looks for functions starting with `test`
  - e.g. `spec` looks for functions starting with `@spec.` or `@example.` or `@it.`
- This is a `\n` separated value (_because function names can include the `:` character_)


### `$SPEC_PENDING_FUNCTION_PREFIXES`

- The list of prefixes to use when determing which functions "represent"
  spec/tests which are not yet implemented or should not be run for some other reason, aka "pending" specs.
- Both the `xunit` and `spec` formatters use this to store which function prefixes should be noted as pending specs.
  - e.g. `xunit` looks for functions starting with `xtest`
  - e.g. `spec` looks for functions starting with a variety of prefixes:
    - `@pending.` or `@xspec.` or `@xexample.` or `@xit.` or `@_.`
- This is a `\n` separated value (_because function names can include the `:` character_)


### `$SPEC_THEME_ERROR_COLOR`

- Default: `31` (red)
- Should be used by formatters when printing color of errors


### `$SPEC_THEME_FAIL_COLOR`

- Default: `31` (red)
- Should be used by formatters when printing color of failed specs or suites


### `$SPEC_THEME_FILE_COLOR`

- Default: `39` (default foreground color)
- Should be used by formatters when printing color of file being run


### `$SPEC_THEME_HEADER_COLOR`

- Default: `39` (default foreground color)
- Should be used by formatters when printing color of miscellaneous header text


### `$SPEC_THEME_PASS_COLOR`

- Default: `32` (green)
- Should be used by formatters when printing color of passing specs or suites


### `$SPEC_THEME_PENDING_COLOR`

- Default: `33` (yellow)
- Should be used by formatters when printing color of pending specs


### `$SPEC_THEME_SEPARATOR_COLOR`

- Default: `39` (default foreground color)
- Should be used by formatters when printing color of miscellaneous separators


### `$SPEC_THEME_SPEC_COLOR`

- Default: `39` (default foreground color)
- Should be used by formatters when printing color of spec being run


### `$SPEC_THEME_STDERR_COLOR`

- Default: `39` (default foreground color)
- Should be used by formatters when printing color of STDERR text


### `$SPEC_THEME_STDERR_HEADER_COLOR`

- Default: `31;1` (bold red)
- Should be used by formatters when printing color of header for STDERR text


### `$SPEC_THEME_STDOUT_COLOR`

- Default: `39` (default foreground color)
- Should be used by formatters when printing color of STDOUT text


### `$SPEC_THEME_STDOUT_HEADER_COLOR`

- Default: `34;1` (bold blue)
- Should be used by formatters when printing color of header for STDOUT text


### `$SPEC_THEME_TEXT_COLOR`

- Default: `39` (default foreground color)
- Should be used by formatters when printing color of miscellaneous text



## Functions


#### `spec.display.after:run.specFunction()`

- Caller: `spec.run.specFile`

- Variables:
  - `SPEC_CURRENT_FUNCTION`
  - `SPEC_CURRENT_EXITCODE`
  - `SPEC_CURRENT_STATUS`
  - `SPEC_CURRENT_STDOUT`
  - `SPEC_CURRENT_STDERR`

- Calls: `spec.display.formatters.$SPEC_FORMATTER.after:run.specFunction`


#### `spec.display.formatters.documentation.after:run.specFunction()`

- Displays `[PASS]` or `[FAIL]` or `[PENDING]` with name of spec


#### `spec.display.formatters.documentation.before:run.specFile()`

- Displays the name of the file being run



#### `spec.get.functionDisplayName()`
- Provided a full function name (`$1`), e.g. `testFooBar` or `@spec.foo_bar`
- Return a display name (via `printf`), e.g. `Foo Bar` or `foo bar`
- Delegates to the currently selected `SPEC_STYLE` (else prints the arguments given)

> Note: this delegates to the STYLE rather than the FORMATTER because
> the STYLE is responsible for figuring out what functions are spec
> functions and pending functions, etc, which may use a certain DSL.
>
> To update the output for a FORMATTER, see functions such as:
> - `spec.display.after:run.specFunction`


#### `spec.load.pendingFunctions()`

- Responsible for loading all functions which "represent"
  specs/tests from the currently sourced environment
  which are considered "pending" (_not implemented or should
  not be run for another reason))
- This function must populate 2 arrays:
  - `SPEC_PENDING_FUNCTIONS`
  - `SPEC_PENDING_DISPLAY_NAMES`
- See `spec.load.pendingFunctions` for similar load operation


#### `spec.load.specFiles()`

- Input: `SPEC_PATH_ARGUMENTS`
- Responsible for populating `SPEC_FILE_LIST`
- Default extensions defined in `SPEC_FILE_SUFFIXES`

Default behavior:

- Allow explicit files regardless of file extension

#### `spec.load.specFunctions()`

- Responsible for loading all functions which "represent"
  specs/tests from the currently sourced environment.
- This runs after the spec file has already been sourced.
  If you need to compare the state before/after the spec
  file has been sourced, look into overriding `spec.source.specFile`
- This function must populate 2 arrays:
  - `SPEC_FUNCTIONS` which should contain the full function
     names of all functions which "represent" specs/tests
  - `SPEC_DISPLAY_NAMES` which should contain the "pretty" display
    names for each function. To get a display name for a function,
    you use the same array index (and vice versa). These arrays must
    have an equal length and every function must have a display name.


#### `spec.run.function()`

...


#### `spec.run.specFile()`

- `spec.runFile` is run in a subshell by `specs.sh`
- It accepts one command-line argument: path to the file


#### `spec.run.specFunction()`


#### `spec.set.defaultFormatter()`

- Sets the default formatter, e.g. `tap` or `documentation`
- The default style is: `documentation` which supports color and
  prints `[OK]` and `[FAIL]` status messages for each spec


#### `spec.set.defaultPendingFunctionPrefixes()`

- Sets default `SPEC_FUNCTION_PREFIXES`
- Delegates to currently set `SPEC_STYLE` to get the default values

#### `spec.set.defaultSpecFileSuffixes()`

- Sets default `SPEC_FILE_SUFFIXES` value: `.spec.sh:.test.sh`

#### `spec.set.defaultSpecFunctionPrefixes()`

- Sets default `SPEC_FUNCTION_PREFIXES`
- Delegates to currently set `SPEC_STYLE` to get the default values

#### `spec.set.defaultStyle()`

- Sets the default style, e.g. `xunit` or `spec`
- The default style is: `xunit_and_spec` which supports BOTH xunit and spec syntax


#### `spec.set.defaultTheme()`

Sets variables uses for default theme used by some formatters:

- `SPEC_COLOR`
- `SPEC_THEME_TEXT_COLOR`
- `SPEC_THEME_PASS_COLOR`
- `SPEC_THEME_FAIL_COLOR`
- `SPEC_THEME_PENDING_COLOR`
- `SPEC_THEME_ERROR_COLOR`
- `SPEC_THEME_FILE_COLOR`
- `SPEC_THEME_SPEC_COLOR`
- `SPEC_THEME_SEPARATOR_COLOR`
- `SPEC_THEME_HEADER_COLOR`
- `SPEC_THEME_STDOUT_COLOR`
- `SPEC_THEME_STDERR_COLOR`
- `SPEC_THEME_STDOUT_HEADER_COLOR`
- `SPEC_THEME_STDERR_HEADER_COLOR`


#### `spec.set.defaultVariables()`

- Sets all default variables
- This is run BEFORE config files are loaded and therefore CANNOT be customized
- All of the default variables are set only if there isn't already a value present for the given variable
- To customize variables, either:
  - `export` an environment variable or pass it directly to `ENV= ./specs.sh` when running it
  - Simply set the variable in your `spec.config.sh`, e.g. `SPEC_FORMATTER=tap`


#### `spec.source.specFile()`

- Responsible for `source`-ing the provided spec file (provided as `$1`)
- File name also available via `SPEC_CURRENT_FILEPATH`

