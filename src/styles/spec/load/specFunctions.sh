spec.styles.spec.load.specFunctions() { ___spec___.styles.spec.load.specFunctions "$@"; }

___spec___.styles.spec.load.specFunctions() {
  IFS=$'\n' read -d '' -ra specFunctions < <(declare -F | grep "^declare -f @spec\." | sed 's/^declare -f //' )
  local specFunction
  for specFunction in "${specFunctions[@]}"
  do
    SPEC_FUNCTIONS+=("$specFunction")
    SPEC_DISPLAY_NAMES+=("$( echo "$specFunction" | sed 's/^@spec\.//' | sed 's/_/ /g' )")
  done
}