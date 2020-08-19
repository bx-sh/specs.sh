spec.styles.xunit.set.defaultPendingFunctionPrefixes() { ___spec___.styles.xunit.set.defaultPendingFunctionPrefixes "$@"; }

___spec___.styles.xunit.set.defaultPendingFunctionPrefixes() {
  [ -z "$SPEC_PENDING_FUNCTION_PREFIXES" ] && SPEC_PENDING_FUNCTION_PREFIXES="xtest"
}