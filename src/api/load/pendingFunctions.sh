## @function spec.load.pendingFunctions
##
## - Responsible for loading all functions which "represent"
##   specs/tests from the currently sourced environment
##   which are considered "pending" (_not implemented or should
##   not be run for another reason))
## - This function must populate 2 arrays:
##   - `SPEC_PENDING_FUNCTIONS`
##   - `SPEC_PENDING_DISPLAY_NAMES`
## - See `spec.load.pendingFunctions` for similar load operation
##

spec.load.pendingFunctions() { ___spec___.load.pendingFunctions "$@"; }

___spec___.load.pendingFunctions() {
  local functionName="spec.styles.$SPEC_STYLE.load.pendingFunctions"
  [ "$( type -t "$functionName" )" = "function" ] && "$functionName" "$@"
}