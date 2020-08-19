spec.styles.spec.set.defaultSpecFunctionPrefixes() { ___spec___.styles.spec.set.defaultSpecFunctionPrefixes "$@"; }

___spec___.styles.spec.set.defaultSpecFunctionPrefixes() {
  [ -z "$SPEC_FUNCTION_PREFIXES" ] && SPEC_FUNCTION_PREFIXES="@spec.\n@example.\n@it."
}