# ⚙️ Variables

Environment variables for configuring the behavior of `spec.sh`

These can be exported in your shell or configured in `spec.config.sh`


---

# 🎨 Customization API

`spec.sh` is extremely customizable

This documents the variables and functions you may want to override
to customize `spec.sh` to meet your needs.

Every `spec.sh` function documented here can be overriden
by defining a new function in your `spec.config.sh` file.

For example:

```sh
# TODO
```

## Variables



## Functions


### `spec.display.formatters.documentation.before:run.specFile`

something about SPEC_FORMATTER_DOCUMENTATION_FILE_COLOR

# this is a header


### `spec.run.specFunction`

...


### `spec.run.function`

...


### `spec.run.specFile`

spec.runFile is run in a subshell by `spec.sh`

It accepts one command-line argument: path to the file


### `spec.load.specFiles`

Input: `SPEC_PATH_ARGUMENTS`

Responsible for populating `SPEC_FILE_LIST`

Default extensions defined in `SPEC_FILE_SUFFIXES`

Default behavior:

- Allow explicit files regardless of file extension

