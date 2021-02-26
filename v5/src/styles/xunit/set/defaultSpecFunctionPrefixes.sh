spec.styles.xunit.set.defaultSpecFunctionPrefixes() { ___spec___.styles.xunit.set.defaultSpecFunctionPrefixes "$@"; }

___spec___.styles.xunit.set.defaultSpecFunctionPrefixes() {
  [ -z "$SPEC_FUNCTION_PREFIXES" ] && SPEC_FUNCTION_PREFIXES="test"
}