spec.styles.spec.set.defaultPendingFunctionPrefixes() { ___spec___.styles.spec.set.defaultPendingFunctionPrefixes "$@"; }

___spec___.styles.spec.set.defaultPendingFunctionPrefixes() {
  [ -z "$SPEC_PENDING_FUNCTION_PREFIXES" ] && SPEC_PENDING_FUNCTION_PREFIXES="@pending.\n@xspec.\n@xexample.\n@xit."
}