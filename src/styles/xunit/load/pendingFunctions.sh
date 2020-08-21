spec.styles.xunit.load.pendingFunctions() { ___spec___.styles.xunit.load.pendingFunctions "$@"; }

___spec___.styles.xunit.load.pendingFunctions() {
  local specFunctionPrefixes
  IFS=$'\n' read -d '' -ra specFunctionPrefixes < <(printf "$SPEC_PENDING_FUNCTION_PREFIXES")

  local functionPrefix
  for functionPrefix in "${specFunctionPrefixes[@]}"
  do
    local specFunctions
    IFS=$'\n' read -d '' -ra specFunctions < <(declare -F | grep "^declare -f $functionPrefix" | sed 's/^declare -f //' )
    local specFunction
    for specFunction in "${specFunctions[@]}"
    do
      SPEC_PENDING_FUNCTIONS+=("$specFunction")
      local functionNameWithoutPrefix="${specFunction#"$functionPrefix"}"
      local displayName="$( spec.get.functionDisplayName "$functionNameWithoutPrefix" )"
      SPEC_PENDING_DISPLAY_NAMES+=("$displayName")
    done
  done
}