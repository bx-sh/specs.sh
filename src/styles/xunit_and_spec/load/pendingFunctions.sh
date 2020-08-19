spec.styles.xunit_and_spec.load.pendingFunctions() { ___spec___.styles.xunit_and_spec.load.pendingFunctions "$@"; }

___spec___.styles.xunit_and_spec.load.pendingFunctions() {
  local specFunctionPrefixes
  IFS=$'\n' read -d '' -ra specFunctionPrefixes < <(printf "$SPEC_PENDING_FUNCTION_PREFIXES")

  echo "XU/BDD LOAD PENDING ${#specFunctionPrefixes[@]} - ${specFunctionPrefixes[@]}"

  local functionPrefix
  for functionPrefix in "${specFunctionPrefixes[@]}"
  do
    local specFunctions
    IFS=$'\n' read -d '' -ra specFunctions < <(declare -F | grep "^declare -f $functionPrefix" | sed 's/^declare -f //' )
    local specFunction
    for specFunction in "${specFunctions[@]}"
    do
      SPEC_PENDING_FUNCTIONS+=("$specFunction")
      local displayName="${specFunction#"$functionPrefix"}"
      displayName="${displayName//_/ }"
      displayName="$( printf "$displayName" | sed 's/\([A-Z]\)/ \1/g' )"
      displayName="${displayName##[[:space:]]}"
      SPEC_PENDING_DISPLAY_NAMES+=("$displayName")
    done
  done
}