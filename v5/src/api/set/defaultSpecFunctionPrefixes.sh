## @variable SPEC_FUNCTION_PREFIXES
##
## - The list of prefixes to use when determing which functions "represent" spec/tests.
## - Both the `xunit` and `spec` formatters use this to store which function prefixes should be noted as tests
##   - e.g. `xunit` looks for functions starting with `test`
##   - e.g. `spec` looks for functions starting with `@spec.` or `@example.` or `@it.`
## - This is a `\n` separated value (_because function names can include the `:` character_)
##
## @function spec.set.defaultSpecFunctionPrefixes
##
## - Sets default `SPEC_FUNCTION_PREFIXES`
## - Delegates to currently set `SPEC_STYLE` to get the default values

spec.set.defaultSpecFunctionPrefixes() { ___spec___.set.defaultSpecFunctionPrefixes "$@"; }

___spec___.set.defaultSpecFunctionPrefixes() {
  local functionName="spec.styles.$SPEC_STYLE.set.defaultSpecFunctionPrefixes"
  [ "$( type -t "$functionName" )" = "function" ] && "$functionName" "$@"
}