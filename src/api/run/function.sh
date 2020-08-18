## @function spec.run.function
##
## ...
##

spec.run.function() { ___spec___.run.function "$@"; }

___spec___.run.function() {
  local functionName="$1"
  shift
  "$functionName" "$@"
}
