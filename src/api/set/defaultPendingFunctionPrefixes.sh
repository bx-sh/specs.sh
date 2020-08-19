## @variable SPEC_PENDING_FUNCTION_PREFIXES
##
## - The list of prefixes to use when determing which functions "represent"
##   spec/tests which are not yet implemented or should not be run for some other reason, aka "pending" specs.
## - Both the `xunit` and `spec` formatters use this to store which function prefixes should be noted as pending specs.
##   - e.g. `xunit` looks for functions starting with `xtest`
##   - e.g. `spec` looks for functions starting with a variety of prefixes:
##     - `@pending.` or `@xspec.` or `@xexample.` or `@xit.` or `@_.`
## - This is a `\n` separated value (_because function names can include the `:` character_)
##
## @function spec.set.defaultPendingFunctionPrefixes
##
## - Sets default `SPEC_FUNCTION_PREFIXES`
## - Delegates to currently set `SPEC_STYLE` to get the default values

spec.set.defaultPendingFunctionPrefixes() { ___spec___.set.defaultPendingFunctionPrefixes "$@"; }

___spec___.set.defaultPendingFunctionPrefixes() {
  local functionName="spec.styles.$SPEC_STYLE.set.defaultPendingFunctionPrefixes"
  [ "$( type -t "$functionName" )" = "function" ] && "$functionName" "$@"
}