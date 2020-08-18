## @user @variable SPEC_FORMATTER
##
## - Sets the formatter to use, e.g.
##   - `documentation` - default formatter, supports color, prints `[OK]` and `[FAIL]` messages for each spec
##   - `tap` - [TAP-compliant](https://testanything.org/) output
##   - `xml` - JUnit-style XML output (_used by many continuous integration platforms_
## - The default syntax style is: `xunit_and_spec` which supports BOTH `xunit` and `spec` syntax
##

## @function spec.set.defaultFormatter
##
## - Sets the default formatter, e.g. `tap` or `documentation`
## - The default style is: `documentation` which supports color and
##   prints `[OK]` and `[FAIL]` status messages for each spec
##

spec.set.defaultFormatter() { ___spec___.set.defaultFormatter "$@"; }

___spec___.set.defaultFormatter() {
  [ -z "$SPEC_FORMATTER" ] && SPEC_FORMATTER="documentation"
}