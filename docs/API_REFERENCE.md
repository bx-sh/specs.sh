# ⚙️ User Variables

Environment variables for configuring the behavior of `spec.sh`

These can be exported in your shell or configured in `spec.config.sh`


### `$SPEC_FORMATTER`

- Sets the formatter to use, e.g.
  - `documentation` - default formatter, supports color, prints `[OK]` and `[FAIL]` messages for each spec
  - `tap` - [TAP-compliant](https://testanything.org/) output
  - `xml` - JUnit-style XML output (_used by many continuous integration platforms_
- The default syntax style is: `xunit_and_spec` which supports BOTH `xunit` and `spec` syntax


### `$SPEC_STYLE`

- Sets the syntax style to use, e.g.
  - `xunit` (_`testFoo()`_)
  - `spec` (_`@spec.foo()`_)
- The default syntax style is: `xunit_and_spec` which supports BOTH `xunit` and `spec` syntax


---

# 🎨 Customization API

`spec.sh` is extremely customizable.

This section provides documentation on the variables and functions you
may want to configure to customize `spec.sh` to meet your needs!

Every `spec.sh` function documented here can be overriden
by defining a new function in your `spec.config.sh` file.

For example:

```sh
# TODO
```

## Variables


### `$SPEC_THEME_STDOUT_COLOR`

- Default: `39` (default foreground color)
- Should be used by formatters when printing color of STDOUT text


### `$SPEC_THEME_STDERR_HEADER_COLOR`

- Default: `31;1` (bold red)
- Should be used by formatters when printing color of header for STDERR text


### `$SPEC_THEME_PASS_COLOR`

- Default: `32` (green)
- Should be used by formatters when printing color of passing specs or suites


### `$SPEC_THEME_SEPARATOR_COLOR`

- Default: `39` (default foreground color)
- Should be used by formatters when printing color of miscellaneous separators


### `$SPEC_THEME_ERROR_COLOR`

- Default: `31` (red)
- Should be used by formatters when printing color of errors


### `$SPEC_FILE_SUFFIXES`

- Sets the list of suffixes to use when searching directories for specs.
- Default: `.spec.sh:.test.sh`
- Can provide multiple `:`-separated suffixes


### `$SPEC_THEME_FILE_COLOR`

- Default: `39` (default foreground color)
- Should be used by formatters when printing color of file being run


### `$SPEC_COLOR`

- Default: `true`
- When not `true`, formatter should not use color output


### `$SPEC_THEME_TEXT_COLOR`

- Default: `39` (default foreground color)
- Should be used by formatters when printing color of miscellaneous text


### `$SPEC_THEME_STDERR_COLOR`

- Default: `39` (default foreground color)
- Should be used by formatters when printing color of STDERR text


### `$SPEC_THEME_STDOUT_HEADER_COLOR`

- Default: `34;1` (bold blue)
- Should be used by formatters when printing color of header for STDOUT text


### `$SPEC_THEME_SPEC_COLOR`

- Default: `39` (default foreground color)
- Should be used by formatters when printing color of spec being run


### `$SPEC_THEME_HEADER_COLOR`

- Default: `39` (default foreground color)
- Should be used by formatters when printing color of miscellaneous header text


### `$SPEC_THEME_PENDING_COLOR`

- Default: `33` (yellow)
- Should be used by formatters when printing color of pending specs


### `$SPEC_THEME_FAIL_COLOR`

- Default: `31` (red)
- Should be used by formatters when printing color of failed specs or suites



## Functions


#### `spec.display.formatters.documentation.before:run.specFile()`

- Displays the name of the file being run



#### `spec.set.defaultFormatter()`

- Sets the default formatter, e.g. `tap` or `documentation`
- The default style is: `documentation` which supports color and
  prints `[OK]` and `[FAIL]` status messages for each spec


#### `spec.set.defaultSpecFileSuffixes()`

- Sets default `SPEC_FILE_SUFFIXES` value: `.spec.sh:.test.sh`

#### `spec.run.specFunction()`


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


#### `spec.run.function()`

...


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


#### `spec.set.defaultStyle()`

- Sets the default style, e.g. `xunit` or `spec`
- The default style is: `xunit_and_spec` which supports BOTH xunit and spec syntax


#### `spec.set.defaultVariables()`

- Sets all default variables
- This is run BEFORE config files are loaded and therefore CANNOT be customized
- All of the default variables are set only if there isn't already a value present for the given variable
- To customize variables, either:
  - `export` an environment variable or pass it directly to `ENV= ./spec.sh` when running it
  - Simply set the variable in your `spec.config.sh`, e.g. `SPEC_FORMATTER=tap`


#### `spec.run.specFile()`

spec.runFile is run in a subshell by `spec.sh`

It accepts one command-line argument: path to the file


#### `spec.load.specFiles()`

Input: `SPEC_PATH_ARGUMENTS`

Responsible for populating `SPEC_FILE_LIST`

Default extensions defined in `SPEC_FILE_SUFFIXES`

Default behavior:

- Allow explicit files regardless of file extension

