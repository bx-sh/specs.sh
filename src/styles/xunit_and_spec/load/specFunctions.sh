spec.styles.xunit_and_spec.load.specFunctions() { ___spec___.styles.xunit_and_spec.load.specFunctions "$@"; }

___spec___.styles.xunit_and_spec.load.specFunctions() {
  local specFunctionPrefixes
  IFS=$'\n' read -d '' -ra specFunctionPrefixes < <(printf "$SPEC_FUNCTION_PREFIXES")

  local functionPrefix
  for functionPrefix in "${specFunctionPrefixes[@]}"
  do
    local specFunctions
    IFS=$'\n' read -d '' -ra specFunctions < <(declare -F | grep "^declare -f $functionPrefix" | sed 's/^declare -f //' )
    local specFunction
    for specFunction in "${specFunctions[@]}"
    do
      SPEC_FUNCTIONS+=("$specFunction")
      local displayName="${specFunction#"$functionPrefix"}"
      displayName="${displayName//_/ }"
      displayName="$( printf "$displayName" | sed 's/\([A-Z]\)/ \1/g' )"
      displayName="${displayName##[[:space:]]}"
      SPEC_DISPLAY_NAMES+=("$displayName")
    done
  done
}