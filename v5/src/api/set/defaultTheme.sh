## @function spec.set.defaultTheme
##
## Sets variables uses for default theme used by some formatters:
##
## - `SPEC_COLOR`
## - `SPEC_THEME_TEXT_COLOR`
## - `SPEC_THEME_PASS_COLOR`
## - `SPEC_THEME_FAIL_COLOR`
## - `SPEC_THEME_PENDING_COLOR`
## - `SPEC_THEME_ERROR_COLOR`
## - `SPEC_THEME_FILE_COLOR`
## - `SPEC_THEME_SPEC_COLOR`
## - `SPEC_THEME_SEPARATOR_COLOR`
## - `SPEC_THEME_HEADER_COLOR`
## - `SPEC_THEME_STDOUT_COLOR`
## - `SPEC_THEME_STDERR_COLOR`
## - `SPEC_THEME_STDOUT_HEADER_COLOR`
## - `SPEC_THEME_STDERR_HEADER_COLOR`
##
## @variable SPEC_COLOR
##
## - Default: `true`
## - When not `true`, formatter should not use color output
##
## @variable SPEC_THEME_TEXT_COLOR
##
## - Default: `39` (default foreground color)
## - Should be used by formatters when printing color of miscellaneous text
##
## @variable SPEC_THEME_PASS_COLOR
##
## - Default: `32` (green)
## - Should be used by formatters when printing color of passing specs or suites
##
## @variable SPEC_THEME_FAIL_COLOR
##
## - Default: `31` (red)
## - Should be used by formatters when printing color of failed specs or suites
##
## @variable SPEC_THEME_PENDING_COLOR
##
## - Default: `33` (yellow)
## - Should be used by formatters when printing color of pending specs
##
## @variable SPEC_THEME_ERROR_COLOR
##
## - Default: `31` (red)
## - Should be used by formatters when printing color of errors
##
## @variable SPEC_THEME_FILE_COLOR
##
## - Default: `39` (default foreground color)
## - Should be used by formatters when printing color of file being run
##
## @variable SPEC_THEME_SPEC_COLOR
##
## - Default: `39` (default foreground color)
## - Should be used by formatters when printing color of spec being run
##
## @variable SPEC_THEME_SEPARATOR_COLOR
##
## - Default: `39` (default foreground color)
## - Should be used by formatters when printing color of miscellaneous separators
##
## @variable SPEC_THEME_HEADER_COLOR
##
## - Default: `39` (default foreground color)
## - Should be used by formatters when printing color of miscellaneous header text
##
## @variable SPEC_THEME_STDOUT_COLOR
##
## - Default: `39` (default foreground color)
## - Should be used by formatters when printing color of STDOUT text
##
## @variable SPEC_THEME_STDERR_COLOR
##
## - Default: `39` (default foreground color)
## - Should be used by formatters when printing color of STDERR text
##
## @variable SPEC_THEME_STDOUT_HEADER_COLOR
##
## - Default: `34;1` (bold blue)
## - Should be used by formatters when printing color of header for STDOUT text
##
## @variable SPEC_THEME_STDERR_HEADER_COLOR
##
## - Default: `31;1` (bold red)
## - Should be used by formatters when printing color of header for STDERR text
##

spec.set.defaultTheme() { ___spec___.set.defaultTheme "$@"; }

___spec___.set.defaultTheme() {
  [ -z "$SPEC_COLOR"                     ] && SPEC_COLOR="true"
  [ -z "$SPEC_THEME_TEXT_COLOR"          ] && SPEC_THEME_TEXT_COLOR=39
  [ -z "$SPEC_THEME_PASS_COLOR"          ] && SPEC_THEME_PASS_COLOR=32
  [ -z "$SPEC_THEME_FAIL_COLOR"          ] && SPEC_THEME_FAIL_COLOR=31
  [ -z "$SPEC_THEME_PENDING_COLOR"       ] && SPEC_THEME_PENDING_COLOR=33
  [ -z "$SPEC_THEME_ERROR_COLOR"         ] && SPEC_THEME_ERROR_COLOR=31
  [ -z "$SPEC_THEME_FILE_COLOR"          ] && SPEC_THEME_FILE_COLOR=34
  [ -z "$SPEC_THEME_SPEC_COLOR"          ] && SPEC_THEME_SPEC_COLOR=39
  [ -z "$SPEC_THEME_SEPARATOR_COLOR"     ] && SPEC_THEME_SEPARATOR_COLOR=39
  [ -z "$SPEC_THEME_HEADER_COLOR"        ] && SPEC_THEME_HEADER_COLOR=39
  [ -z "$SPEC_THEME_STDOUT_COLOR"        ] && SPEC_THEME_STDOUT_COLOR=39
  [ -z "$SPEC_THEME_STDERR_COLOR"        ] && SPEC_THEME_STDERR_COLOR=39
  [ -z "$SPEC_THEME_STDOUT_HEADER_COLOR" ] && SPEC_THEME_STDOUT_HEADER_COLOR="34;1"
  [ -z "$SPEC_THEME_STDERR_HEADER_COLOR" ] && SPEC_THEME_STDERR_HEADER_COLOR="31;1"
}