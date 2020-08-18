## @function spec.display.after:run.specFunction
##
## - Caller: `spec.run.specFile`
##
## - Variables:
##   - `SPEC_CURRENT_FUNCTION`
##   - `SPEC_CURRENT_EXITCODE`
##   - `SPEC_CURRENT_STATUS`
##   - `SPEC_CURRENT_STDOUT`
##   - `SPEC_CURRENT_STDERR`
##
## - Calls: `spec.display.formatters.$SPEC_FORMATTER.after:run.specFunction`
##
spec.display.after:run.specFunction() { ___spec___.display.after:run.specFunction "$@"; }

___spec___.display.after:run.specFunction() {
  local functionName="spec.display.formatters.$SPEC_FORMATTER.after:run.specFunction"
  [ "$( type -t "$functionName" )" = "function" ] && "$functionName" "$@"
}