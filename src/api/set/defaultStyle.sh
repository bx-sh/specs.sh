## @user @variable SPEC_STYLE
##
## - Sets the syntax style to use, e.g.
##   - `xunit` (_`testFoo()`_)
##   - `spec` (_`@spec.foo()`_)
## - The default syntax style is: `xunit_and_spec` which supports BOTH `xunit` and `spec` syntax
##

## @function spec.set.defaultStyle
##
## - Sets the default style, e.g. `xunit` or `spec`
## - The default style is: `xunit_and_spec` which supports BOTH xunit and spec syntax
##

spec.set.defaultStyle() { ___spec___.set.defaultStyle "$@"; }

___spec___.set.defaultStyle() {
  [ -z "$SPEC_STYLE" ] && SPEC_STYLE="xunit_and_spec"
}